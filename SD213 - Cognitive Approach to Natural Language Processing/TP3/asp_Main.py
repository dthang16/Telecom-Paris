#!/usr/bin/env python3
""" @brief 
	----------------------------------------------
	minimal implementation of aspectual processing  
	----------------------------------------------
"""

###################################################################
# Telecom Paris - J-L. Dessalles 2023                             #
# Cognitive Approach to Natural Language Processing               #
#            http://teaching.dessalles.fr/CANLP                   #
###################################################################

import sys
import os
import re
import asp_Grammar
import asp_Lexicon
from syn_util import trace, Tree_, stop

LANGUAGE = 'English'
# LANGUAGE = 'Français'
TRACELEVEL = 1

class asp_parser(asp_Grammar.Grammar):
	"""	Syntax-driven processing, based on basic bottom-up parser
	"""
		
	def parse(self, Sentence, Target=None, Structure=None):
		"""	bottom-up parser.
		"""
		trace(f'Analyzing: {Sentence}', 3); stop(5)
		
		if Structure is None:	
			Structure = tuple(map(lambda x: Tree_(x), Sentence))	# will become the parsing tree
		if len(Sentence) == 1 \
			and (Target is None \
			or (type(Sentence[0]) == asp_Lexicon.WordEntry and Sentence[0].cat == Target)):
			# ------ Sentence has been reduced to the target non-terminal
			trace('Correct!', 2); trace(Structure, 4)
			trace('\n', 2)
			for P in Structure:	
				self.ParseTrees.append(P)
				# trace(P, 3)
				P.print(level=2)	# printing parse tree
			trace(self.use(), 6)	# number of times grammar has been scanned
			stop(3)	# pause
		else:
			for splitpoint in range(len(Sentence)):
				for Rule in self:	# loops over grammar rules
					if len(Sentence) < splitpoint + len(Rule.RHS):
						# ------ Rule's right-hand side too long
						continue
					# ------ attempt to find rule's right-hand side (RHS) within sentence
					Chunk = Sentence[splitpoint:splitpoint+len(Rule.RHS)]
					Match = self.unifyList(Chunk, Rule.RHS)
					if Match is None:	continue
					# ------ Sentence includes Rule's right-hand side as a chunk
					if not all(map(self.lexical, Sentence[splitpoint+len(Rule.RHS):])):
						# ------ patch to avoid looping in some cases: all remaining tokens should be words
						continue
					trace(Rule, 5)
					# ------ merging the feature structures and propagating the result upwards
					if Rule.is_lexical():	
						# LHSCandidates = [Rule.LHS] # lexical rule
						LHSCandidates = self.semantic_merge(Rule.LHS.cat, Rule.LHS)
					else:
						if len(Rule.RHS) > 1:
							trace(f"{Rule} {'(head-last rule)' * (Rule.HeadPosition-1)}", 4)
							nl = '\n\t'
							trace(f"Merging under {Rule.LHS}\n\t{nl.join(list(map(str,Chunk)))}", 4)
						# ------ semantic_merge returns several possible LHSs, due to rescue operations
						LHSCandidates = self.semantic_merge(Rule.LHS, *Chunk, HeadPosition=Rule.HeadPosition)
					if LHSCandidates is None:
						trace("\t... fail", 4)
						continue
					elif Rule.is_lexical():	trace("\t... success", 5)
					for NewLHS in LHSCandidates:
						Sentence1 = Sentence[:splitpoint] + (NewLHS,) + Sentence[splitpoint+len(Rule.RHS):]
						Structure2 = Structure[:splitpoint]
						# ------ merging Right-hand side
						Structure2 += self.merge(NewLHS, *Structure[splitpoint:splitpoint+len(Rule.RHS)])
						Structure2 += Structure[splitpoint+len(Rule.RHS):]
						# ------ recursive call
						self.parse(Sentence1, Target=Target, Structure=Structure2)
			trace(f'no more rules for {Sentence}', 6)

def load_sentences(ExampleFile):
	Examples = open(ExampleFile).read()
	for E in re.findall(r'''^example\([\d_],\s*["']?(.*?)["']?,\s*["']?(.*?)["']?\)\.\s*$''', Examples, re.M):
		yield E



if __name__ == "__main__":
	"""	Usage:
		asp_Main.py [<file containing sentences> [<output file]] [trace level]
		if the sentence file does not exist, "asp_Sentences.pl" is used 
	"""
	trace(__doc__, 1)
	trace(level=TRACELEVEL, set=True)
	try:	
		trace(level=int(sys.argv[-1]), set=True)
		sys.argv.pop()
	except (TypeError, ValueError):	pass
	# ------ loading grammar
	grammar = asp_parser()
	grammar.loadDCG('asp_Grammar.pl')
	# ------ loading lexicon
	trace(f'Language set to {LANGUAGE}', 1)
	if LANGUAGE == 'English':	grammar.loadLexicon('asp_Lexicon.pl')
	else:						grammar.loadLexicon('asp_Lexique.pl')
	# trace(grammar, 4)
	
	if len(sys.argv) == 1:
		# ------ interactive
		while True:
			grammar.reinit()
			try:
				grammar.process()	# will prompt for new sentence
				for P in grammar.ParseTrees:	P.print()
				print(f'\n{len(grammar.ParseTrees)} interpretation{"s" * (len(grammar.ParseTrees) != 1)} found')
			except StopIteration: break
	else:
		# ------ non-interactive
		# trace(level=1, set=True)
		ExampleFile = sys.argv[1]
		if not os.path.exists(ExampleFile):
			if LANGUAGE == 'English':	ExampleFile = 'asp_Sentences.pl'
			else:						ExampleFile = 'asp_Phrases.pl'
			# ExampleFile = 'asp_Sentences.pl'
			# ExampleFile = 'asp_Phrases.pl'
		print(f'Loading {ExampleFile}')
		if len(sys.argv) == 3:
			OutputFile = os.path.splitext(sys.argv[2])[0] + '.txt'	# safer
			print(f'Results written in {OutputFile}')
			sys.stdout = open(OutputFile, 'w')
		for E, Solution in load_sentences(ExampleFile):
			print('=' * 30)
			print(E, file=sys.stderr, flush=True)
			grammar.reinit()
			grammar.process(E, Target='s')	
			print(f'\n{" "*10}{len(grammar.ParseTrees)} interpretation{"s" * (len(grammar.ParseTrees) != 1)} found')
			if Solution:	print('Expected:', Solution)


		
__author__ = 'Dessalles'
