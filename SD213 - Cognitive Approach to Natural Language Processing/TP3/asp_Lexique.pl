/*---------------------------------------------------------------*/
/* Telecom Paris - J-L. Dessalles 2023                           */
/* Cognitive Approach to Natural Language Processing             */
/*            http://teaching.dessalles.fr/CANLP                 */
/*---------------------------------------------------------------*/


% implementation minimale du modele temporel


:- encoding(utf8).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lexicon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lexical entries : lexicon(<word>, <syntactic and semantic feature structure>)
% Feature structures are unterminated lists: [ Feature1:Value1, Feature2:Value2 | _ ]

lexicon(en, p, [vwp:f]).
lexicon(pendant, p, [vwp:g]).
lexicon(dans, p, [anc:+, im:after_now]).
lexicon(après, p, [anc:+]).
lexicon('à',p, _).

lexicon(',', sep, _).

lexicon('Marie', dp, [im:marie]).
lexicon('Pierre', dp, [im:pierre]).
lexicon('elle', dp, [im:elle]).
lexicon('il', dp, [im:il]).
lexicon(cantine,n, [im:cantine]).
lexicon('gâteau',n, [im:gateau]).
lexicon('voiture',n, [im:voiture]).

lexicon(an, n, [anc:0, im:anDuree, dur:7.5]).
lexicon(heure, n, [anc:0, im:heureDuree, dur:3.6]).
lexicon(minute, n, [anc:0, im:minuteDuree, dur:1.8]).
lexicon(minutes, n, [anc:0, im:minuteDuree, dur:2]).
lexicon(seconde, n, [anc:0, im:secondeDuree, dur:0]).
lexicon('minute-là', n, [anc:2, im:minute, dur:1.81]).
lexicon(spectacle, n, [anc:2, im:spectacle, dur:3.8]).
lexicon(2010, dp, [anc:2, im:'2010', dur:7.5]).
lexicon(2028, dp, [anc:2, im:'2028', dur:7.5]). 


lexicon(aime, v, [vwp:g, im:aimer]).

lexicon(mange, vp, [vwp:f, im:déjeuner, dur:3.5]).
lexicon(mange, vp, [vwp:g, im:grignoter, dur:1.5, occ:mult]).
lexicon(mange, v, [vwp:f, im:ingérer, dur:1]).
lexicon(mange, v, [vwp:g, im:manger_de, dur:1]).

lexicon(ronfle, vp, [vwp:g, im:ronfler, dur:2.7]).
lexicon(conduire, v, [vwp:g, im:conduire]).



lexicon('_PP', t, [vwp:f, anc:-, im:past]).
lexicon('_IMP', t, [vwp:g, anc:-, im:past]).
lexicon('_PR', t, [vwp:_, anc:=, im:present]).
lexicon('_FUT', t, [anc:+, im:future]).
lexicon('va', t, [vwp:f, anc:+, im:future]).

lexicon(un, d, [vwp:f, im:'1']).	% quantity
lexicon(une, d, [vwp:f, im:'1']).	% quantity
lexicon(dix, d, [vwp:f, im:'10']).	
%lexicon(dix, d, [im:'10', occ:sing]).	% yes, singular
lexicon(le, d, [vwp:f, im:ce, occ:sing]).
lexicon(la, d, [vwp:f, im:ce, occ:sing]).
lexicon(ce, d, [vwp:f, im:ce, occ:sing]).
lexicon(cette, d, [vwp:f, im:ce, occ:sing]).
lexicon(du, d, [vwp:g]).	 


rephrase(future, 'dans le futur') :- !.
rephrase(past, 'dans le passé') :- !.
rephrase(sliced, 'à un moment de') :- !.
rephrase(cover, 'sur la durée de') :- !.
rephrase(repeat, répété) :- !.
rephrase(after, 'après') :- !.
rephrase(separate, separation) :- !.
rephrase(X,X).
