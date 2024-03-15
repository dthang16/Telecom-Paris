extract(X, [X|L], L).
extract(X, [Y|L], [Y|L1]) :-
    extract(X, L, L1).


permute([], []).
permute([First|Rest], PermutedList) :-
    permute(Rest, PermutedRest),
    extract(First, PermutedList, PermutedRest).


last_elt([X], X).
last_elt([_|L], X) :-
    last_elt(L, X).

attach([], X, X).
attach([X|L1], L2, [X|L]):-
    attach(L1, L2, L).

assemble(L1, L2, L3, Result):-
    attach(L1, L2, L4),
    attach(L4, L3, Result).

sub_list(L1, L):-
    assemble(_, L1, _, L).

remove(X, L, L):-
    sub_list(X, L),
    !.
remove(X, L, L1):-
    extract(X, L, L1).

duplicate([], []).
duplicate([X|L1], [X, X|L]):-
    duplicate(L1, L).
