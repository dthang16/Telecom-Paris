/*---------------------------------------------------------------*/
/* Telecom Paris - J-L. Dessalles 2023                           */
/* Cognitive Approach to Natural Language Processing             */
/*            http://teaching.dessalles.fr/CANLP                 */
/*---------------------------------------------------------------*/


% example(Correctness, Sentence, Comment...).


example(_, "Mary will drink the glass_of_wine", "1 interpretations: predicated").
example(_, "Mary will drink the glass_of_wine in ten seconds", "2 interpretations: predicated and inchoative").
example(_, "Mary will drink the glass_of_wine in 2028", "1 interpretation: predicated").
example(_, "Mary will drink the glass_of_wine for one minute", "0 interpretation").
example(_, "Mary will drink the glass_of_wine during the show", "1 interpretation: predicated").
example(_, "Mary will drink water", "2 interpretations: predicated and repeated").
example(_, "Mary will drink water in one minute", "1 interpretation: inchoative").
example(_, "Mary will drink water in 2028", "2 interpretations: predicated and repeated").
example(_, "Mary will drink water for ten seconds", "1 interpretation: predicated").
example(_, "Mary will drink water during the show", "2 interpretations: predicated and repeated").
example(_, "Mary will eat", "2 interpretations: predicated and repeated").
example(_, "Mary will eat in one minute", "1 interpretation: inchoative").
example(_, "Mary will eat in one hour", "3 interpretations: duration, repeated and inchoative").
example(_, "Mary will eat in 2028", "2 interpretations: predicated and repeated").
example(_, "Mary will eat during 2028", "0 interpretations").
example(_, "Mary will eat for one hour", "0 interpretation").
example(_, "Mary will eat for one year", "1 interpretation: repeated").
example(_, "Mary will eat during the show", "1 interpretation: predicated").
example(_, "Mary will like the wine", "1 interpretation: predicated").	
example(_, "Mary _PRET snore", "2 interpretations: predicated and repeated").
example(_, "Mary _PRET snore in ten minutes", "0 interpretation").
example(_, "Mary _PRET snore in 2010", "2 interpretations: predicated and repeated").
example(_, "Mary _PRET snore for ten minutes", "2 interpretations: predicated and repeated").
example(_, "Mary _PRET snore during the show", "2 interpretations: predicated and repeated").
example(_, "Mary _PRET like the wine", "2 interpretations: predicated and steady").
example(_, "Mary _PRET like wine", "2 interpretations: predicated and steady").
example(_, "Mary _PRES like the wine", "1 interpretation: steady").
example(_, "Mary _PRET like wine in 2010", "0 interpretation").
example(_, "Mary _PRES eat", "1 interpretation: repeated").
example(_, "Mary _PRES eat in one hour", "1 interpretation: repeated").

list :-
	example(_, S, _), 
	writeln(S), 
	fail.
list.