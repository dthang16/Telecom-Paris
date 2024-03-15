/*---------------------------------------------------------------*/
/* Telecom Paris- J-L. Dessalles 2023                            */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/



:-op(140, fy, -).	% stands for 'not'
:-op(160,xfy, [and, or, equiv, imp, impinv, nand, nor, nonimp, nonequiv, nonimpinv]).

is_true(V, X and Y) :- is_true(V,X), is_true(V,Y).
is_true(V, X or _) :- is_true(V,X).
is_true(V, _ or Y) :- is_true(V,Y).
is_true(V, -X) :-
	not(is_true(V, X)). 
	/* link with Prolog's negation */
is_true(v0,a).	% this means that v0 sends a to True and everything else (here, b and c) to false

is_true(V, X) :-
	member(X,V).	% only true elements are explicitly mentioned in V

is_true(V, X equiv Y) :-
    is_true(V, (X and Y) or (-X and -Y)).

is_true(V, X imp Y):-
    not(is_true(V, X and -Y)).

valuation(V) :-
	% we keep all elements that V sends to true.
	% all other elements are supposed to be false.
	sub_set(V, [a,b,c]).	


	
sub_set([], []).
sub_set([X|XL], [X|YL]) :-
    sub_set(XL, YL).
sub_set(XL, [_|YL]) :-
    sub_set(XL, YL).
	
