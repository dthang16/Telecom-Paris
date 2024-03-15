
A = [sentience:true, number:sing, person:3, gender:feminine |_].
B = [person:3, number:sing | _].
unify(FS, FS) :- !. % Let Prolog do the job if it can

unify([ Feature | R1 ], FS) :-
    select(Feature, FS, FS1), % checks whether the Feature is in the list
    !, % the feature has been found
    unify(R1, FS1).