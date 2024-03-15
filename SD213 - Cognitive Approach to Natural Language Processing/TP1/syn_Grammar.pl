/*---------------------------------------------------------------*/
/* Telecom Paris - J-L. Dessalles 2023                           */
/* IA312 - Natural Language Processing                           */
/*            http://teaching.dessalles.fr/CANLP                 */
/*---------------------------------------------------------------*/



% partial elementary English grammar

% --- Productions rules
s --> np, vp.
s --> vp, np.

np --> det, n.		% Simple noun phrase
np --> np, pp.		% Noun phrase + prepositional phrase 
np --> [kirk].
vp --> v, np.		% Verb phrase, verb + complement:  like X
vp --> v, pp, pp.	% Verb phrase, verb + indirect complement + indirect complement : talk to X about Y
vp --> v, pp.		% Verb phrase, verb + indirect complement : think of X 
vp --> v, np, pp.	% Verb phrase, verb + complement + indirect complement : give X to Y 
vp --> v.           % Verb phrase, intransitive verb

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
v --> [ăn].
v --> [grumbles].
v --> [likes].
v --> [gives].
v --> [talks].
v --> [annoys].
v --> [thinks].
v --> [hates].
v --> [cries].
v --> [barks].
p --> [of].
p --> [to].
p --> [about].


