/*---------------------------------------------------------------*/
/* Telecom Paris- J-L. Dessalles 2023                            */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/





/****************************************************************/
/* basic recursive algorithm for the Tower of Hanoi             */
/****************************************************************/

hanoi :-
	% 1 is the smallest disk and 5 the largest
	move([5,4,3,2,1], a, c, b).

move([ ], _, _, _).
move([D1|Stack], Start, Goal, Interm) :-
	move(Stack, Start, Interm, Goal), % this is a (central) recursive call
	write('move disk '), write(D1), write(' from '), write(Start), write(' to '), write(Goal), nl,
	move(Stack, Interm, Goal, Start). % yet another recursive call
	
	
	
/* Same algorithm with depth-sensitive trace             */

hanoi1 :-
	% 1 is the smallest disk and 5 the largest
	move1(0, [5,4,3,2,1], a, c, b).

drawDepth(0) :-	!.
drawDepth(Depth) :-
	write('_'),
	Depth1 is Depth -1,
	drawDepth(Depth1).
	
move1(_, [ ], _, _, _).
move1(Depth, [D1|Stack], Start, Goal, Interm) :-
	Depth1 is Depth + 1,
	move1(Depth1, Stack, Start, Interm, Goal), % this is a (central) recursive call
	drawDepth(Depth), 
	write('move1 disk '), write(D1), write(' from '), write(Start), write(' to '), write(Goal), nl,
	move1(Depth1, Stack, Interm, Goal, Start). % yet another recursive call


/****************************************************************/
/* State transition in the Tower of Hanoi puzzle                */
/****************************************************************/

% the program may be called through:
hanoi2 :-
	search2([[1,2,3,4],[ ],[ ]], R), !, print_solution(R).

search2(Node, [Node]) :-
	success(Node).
search2(Node, [Node|Sol1]) :-
	s(Node, Node1),
	write(Node1),nl, get0(_), % for the trace
	search2(Node1, Sol1).	% Note lateral (not central) recursivity


s([Ta,Tb,Tc], [Ta1,Tb1,Tc1]) :-
	permute(K, [Ta,Tb,Tc], [[D1|T1],T2,T3]), % as if source pole were a
	allowed(D1,T2), % checks that the move is legal
	permute(K, [Ta1,Tb1,Tc1], [T1,[D1|T2],T3]). % as if target pole were b - Note that K is the same

allowed(_,[]). % any disk can be put on an empty pole
allowed(D1,[D2|_]) :-
	D1 < D2. % checks that the disk beneath is larger
	
permute(1,[A,B,C],[A,B,C]). % Next time, let's write permute as a genuine prolog programme !
permute(2,[A,B,C],[A,C,B]).
permute(3,[A,B,C],[B,C,A]).
permute(4,[A,B,C],[B,A,C]).
permute(5,[A,B,C],[C,B,A]).
permute(6,[A,B,C],[C,A,B]). % Theory says that 3! = 6.

	% The state to be reached is indicated by:

success([[],[],_]). % all disks in c

/* Same algorithm with cycle detection             */

hanoi3 :-
	search3([[1,2,3,4],[ ],[ ]], R), !, print_solution(R).

search3(Node, Solution) :-
	depth([ ], Node, Solution).

depth(Path, Node, [Node | Path]) :-
	success(Node).

depth(Path, Node, Sol) :-
	s(Node, Node1),
	not(member(Node1, Path)),
	depth([Node | Path], Node1, Sol).


% Avoiding infinite depth paths
% Looking for Paths of increasing length
%--------------------------------------------------

hanoi4 :-
	search4([[1,2,3,4],[ ],[ ]], R), !, print_solution(R).

search4(Start, Solution) :-
	path(Start, Goal, Solution),
	success(Goal).

path(N, N, [N]).
path(First, Last, [Last | Path]) :-
	path(First, Penultimate, Path),
	s(Penultimate, Last),
	not(member(Last, Path)).

% 'search4' is in fact a width-first strategy, though an inefficient one


% Width-first strategy
%--------------------------------------------------

hanoi5 :-
	search5([[1,2,3,4],[ ],[ ]], R), !, print_solution(R).

search5(Start, Solution) :-
	width([[Start]], Solution). % first argument is the list of covered branches

width([[Node | Path] | _], [Node | Path]) :-
	% write(Node),nl, get0(_), % pour la trace
	success(Node).
width([Path | Paths], Solution) :-
	extension( Path, NewPaths ),	% expands first branch by one move, thus creating new branches
	append( Paths, NewPaths, Paths1),
	width(Paths1, Solution).

extension([Node | Path], NewPaths) :-
	bagof([NewNode, Node  | Path],
		(s(Node, NewNode),
			not(member(NewNode, [Node | Path]))),
		NewPaths ),
	!.
	/* bagof puts together into a list (3rd arg.) objects 
	   corresponding to the first argument that make the predicate
	   given as second argument true */
extension(_, [ ]).


%                       useful predicate
print_solution([ ]).
print_solution([E|R]) :-
	print_solution(R),
	write(E), nl.

