/*---------------------------------------------------------------*/
/* Telecom Paris- J-L. Dessalles 2023                            */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/


% partial elementary English grammar

% --- Grammar
s --> np, vp.
np(Number) --> det(Number), n(Number).		% Simple noun phrase
np(Number) --> det(Number), n(Number), pp.		% Noun phrase + prepositional phrase 
% np --> np, pp.		% Noun phrase + prepositional phrase 
np --> [kirk].
vp --> v.           % Verb phrase, intransitive verb
vp --> v, np.		% Verb phrase, verb + complement:  like X
vp --> v, pp.		% Verb phrase, verb + indirect complement : think of X 
vp --> v, np, pp.	% Verb phrase, verb + complement + indirect complement : give X to Y 
vp --> v, pp, pp.	% Verb phrase, verb + indirect complement + indirect complement : talk to X about Y
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
v --> [grumbles].
v --> [likes].
v --> [gives].
v --> [talks].
v --> [annoys].
v --> [hates].
v --> [cries].
p --> [of].
p --> [to].
p --> [about].


