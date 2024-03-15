#!/usr/bin/env python3
""" @brief  Reads Prolog lexixon file 
	class Feature:	defines an aspectual feature 
	class FeatureStructure(dict):	list of features
	class WordEntry(FeatureStructure):	this is where semantic merge is performed
	class Lexicon:	loads lexicon from Prolog file
	class Duration:	comparison of durations
"""



###################################################################
# Telecom Paris - J-L. Dessalles 2023                             #
# Cognitive Approach to Natural Language Processing               #
#            http://teaching.dessalles.fr/CANLP                   #
###################################################################

import re
from enum import Enum
from copy import copy

from syn_util import trace

Correction___ = 1
MAXPREDICATION = 1	# if non-zero, possibility of controlling the max number of predications per sentence

class F(Enum):
	"""	possible slots for features:
	"""
	viewpoint = 'vwp'
	anchoring = 'anc'
	occurrence = 'occ'
	duration = 'dur'
	image = 'im'
	

class Feature:
	"""	Defines an aspectual feature
	"""
	def __init__(self, featureSlot=None, featureString='', value=None, **args):
		"""	When loaded from lexicon, features are input as string-value.
			Then as slot-value.
		"""
		if featureString:	self.name = F(featureString)
		else:				self.name = featureSlot
		self.val(value, **args)

	def val(self, newval=None, **args):	
		""" sets and returns feature's value
		"""
		if newval is None:	newval = '*'
		if newval == '_':	newval = '*'
		# if self.name == F.anchoring and newval == '*':	newval = '0'
		if self.name == F.duration:
			self.value = Duration(newval, **args)	# converts value into log scale
		# elif self.name == F.anchoring and newval == '*':	self.value = '0'
		elif type(newval) == str:
			self.value = newval.strip("'")
		else:	self.value = newval

		if self.name == F.viewpoint:	assert self.value in 'fg*'
		# elif self.name == F.anchoring:	assert (type(self.value) == Event) or re.match(r'[\+\-=1\*\w]+', self.value)
		elif self.name == F.anchoring:	assert self.value in '01*'
		elif self.name == F.occurrence:	assert self.value in ['sing', 'mult', 'unq', '*']
		elif self.name == F.duration:	assert type(self.value) == Duration
		return self.value

	def durationType(self):
		"""	returns duration type
		"""
		if self.name == F.duration:	return self.value.type_
		raise ValueError

	def merge(self, other):
		"""	merging two features with same name:
			checks value identity of compatibility
		"""
		assert self.name == other.name, f'Error: comparing two different features: {self.name} and {other.name}'
		if self.value == '*':	return other
		if other.value == '*':	return self
		if self.name == F.duration:
			durationCompatibility = self.value.compare(other.value)
			if durationCompatibility is not None:
				return Feature(self.name, value=durationCompatibility)
			else:	
				trace(f'Mismatch between {self} and {other}', 4)
				return None
		if self.value == other.value:	return self
		trace(f'Mismatch between {self} and {other}', 4)
		return None
	
	def __str__(self):	return f"{self.name.value}:{self.value}"

	__repr__ = __str__
	
class FeatureStructure(dict):
	"""	Defines an aspectual feature structure
	"""
	def __init__(self, FeatureStringOrFS=''):
		"""	Creates a feature structure with aspectual features.
			When loaded from lexion, feature structures are given as 'F1:V1, F2:V2, ...' strings.
			Otherwise, they are given as ready-to-use feature structures
		"""
		dict.__init__(self)
		for f in F:	self[f] = Feature(f, value=None)
		if type(FeatureStringOrFS) == str:
			# ------ reading features
			if FeatureStringOrFS.strip() != '':
				for Fstring in FeatureStringOrFS.split(','):
					f, v = Fstring.strip().split(':')
					self[F(f)] = Feature(featureString=f, value=v)
		else:	# receiving a ready-to-use feature structure
			self.update(FeatureStringOrFS)
		# if self[F.anchoring].value == '2':
			# # ------ copying image into anchoring for anchored events for readability
			# self[F.anchoring].value = self[F.image].value

	def val(self, slot, Val=None, **args):
		assert slot in F
		if Val is not None:
			if slot == F.duration:
				self[slot] = Feature(slot, value=Val.duration, **args)
			else:	self[slot] = Feature(slot, value=Val)
		return self[slot].value
		
	def merge(self, other):
		"""	Attempt to merge with another feature structure
		"""
		trace(f'merging {self} and {other}', 7)
		Merge = {f:self[f].merge(other[f]) for f in self}
		if None in Merge.values():
			trace(f"{self} and {other} cannot be unified", 6)
			return None
		return FeatureStructure(Merge)
	
	def __str__(self):
		return f"({', '.join([str(self[f]) for f in self if self[f].value != '*'])})"
	
	__repr__ = __str__
	
	
class WordEntry(FeatureStructure):
	"""	Word, and its associated feature structure
	"""
	def __init__(self, Word, SyntacticCat, FeatureStructure='', Image=''):
		self.word = Word
		self.cat = SyntacticCat
		super().__init__(FeatureStructure)
		if self.word != self.cat and self.val(F.image) == '*':	
			# ------ for convenience for lexical entries: missing image filled with name
			self.val(F.image, Val=self.word)

		try:
			# putting Image in a special slot
			self.Image = self.pop(F.image).value	
			if self.Image == '*':	raise KeyError
		except KeyError:
			self.Image = Image
		if type(self.Image) == str:	
			self.Image = Event(self.Image)
	
	def isPredicate(self):
		"""	Checks that current word is predicated
		"""
		# ------ Predicates can be either:
		# ------ * eternal: g with no explicit duration
		# ------ * punctual: f with nil duration
		if self.val(F.anchoring) == '1':	return None
		if	self.val(F.viewpoint) == 'g' and self[F.duration].durationType() in [D.Unspecified, D.Min]:
			return True
		elif self.val(F.viewpoint) == 'f' and self[F.duration].durationType() in [D.Nil]:
			return True
		trace(f'tensed non-predicate: {self[F.viewpoint]} with {self[F.duration]} and {self[F.anchoring]}', 5)
		return False

	def makeEvent(self):
		self.val(F.anchoring, '1')	
		pass
		
	def semantic_merge(self, Cat, Word=None):
		"""	Merging self with Word into Cat.
		"""
		# ------ should return various merging solutions
		MergeStructure = FeatureStructure(self)	# default: no merging
		if Word is None:
			# ------ copying self's feature structure into Cat
			# return [WordEntry(Cat, Cat, self)]
			Image = self.Image
		else:	
			# trace(f"Merging {self.word} with {Word.word}", 5)
			trace(f"Merging {self.Image} with {Word.Image}", 4)
			
			if Cat != 'ip':	
				# ------ merging feature structures, except for external arguments
				MergeStructure = self.merge(Word)
				# ------ special cases
				if Cat == 'tp' and not Word.isPredicate():
					# vvvvvvvv  To be changed vvvvvvvv
					# replace the next line by "return None" to provoke a failure					# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
					pass
				
			Image = self.Image.merge(Cat, Word.Image)	# merging images
		if MergeStructure is not None:
			# ------ rescue loops over all rescue possibilities (the initial one being identity (= 'do nothing'))
			MergeResult = WordEntry(Cat, Cat, MergeStructure, Image)
			if Cat == 'tp':	MergeResult.makeEvent()
			return MergeResult.rescue()
		trace(f"** Merging failure", 4)
		return None
		
	def rescue(self):
		"""
			Rescue operations:
			zoom		--> dp
			slice		--> pp
			repeat		--> vp, vpt
			predication	--> vp, vpt
			# shift		--> tp

			zoom:	any singular figure that has duration
			slice:	any period that is anchored and has duration
			repeat:	any figure that has undefined multiplicity
			predicate:	any non-predicated event
		"""
		
		# vvvvvvvv  To be changed vvvvvvvv
		# You should add operators to the list of rescue operations
		Operations = [self.identity, 	
					  self.zoom, 
					  self.slice,
					  self.repeat,
					  self.predication_punctual,
					#   self.predication_eternal 
					  ]
		# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		for RescueOperation in Operations:
			if RescueOperation != self.identity:	
				trace(f'Rescuing attempt on {self} through {RescueOperation.__name__	}', 5)
			RescueW = RescueOperation()
			if RescueW is not None:
				if RescueOperation != self.identity:
					trace(f'{self.word} rescued though {RescueOperation.__name__}: {RescueW}', 3)
				if RescueOperation in [self.repeat, self.predication_eternal, self.predication_punctual]:
					# ------ recursive call at the vp/vpt level
					for W in RescueW.rescue():	# iterator
						yield W
				else:
					yield RescueW

	def identity(self):
		# return FeatureStructure(self)
		return self
	
	def zoom(self):
		"""	Attempt to zoom event
		"""
		if self.cat != 'dp':	return None	# zoom only dp (named events)
		if self.val(F.occurrence) == 'mult':	
			return None	# don't zoom repeated events
		if self.val(F.viewpoint) != 'f':
			return None	# only zoom figures 
		if self.val(F.anchoring) == '1':	
			return None	# do not zoom anchored periods
		try:
			if self[F.duration].durationType() != D.Normal:
				return None 			# zoom only into extented periods
		except AttributeError:
			print(self)
			raise AttributeError
		NewFS = FeatureStructure(self)
		NewFS.val(F.viewpoint, 'g')
		NewImage = Event(self.Image)
		NewImage.predicate = f'\u2191{NewImage.predicate}\u2191'
		return WordEntry(self.cat, self.cat, NewFS, NewImage)
		
	def slice(self):
		"""	Attempt to slice event
		"""
		if self.cat != 'pp':	return None	# slice only pp (temporal complements)
		if self.val(F.anchoring) != '1':	
			return None	# slice only anchored periods
		if self[F.duration].durationType() != D.Normal:
			return None 			# slice only extented periods
		NewFS = FeatureStructure(self)
		NewFS.val(F.viewpoint, 'f')
		# NewFS.val(F.occurrence, None)
		NewFS.val(F.occurrence, '*')	# erasing occurrence
		NewFS.val(F.duration, self[F.duration].value, type_=D.Max)
		# NewFS.val(F.anchoring, '1')
		NewImage = Event(self.Image)
		NewImage.predicate = f'\u2193{NewImage.predicate}\u2193'
		return WordEntry(self.cat, self.cat, NewFS, NewImage)
		
	def repeat(self):
		"""	Attempt to repeat event
		"""
		if self.cat not in ['vp', 'vpt']:	return None	# repeat only actions
		# if self.cat != 'vp':	return None	# repeat only actions
		if self[F.occurrence].value in ['mult', 'unq', 'sing']:	
			return None	# don't repeat unique or already repeated events
		if self.val(F.viewpoint) != 'f':	
			return None	# only repeat figures 
		if not self.val(F.duration).extended():
			return None 			# don't repeat non-events
		if self.val(F.anchoring) == '1':	
			return None	# do not repeat anchored periods
		NewFS = FeatureStructure(self)
		NewFS.val(F.viewpoint, 'g')
		NewFS.val(F.occurrence, 'mult')
		NewFS.val(F.duration, self[F.duration].value + 0.9, type_=D.Min)
		# NewFS.val(F.anchoring, '0')
		NewImage = Event(self.Image)
		NewImage.predicate = '*' + NewImage.predicate
		return WordEntry(self.cat, self.cat, NewFS, NewImage)
		
	def predication_punctual(self):
		"""	Attempt to predicate on an event
		"""
		# ------
		# if self.cat != 'vpt':	return None	# predicate only situated actions
		if self.cat not in ['vp', 'vpt']:	return None	# predicate only actions
		
		# if self[F.Image].isPredicate:
		if self.val(F.anchoring) == '1':
			return None 			# don't predicate events
		if self[F.duration].durationType() in [D.Nil, D.Steady]:
			return None 			# don't stack up predication
		# ------ patch to control the maximum number of predications
		if MAXPREDICATION > 0 and self.Image.predicate.count('!') >= MAXPREDICATION:
			return None
		NewFS = FeatureStructure(self)
		NewFS.val(F.viewpoint, 'f')
		# NewFS.val(F.anchoring, '0')
		NewFS.val(F.duration, self[F.duration].value, type_=D.Nil)
		NewImage = Event(self.Image)
		NewImage.predicate = '!' + NewImage.predicate
		return WordEntry(self.cat, self.cat, NewFS, NewImage)
		
	def predication_eternal(self):
		"""	Attempt to predicate on an event
		"""
		# ------
		# if self.cat != 'vpt':	return None	# predicate only situated actions
		if self.cat not in ['vp', 'vpt']:	return None	# predicate only actions
		
		if self.val(F.anchoring) in '01':
			return None 			# don't predicate events
		if self.val(F.viewpoint) == 'f':
			return None 			# eternal predication only for 'g'
		if self[F.duration].durationType() == D.Normal:
			return None 			# eternal predication cannot have definite duration
		NewFS = FeatureStructure(self)
		NewFS.val(F.anchoring, '0')
		NewFS.val(F.duration, self[F.duration].value, type_=D.Steady)
		NewImage = Event(self.Image)
		NewImage.predicate = '__' + NewImage.predicate
		return WordEntry(self.cat, self.cat, NewFS, NewImage)
		
	'''
	def shift(self):
		"""	Shifting reference point
		"""
		if self.cat != 'tp':	return None	# only tensed phrased considered here
		if self.val(F.anchoring).value not in '*-+':	return None
		# ------ shift forgets about internal duration
		NewFS = FeatureStructure(self)
		NewFS.val(F.duration, Duration('*'))
		return NewFS
	'''
	
	def __str__(self): return f'{self.word}: {FeatureStructure.__str__(self)}\n{" "*10}{self.Image}'
	
	def __repr__(self): return f'{self.word}({self.cat})'

class Event:
	"""	An event is meant to become a full-fledged predicate.
		An event corresponds to a tense phrase. It results from predication.
		Before this, the Event structure merely stores a string.
	"""
	def __init__(self, predicate=None, actor=None, patient=None, duration='', location=''):
		if type(predicate) == Event:
			self.predicate = predicate.predicate		# name of predicate or image
			self.actor = predicate.actor if actor is None else actor
			self.patient = predicate.patient if patient is None else patient
			self.duration = predicate.duration if duration == '' else duration
			self.location = predicate.location if location == '' else location
		else:	
			self.predicate = predicate	# name of predicate or image
			self.actor = actor
			self.patient = patient
			self.duration = duration
			self.location = location
	
	# def shift(self, shift):
		# self.location = shift + self.location

	def merge(self, Cat, other):
		"""	Merging self with other under Cat
		"""
		if Cat == 'vpt':
			return Event(predicate=self, duration=other.predicate)	# to be modified - add check
		elif Cat == 'vp':
			return Event(predicate=self, patient=other.predicate)
		elif Cat == 'tp':
			return Event(predicate=other, location=self.predicate)	# to be modified - add check
		elif Cat == 'ip':
			return Event(predicate=self, actor=other.predicate)
		elif Cat == 's':
			return Event(predicate=self, location=other.predicate)
		elif Cat in ['d', 'n', 'v', 't', 'p', 'pp', 'dp']:
			return Event(f"{self.predicate}_{other.predicate}")
		raise Exception(f"Unknown syntactic category {Cat} in merge")
	
	def __str__(self):
		R = str(self.predicate)
		if self.patient is not None or self.actor is not None:
			R += f"({self.actor if self.actor is not None else '_'},{self.patient if self.patient is not None else '_'})"
		if self.duration:	R += f" dur({self.duration})"
		if self.location:	R += f" loc({self.location})"
		return R
	
class Lexicon:
	"""	Retrives lexion from a Prolog file
	"""
	def __init__(self, PrologLexiconFile):
		self.Words = []
		self.loadLexicon(PrologLexiconFile)
		
	def loadLexicon(self,PrologLexiconFile):
		LexiconTxt = open(PrologLexiconFile).read()
		Entries = re.findall(r"^lexicon\('?([^,]+?)'?,\s*(\w+),\s*\[(.*?)\]\)", LexiconTxt, flags=re.M)
		if Entries is not None:
			for E in Entries:
				self.Words.append(WordEntry(*E))
		trace(self, 5); trace(f'{len(self)} words found in {PrologLexiconFile}\n', 1)

	def __iter__(self):	return iter(self.Words)
	
	def __getitem__(self, word):
		"""	returns possibly several entries for one given word
		"""
		return [wordEntry for wordEntry in self.Words if wordEntry.word.lower() == word.lower()]
		
	def __len__(self): 	return len(self.Words)

	def __str__(self): return '\n'.join(map(str, self.Words))


class D(Enum):
	"""	Duration types
		Min	<- repeat
		Max	<- slice
		Nil <- predication
	"""
	Unspecified, Nil, Normal, Min, Max, Steady  = '_', 'nil', '', 'min', 'max', 'std'

class Duration:
	"""	defines duration in log10(seconds)
	"""
	def __init__(self, duration, type_=None):
		# print(f'creating duration {duration}, type={type_}')
		try:
			self.duration = float(duration)
			self.type_ = D.Normal
		except (TypeError, ValueError):	
			# ------ input is None or already Duration
			if duration == '*':
				self.duration = None
				self.type_ = D.Unspecified
			else:
				self.duration = duration.duration
				self.type_ = duration.type_
		# ------ priority to input type
		if type_ is not None:	self.type_ = type_
		# if self.type_ != D.Unspecified and self.duration is None:
			# # ------ assigning arbitrary duration when absent
			# self.duration = 0.0
		assert self.type_ in D
		# assert self.duration is not None if self.type_ == D.Normal else True

	def extended(self):
		"""	Checks that duration is grounded on numerical value
		"""
		return self.duration is not None
		
	def compare(self, other):
		"""	Comparison of durations based on their order of magnitude
			Min	<- repeat
			Max	<- slice
			Nil <- predication
			Steady <- predication eternal
		"""
		
		# print(self.type_, self.convert(), end='\t')
		# print(other.type_, other.convert())
		if self.type_ == D.Unspecified:		return other
		if other.type_ == D.Unspecified:	return self
		if self.type_ == D.Steady:	return self
		if not self.extended() or not other.extended(): return None
		# ------ D.Max can only match D.Nil and conversely
		if self.type_ == D.Nil:
			if other.type_ == D.Nil:	return self
			# ------ D.Nil matches D.Max if corresponding duration is smaller
			if other.type_ == D.Max and self.convert() <= other.convert():
				return self
			return None
		if other.type_ == D.Nil:
			return other.compare(self)
		if self.type_ == D.Min:
			if self.convert() <= other.convert():	return self
			return None
		if other.type_ == D.Min:	
			return self.convert() > other.convert()
		if self.type_ == D.Normal and other.type_ == D.Normal:
			if abs(self.duration - other.duration) < 0.7:  
				return self
			return None
		return Duration(self.convert()).compare(Duration(other.convert()))
		
	def convert(self):
		"""	effect of repetition or slice on duration
		"""
		if self.type_ == D.Unspecified:	return '*'
		d = self.duration if type(self.duration) == float else self.duration.convert()
		if self.type_ == D.Nil:	return d
		if self.type_ == D.Min:	return d
		if self.type_ == D.Max:	return d
		return self.duration
		
	def __add__(self, value):
		added = copy(self)
		added.duration += value
		return added
	
	def __str__(self):	
		if self.type_ == D.Unspecified:	return self.type_.value
		if self.type_ == D.Normal:	return str(self.duration)
		return f"{self.type_.value}({self.duration})"

if __name__ == "__main__":
	print(__doc__)
	# print(Lexicon('asp_lexicon.pl'))!
	print(Lexicon('asp_lexique.pl'))


__author__ = 'Dessalles'

