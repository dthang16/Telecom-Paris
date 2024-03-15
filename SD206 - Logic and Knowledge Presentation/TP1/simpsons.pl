parent(marge, lisa).

parent(marge, bart).

parent(marge, maggie).

parent(homer, lisa).

parent(homer, bart).

parent(homer, maggie).

parent(abraham, homer).

parent(abraham, herb).

parent(mona, homer).

parent(jackie, marge).

parent(clancy, marge).

parent(jackie, patty).

parent(clancy, patty).

parent(jackie, selma).

parent(clancy, selma).

parent(selma, ling).



female(mona).

female(jackie).

female(marge).

female(ann).

female(patty).

female(selma).

female(ling).

female(lisa).

female(maggie).

male(abraham).

male(herb).

male(homer).

male(bart).

male(clancy).

child(X,Y) :-
    parent(Y,X).

mother(X,Y) :-
    parent(X,Y),
    female(X).

grandparent(X,Y) :-
    parent(X,Z),
    parent(Z,Y).

sister(X,Y) :-
    parent(Z,X),
    parent(Z,Y),
    female(X),
    X \== Y.

ancestor(X,Y) :-
    parent(X,Y).

ancestor(X,Y) :-
    parent(X,Z),
    ancestor(Z,Y).

aunt(Aunt, Child) :-
    parent(Parent, Child),
    sister(Aunt, Parent).