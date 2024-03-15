/*---------------------------------------------------------------*/
/* Telecom Paris - J-L. Dessalles 2023                           */
/* Cognitive Approach to Natural Language Processing             */
/*            http://teaching.dessalles.fr/CANLP                 */
/*---------------------------------------------------------------*/


:- encoding(utf8).


example(1,"elle _PP mange le gâteau en une minute", '1 interpretation: predicated').
example(1,"elle _PP mange le gâteau en 2010",'1 interpretation: predicated').
example(0,"elle _PP mange le gâteau pendant une minute", '0 interpretation').
example(1,"elle _PP mange le gâteau pendant le spectacle", '1 interpretation: predicated').
%example(1,"elle _PP mange le gâteau pendant cette minute-là",_).

example(1,"elle _PP mange du gâteau en une minute",'1 interpretation: inchoative').
example(1,"elle _PP mange du gâteau en 2010", '2 interpretations: predicated and repeated').
%example(1,"elle _PP mange du gâteau, en 2010", pred:manger_gateau).
example(1,"elle _PP mange du gâteau pendant une minute", '2 interpretations: predicated and repeated').
example(1,"elle _PP mange du gâteau pendant le spectacle", '2 interpretations: predicated and repeated').
example(1,"elle _PP mange du gâteau pendant cette minute-là", '2 interpretations: predicated and repeated').

% example(1,"elle _PP mange un gâteau en une minute", record).
% example(1,"elle _PP mange un gâteau en 2010",_).
% example(0,"elle _PP mange un gâteau pendant une minute",'*************').
% example(1,"elle _PP mange un gâteau pendant le spectacle",_).

% example(1,"elle _PP mange dix gâteau en une minute", record).
% example(1,"elle _PP mange dix gâteau en 2010",_).
% example(0,"elle _PP mange dix gâteau pendant une minute",'*************').
% example(1,"elle _PP mange dix gâteau pendant le spectacle",_).

example(1,"elle _PP mange en une heure",_).
example(1,"elle _PP mange en une minute",_).
example(1,"elle _PP mange en 2010",'interpretation repetitive possible').
example(1,"elle _PP mange pendant une minute", grignoter).
example(0,"elle _PP mange pendant une heure", _).
example(1,"elle _PP mange pendant le spectacle",_).
%example(1,"elle _PP mange pendant cette minute-là",_).

example(1,"elle _PP ronfle en une minute",'').
example(1,"elle _PP ronfle en 2010",'').
example(1,"elle _PP ronfle pendant une minute",'').
example(1,"elle _PP ronfle pendant le spectacle",'').

example(1,"elle _PP conduire une voiture pendant une minute",_).
example(1,"elle _PP conduire la voiture pendant une minute",_).

example(0,"elle _IMP mange pendant une heure", 'repetition obligatoire').
example(1,"elle _IMP mange en une heure", 'repetition obligatoire').
example(1,"elle _IMP mange en 2010",_).
example(1,"elle _IMP mange pendant le spectacle",_).

example(1,"elle _PR ronfle",_).
example(1,"elle _PR mange",_).
example(1,"elle _PR mange pendant une heure",_).

list :-
	example(_, S, _), 
	writeln(S), 
	fail.
list.