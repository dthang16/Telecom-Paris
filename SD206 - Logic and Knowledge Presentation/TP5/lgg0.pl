/*---------------------------------------------------------------*/
/* Telecom Paris- J-L. Dessalles 2023                            */
/* LOGIC AND KNOWLEDGE REPRESENTATION                            */
/*            http://teaching.dessalles.fr/LKR                   */
/*---------------------------------------------------------------*/



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% symbolic concept learning %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- select(_,_,_).   % to circumvent a bug in my version of SWI-Prolg
:- unknown(_,fail).
:- dynamic(vPosition/2).

%----------------------%
% Geometrical ontology %
%----------------------%
/*
                form
            /           \
     polygon            ellipsoid
  /  /	 |    \         /       \
sq. tr. pent. hex.    ellipse  circle

*/
parent(form, polygon).
parent(form, ellipsoid).
parent(polygon, square).
parent(polygon, triangle).
parent(polygon, pentagon).
parent(polygon, hexagon).
parent(ellipsoid, ellipse).
parent(ellipsoid, circle).


%------------------------------------------------------------%
% Least general generalization between two geometrical shapes
%------------------------------------------------------------%

lgg(Shape1, Shape2, LGG, Cost) :-
    ancestor(Shape1, Shape2, Cost),
    LGG = Shape1. % LGG is the first common ancestor found
lgg(Shape1, Shape2, LGG, Cost) :-
    ancestor(Shape2, Shape1, Cost),
    LGG = Shape2. % LGG is the first common ancestor found
lgg(Shape1, Shape2, LGG, Cost) :-
    parent(Parent, Shape1),
    lgg(Parent, Shape2, LGG, Cost1),
    Cost is Cost1 + 1. % climbing up the hierarchy costs 1 unit
lgg(Shape1, Shape2, LGG, Cost) :-
    parent(Parent, Shape2),
    lgg(Shape1, Parent, LGG, Cost1),
    Cost is Cost1 + 1. % climbing up the hierarchy costs 1 unit

lgg(X, Y, X, Cost):-
    ancestor(X, Y, Cost).
    
lgg(X, Y, Y, Cost):-
    ancestor(Y, X, Cost).
lgg(X, Y, Shape, Cost):-
    ancestor(Shape, X, Cost1),
    lgg(Shape, Y, Shape, Cost2),
    Cost is Cost1 + Cost2.
lgg(X, Y, Shape, Cost):-
    ancestor(Shape, Y, Cost1),
    lgg(X, Shape, Shape, Cost2),
    Cost is Cost1 + Cost2.
    

    
%%%%% TO BE REWRITTEN using ancestor

ancestor(X,X,0).	% no climbing at first
ancestor(X,Y,N) :-
	parent(X,Z),	% climbing the hierarchy
	ancestor(Z,Y,N1),	% recursive call, just in case one needs to climb further up
	N is N1 +1. % there is a cost in climbing up the hierarchy

/*--------------------------------------------------*/
/* Unification between two feature structures       */
/* Calls 'lgg' to unify features that are not equal */
/*--------------------------------------------------*/
match([],[],[],0).
match([Feature1|FS1], FS2, [F|FS], Cost) :-
    % Looks for compatible features between the two feature structures
    select(Feature2, FS2, FS2a),
    compatible(Feature1, Feature2, F, Cost1),
    match(FS1, FS2a, FS, Cost2),
    Cost is Cost1 + Cost2.

compatible(F1, F2, F, Cost) :-
    F1 =.. [Shape1|A],
    F2 =.. [Shape2|A],
    lgg(Shape1, Shape2, Shape, Cost),
    F =.. [Shape|A].
    
%------------------------------------------------------------------%
% interface with "perception":                                     %
% executing objects means that they are given a definite reference %
%------------------------------------------------------------------%
execute([]).
execute([P|Ps]) :-
    P,
    execute(Ps).
execute([P|Ps]) :-
    P =.. [Pr|Var], % P has failed
    parent(PPr,Pr), % climb up the hierarchy to make another attempt
    PP =.. [PPr|Var],
    execute([PP|Ps]).

% object instantiation
form(object_1).	% object is instanciated regardless of its specific properties
form(object_2).	% object is instanciated regardless of its specific properties

% Vertical position
vPos(Object,P) :-
    not(vPosition(Object,_)),
    assert(vPosition(Object,P)).	% objects are given positions only once
vPos(Object,P) :-
    retract(vPosition(Object,P)),    % cleans memory when backtracking
    fail.

%-------%
% Tests %
%-------%
generalize(E1, E2) :-
    write(E1),nl,
    write(E2),nl,
    match(E1, E2, E, Cost),
    execute(E),
    write(E), write(' --- '), write(Cost), nl.

matchTest :-
    E1 = [square(A), circle(B), vPos(A,2), vPos(B,1)],  
    E2 = [triangle(C), square(D), vPos(C,2), vPos(D,1)],
    generalize(E1,E2).
