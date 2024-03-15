tag(S) --> [60], str(S), [62]. % 60 is the code for '<' and 62 for '>'
str([X|S]) --> [X], str(S), {X \== 60, X \== 62}.
str([ ]) --> [ ].

xml --> tag(T), str(_), xml, str(_), tag([47|T]), {write('recognized: '), writef(T), nl}.
xml --> tag(T), str(_), tag([47|T]), {write('recognized: '), writef(T), nl}.