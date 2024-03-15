#!/usr/bin/env python3
###################################################################
# Telecom Paris - J-L. Dessalles 2023                             #
# IA312 - Natural Language Processing                             #
#            http://teaching.dessalles.fr/CANLP                   #
###################################################################

" Bottom-up Chart-parsing "

import re
import copy
import syn_Grammar
from syn_util import trace, Tree_, stop

Correction___ = 1


class Edge:
	def __init__(self, StartPos, EndPos, Cat, Done, Rest, Tree, Comment):
		"""
			edge(StartPos, EndPos, Cat, Done, Rest, Tree, Comment)
			This indicates that a candidate phrase of type 'Cat' may start from 'StartPos'
			StartPos:	Position in input of the first word of the candidate phrase
			EndPos:	Position in input of the last recognized word for the candidate phrase
			Cat:			left hand side of the candidate rule
			Done:		list of categories in the right-hand side of the candidate rule that have been recognized
			Rest:		list of categories in the right-hand side of the candidate rule that are not yet recognized
			Tree:				tree for display
			Comment: comment for trace
		"""
		self.StartPos = StartPos
		self.EndPos = EndPos
		self.Cat = Cat
		self.Done = Done
		self.Rest = Rest
		self.Tree = Tree
		self.Comment = Comment
		
	def inactive(self):	return len(self.Rest) == 0
	
	def __add__(self, OtherEdge):
		if self.EndPos == OtherEdge.StartPos:
			return Edge(self.StartPos, OtherEdge.EndPos, )

	def __eq__(self, OtherEdge):
		return \
			self.StartPos == OtherEdge.StartPos and \
			self.EndPos == OtherEdge.EndPos and \
			self.Cat == OtherEdge.Cat and \
			self.Done == OtherEdge.Done and \
			self.Rest == OtherEdge.Rest	and \
			self.Tree == OtherEdge.Tree
			
	def __str__(self):
		DotRrepresentation = f"{str(self.Cat)} --> {' '.join(map(str, self.Done))}.{' '.join(map(str, self.Rest))}"
		return f'{self.StartPos} ---> {self.EndPos}  {DotRrepresentation.ljust(10)}\n{" "*34}{self.Tree}'

class Chart:
	""" stores the graph of partial parsing edges
	"""
	def __init__(self):
		self.reinit()
		
	def reinit(self):
		self.Table = []
		
	def add_edge(self, edge):
		if edge in self.Table:	
			trace(f'{edge} already stored', 4)
			return False
		trace(f'{edge.Comment.center(14)} edge:\t{edge}', 3)
		self.Table.append(edge)
		return True
	
	def __iter__(self):
		return iter(self.Table[:])	# copying table, as it will change within loops
		
	def __add__(self, ListOfEdges):
		self.Table += ListOfEdges
		return self
		
	def __str__(self):
		return '\n'.join([str(E) for E in self.Table])

class BUChartParser(syn_Grammar.Grammar):
	""" bottom-up chart parser 
	"""
	
	def __init__(self):
		super().__init__()
		self.Chart = Chart()
		
	def parse(self, Sentence, Target=None, Structure=None):	
		if Target is None:	Target = ('s',)		# non-terminal to be recognized
		if type(Target) != tuple:	Target = (Target,)
		trace(f'Analyzing {Sentence}', 3)
		self.Chart.reinit()	# Emptying the table
		# ------ creation of lexical edges
		for position, word in enumerate(Sentence):
			for rule in self:
				if len(rule.RHS) == 1:
					word1 = rule.RHS[0]
					if self.match(word, word1) is not None:	# lexical rule
						# ------ adding lexical edges will trigger the search for new edges
						self.add_edge(Edge(position, position+1, rule.LHS, [word1], [], 
									Tree_(rule.LHS, [Tree_(word)]), 'Lexical'))
		trace(self, 5)
		for edge in self.Chart:
			if edge.inactive() and edge.StartPos == 0 and edge.EndPos == len(Sentence) \
				and (Target is None or self.match(edge.Cat, Target[0]) is not None):
				trace('\nCorrect!', 1)
				self.ParseTrees.append(edge.Tree)
				trace(repr(edge.Tree), 3)
				edge.Tree.print(level=1, spaced=(len(Sentence) < 6))
				trace(self.use(), 2); stop(3)
		
	def add_edge(self, edge):
		global Correction___
		if self.Chart.add_edge(edge):	# the edge is really new
			if edge.inactive():	
				# ------ we just added an inactive edge. This triggers a cascade of events
				trace(f'Just added inactive edge: {edge}', 4)
				# ------ searching for candidate rules that may use this edge as a start
				for rule in self:
					trace(rule, 6)
					if self.match(rule.RHS[0], edge.Cat) is not None:	# Generation
						
						# ------ candidate rule found. 
						# ------ we add a new edge from (and to) current position
						# ------ 
						NewTree = Tree_(rule.LHS) # one node only for the new edge
						# vvvvvvvv  To be changed vvvvvvvv
						# !!!!!! % ADD APPROPRIATE EDGE HERE using a recursive call to 'add_edge'
						# !!!!!! Put 'Generated' in the field Comment
						# self.add_edge(Edge(..., ..., ..., (), rule.RHS, NewTree, 'Generated'))# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
						self.add_edge(Edge(edge.StartPos, edge.StartPos, rule.LHS, (), rule.RHS, NewTree, 'Generated'))
				for edge1 in self.Chart:
					# ------ searching for active edges that the current edge can extend
					if edge1.EndPos == edge.StartPos and edge1.Rest:
						Match = self.match(edge1.Rest[0], edge.Cat)
						if Match is not None:	# Extension
							# ------ recognized category matches first waiting category
							# ------ updating content
							Cat, Cat1  = self.update((edge.Cat, edge1.Cat), Match)
							Done1 = self.update(edge1.Done, Match)
							Rest1 = self.update(edge1.Rest, Match)
							Tree1 = copy.deepcopy(edge1.Tree)
							Tree1.newchild(edge.Tree)
							Tree1 = self.update(Tree1, Match)
							# vvvvvvvv  To be changed vvvvvvvv
							# !!!!!! % ADD APPROPRIATE EDGE HERE using a recursive call to 'add_edge'
							# !!!!!! edge1.Done should be augmented and edge1.Rest diminished
							# !!!!!! Note that Done1 is a tuple, so compute Done1 + (Cat,)
							# !!!!!! Put 'Extended-right' in the field Comment
							self.add_edge(Edge(edge1.EndPos, edge.StartPos, Cat1, Done1+(Cat,), Rest1[1:], Tree1, 'Extended-right'))							# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			# ------ searching for inactive edges that can extend the current edge
			for edge1 in self.Chart:
				if edge1.inactive() and edge.EndPos == edge1.StartPos:
					Tree1 = copy.deepcopy(edge.Tree)
					Tree1.newchild(edge1.Tree)
					# vvvvvvvv  To be changed vvvvvvvv
					# !!!!!! % ADD APPROPRIATE EDGE HERE using a recursive call to 'add_edge'
					# !!!!!! edge.Done should be augmented and edge.Rest diminished
					# !!!!!! (remember that Done is a tuple)
					# !!!!!! Put 'Extended-right' in the field Comment
					self.add_edge(Edge(edge.StartPos, edge1.EndPos, edge.Cat, edge.Done + (edge1.Cat,), edge.Rest[1:], Tree1, 'Extended-left'))
						
	def lexical(self, W):
		LR = re.match(r'\[(.*?)\]$', W)
		return LR is not None
		
	# def __str__(self):
		# return str(self.Chart)

if __name__ == "__main__":
	print(__doc__)
	TraceLevel = 3
	trace(level=TraceLevel, set=True)
	grammar = BUChartParser()
	grammar.loadDCG('syn_Grammar.pl')
	# grammar.process('a dog', Target='np')
	# grammar.process('the dog barks')
	# grammar.process('the dog of the sister likes the sister of the cousin')
	# grammar.process('Kirk likes the sister of the cousin')
	while True:
		grammar.reinit()
		try:	
			grammar.process()	# will prompt for new sentence
			# for P in grammar.ParseTrees:	P.print()
		except StopIteration: break
		
__author__ = 'Dessalles'



