/*---------------------------------------------------------------*/
/* Telecom Paris - J-L. Dessalles 2023                           */
/* Cognitive Approach to Natural Language Processing             */
/*            http://teaching.dessalles.fr/CANLP                 */
/*---------------------------------------------------------------*/




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lexicon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lexical entries : lexicon(<word>, <syntactic and semantic feature structure>)
% Feature structures are non-exhaustive lists: [ Feature1:Value1, Feature2:Value2]

lexicon(in, p, [vwp:f]).
lexicon(during, p, [vwp:g]).
lexicon(for, p, [vwp:g]).
lexicon('at', p, []).
lexicon('after', p, [vwp:f, im:'+']).

lexicon(', ', '+', []).

lexicon('Mary', dp, []).
lexicon('Peter', dp, [im:'Peter']).
lexicon(she, dp, []).
lexicon(he, dp, []).
lexicon(cafeteria, n, []).
lexicon(cake, n, []).
lexicon(water, dp, [vwp:g]).
lexicon(glass_of_wine, n, [vwp:f, im:glass_of_wine]).
lexicon(car, n, []).
lexicon(wine, n, []).
lexicon(wine, dp, [vwp:g]).

% durations
lexicon(year, n, [anc:0, dur:7.5]).
lexicon(year, n, [vwp:f, anc:1, dur:7.5, im:year_from_now]).
lexicon(day, n, [anc:0, dur:4.9]).
lexicon(day, n, [vwp:f, anc:1, dur:4.9, im:day_from_now]).
lexicon(hour, n, [anc:0, dur:3.6]).
lexicon(hour, n, [vwp:f, anc:1, dur:3.6, im:hour_from_now]).
lexicon(minute, n, [anc:0, dur:1.8]).
lexicon(minute, n, [vwp:f, anc:1, dur:1.8, im:minute_from_now]).
lexicon(minutes, n, [anc:0, im:minutes, dur:2.8]).
lexicon(minutes, n, [vwp:f, anc:1, dur:2.8, im:minutes_from_now]).
lexicon(second, n, [anc:0, dur:0]).
lexicon(second, n, [vwp:f, anc:1, dur:0, im:second_from_now]).
lexicon(seconds, n, [anc:0, dur:1]).
% lexicon(seconds, n, [vwp:f, anc:1, dur:1, im:seconds_from_now]).

% anchored periods
lexicon(2028, dp, [anc:1, vwp:f, im:'2028', dur:7.5]).
lexicon(2010, dp, [anc:1, vwp:f, im:'2010', dur:7.5]).
lexicon(show, n, [anc:1, dur:3.7]).


lexicon(snore, vp, [vwp:g, dur:2.8]).
lexicon(sneeze, vp, [vwp:f, dur:0]).
lexicon(drive, vp, [vwp:g, dur:4]).
lexicon(sleep, vp, [vwp:g, dur:4.3]).
lexicon(eat, vp, [vwp:f, im:eat_meal, dur:3.5]).
lexicon(eat, v, [vwp:f, im:ingest, dur:1.4]).
lexicon(eat, v, [vwp:g, im:eat_from, dur:1]).
lexicon(drink, v, [im:ingest, dur:0.9]).
% lexicon(drink, v, [im:ingest]).
lexicon(drink, vp, [im:drink_something, dur:0.9]).
lexicon(like, v, [vwp:g]).
lexicon(be, v, [vwp:g]).
lexicon(draw, vp, [vwp:g, im:draw, dur:1]).
lexicon(draw, v, [vwp:f, im:draw_sth, dur:3]).


lexicon('_PP', t, [anc:_, vwp:f, im:'-']).
lexicon('_PRET', t, [anc:_, im:'-']).
lexicon('_PRES', t, [anc:_, vwp:g, im:'=']).
lexicon('_FUT', t, [anc:_, im:'+']).
lexicon(will, t, [anc:_, vwp:f, im:+]).

lexicon(a, d, [im:'1', occ:_]).	% quantity
lexicon(an, d, [im:'1', occ:_]).	% quantity
lexicon(one, d, [im:'1', occ:_]).	% quantity
lexicon(ten, d, [im:'10', occ:_]).
% lexicon(the, d, [vwp:f, im:this, occ:sing]).
lexicon(the, d, [im:this, occ:sing]).
lexicon(this, d, [vwp:f, occ:unq]).
% lexicon(this, Cat, FS) :- lexicon(the, Cat, FS).
lexicon(some, d, [vwp:g]).	 



rephrase(future, 'in the future') :- !.
rephrase(past, 'in the past') :- !.
rephrase(sliced, 'at some moment in') :- !.
rephrase(repeat, repeated) :- !.
rephrase(separate, separated) :- !.
rephrase(pred_, '') :- !.
rephrase(X, X).
