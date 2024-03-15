/*---------------------------------------------------------------*/
/* Telecom Paris- J-L. Dessalles 2023                            */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/


% adapted from I. Bratko - "Prolog - Programming for Artificial Intelligence"
%              Addison Wesley 1990

% An ape is expected to form a plan to grasp a hanging banana using a box.
% Possible actions are 'walk', 'climb (on the box)', 'push (the box)', 
% 'grasp (the banana)'

% description of actions - The current state is stored using a functor 'state'
% with 4 arguments: 
%	- horizontal position of the ape 
%	- vertical position of the ape
%	- position of the box
%	- status of the banana 
% 'action' has three arguments: 
% 	- Initial state
%	- Final state
%	- act

action(state(middle,on_box,X,not_holding), grasp, state(middle,on_box,X,holding)).
action(state(X,floor,X,Y), climb, state(X,on_box,X,Y)).
action(state(X,floor,X,Z), push(X,Y), state(Y,floor,Y,Z)).
action(state(X,floor,T,Z), walk(X,Y), state(Y,floor,T,Z)).


success(state(_,_, _, holding), []).
success(State1, [Act|Plan]) :- 
	action(State1, Act, State2),
	success(State2, Plan).

go :-
	success(state(door, floor, window, not_holding), _).



% bad solution (double recursion):
mirror([ ], [ ]).
mirror([X|L1], L2) :-
    mirror(L1,L3),
    append(L3, [X], L2).     % append will dig into the list a second time

% better solution with accumulator:
mirror2(Left, Right) :-
    invert(Left, [ ], Right).
invert([X|L1], L2, L3) :-    % the list is 'poured'
    invert(L1, [X|L2], L3).    % into the second argument
invert([ ], L, L).        % at the deepest level, the result L is merely copied

palindrome(L):-
	mirror2(L, L).

palindrome2(L):-
	accumulator(L,[]).

accumulator(L, L):- !.
accumulator(L, [_|L]):- !.

accumulator([X|L1], L2):-
	accumulator(L1, [X|L2]).


empty(X) :-
	retract(X),
	write(X), nl,
	fail.

findany(Var, Pred, List):-
	Pred,
	asserta(found(Var)),
	fail.

findany(_, _, List):-
	collectFound(List).

collectFound([Var|List]):-
	retract(found(Var)),
	!,
	collectFound(List).
collectFound([]).