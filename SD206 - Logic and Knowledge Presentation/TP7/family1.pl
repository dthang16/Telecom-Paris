/*---------------------------------------------------------------*/
/* Telecom Paris- J-L. Dessalles 2023                            */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/


% partial elementary English grammar

% --- Grammar
%s --> np, vp.
s --> np(Number), vp(Number).
%np --> det, n.		% Simple noun phrase
np(Number) --> det(Number), n(Number).

np --> det, n, pp.		% Noun phrase + prepositional phrase 
np(Number) --> det(Number), n(Number), pp.

%np --> np, pp.		% Noun phrase + prepositional phrase 

np(singular) --> [kirk].
vp(Number) --> v(Number).           % Verb phrase, intransitive verb
vp(Number) --> v(Number), np(_).		% Verb phrase, verb + complement:  like X
vp(Number) --> v(Number), pp.		% Verb phrase, verb + indirect complement : think of X 
vp(Number) --> v(Number), np(_), pp.	% Verb phrase, verb + complement + indirect complement : give X to Y 
vp(Number) --> v(Number), pp, pp.	% Verb phrase, verb + indirect complement + indirect complement : talk to X about Y
pp --> p, np.		% prepositional phrase

% -- Lexicon
det(_) --> [the].
det(_) --> [my].
det(_) --> [her].
det(_) --> [his].
det(singular) --> [a].
det(plural) --> [some].

%det(singular) --> [a].
det(plural) --> [many].
%det(_) --> [the].

%n --> [dog].
%n --> [daughter].
%n --> [son].
%n --> [sister].
%n --> [aunt].
%n --> [neighbour].
%n --> [cousin].


n(singular) --> [dog].
n(singular) --> [daughter].
n(singular) --> [son].
n(singular) --> [sister].
n(singular) --> [aunt].
n(singular) --> [neighbour].
n(singular) --> [cousin].
n(plural) --> [dogs].
n(plural) --> [daughters].
n(plural) --> [sons].
n(plural) --> [sisters].
n(plural) --> [aunts].
n(plural) --> [neighbours].
n(plural) --> [cousins].

%v --> [grumbles].
%v --> [likes].
%v --> [gives].
%v --> [talks].
%v --> [annoys].
%v --> [hates].
%v --> [cries].


v(singular) --> [grumbles].
v(singular) --> [likes].
v(singular) --> [gives].
v(singular) --> [talks].
v(singular) --> [annoys].
v(singular) --> [hates].
v(singular) --> [cries].

v(plural) --> [grumble].
v(plural) --> [like].
v(plural) --> [give].
v(plural) --> [talk].
v(plural) --> [annoy].
v(plural) --> [hate].
v(plural) --> [cry].

p --> [of].
p --> [to].
p --> [about].
