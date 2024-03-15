/*---------------------------------------------------------------*/
/* Telecom Paris- J-L. Dessalles 2023                            */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/


% partial elementary English grammar

% --- Grammar
s --> np, vp.
np --> det, n.		% Simple noun phrase
np --> det, n, pp.		% Noun phrase + prepositional phrase 
% np --> np, pp.		% Noun phrase + prepositional phrase 
np(singular) --> [kirk].
vp --> v(none).           % Verb phrase, intransitive verb
vp --> v(transitive), np.		% Verb phrase, verb + complement:  like X
vp --> v(intransitive), pp.		% Verb phrase, verb + indirect complement : think of X 
vp --> v(transitive), np, pp.	% Verb phrase, verb + complement + indirect complement : give X to Y 
vp --> v(diintransitive), pp, pp.	% Verb phrase, verb + indirect complement + indirect complement : talk to X about Y


pp --> p, np.		% prepositional phrase

% -- Lexicon
det --> [the].
det --> [my].
det --> [her].
det --> [his].
det --> [a].
det --> [some].
n --> [dog].
n --> [daughter].
n --> [son].
n --> [sister].
n --> [aunt].
n --> [neighbour].
n --> [cousin].
v(intransitive) --> [grumbles].
v(transitive) --> [likes].
v(transitive) --> [gives].
v(intransitive) --> [talks].
v(transitive) --> [annoys].
v(none) --> [hates].
v(none) --> [cries].
v(transitive) --> [knows].
v(intransitive) --> [knows].


s --> np(Sem), vp(Sem).
np(Sem) --> det, n(Sem).
np(Sem) --> det, n(Sem), pp.
vp(Sem) --> v(Sem, _).
vp(Sem1) --> v(Sem1, Sem2), np(Sem2).
vp(Sem) --> v(Sem), pp.
vp(Sem1) --> v(Sem1, Sem2), np(Sem2), pp.
vp(Sem) --> v(Sem), pp, pp.

n(sentient) --> [daughter].
n(edible) --> [apple].
v(sentient) --> [thinks].
v(sentient) --> [suffers].
v(sentient, edible) --> [eats].



p --> [of].
p --> [to].
p --> [about].


A = [sentience:true, number:sing, person:3, gender:feminine |_].
B = [person:3, number:sing | _].
unify(FS, FS) :- !. % Let Prolog do the job if it can

unify([ Feature | R1 ], FS) :-
    select(Feature, FS, FS1), % checks whether the Feature is in the list
    !, % the feature has been found
    unify(R1, FS1).

 s --> np(FS1), vp(....), {unify(FS1, ....)}. 