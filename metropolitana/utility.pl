% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

% stato: [at(station), Location]
% Location può essere in(NomeLine, Dir) o
%  'ground' se l'agente non è su nessun treno
% Dir può esere 0 o 1


% Azioni:
%  geton(Line, Dir)
%  getoff(station)
%  go(Line, Dir, stationPartenza, stationArrivo)

applicable(geton(Line,Dir),[at(Station),ground]):-
	stop(Station,Line), member(Dir,[0,1]).
applicable(getoff(Station),[at(Station),in(_,_)]).
applicable(go(Line,Dir,SP,SA),[at(SP),in(Line,Dir)]):-
	route(Line,Dir,SP,SA).

transform(geton(Line,Dir),[at(Station),ground],[at(Station),in(Line,Dir)]).
transform(getoff(Station),[at(Station),in(_,_)],[at(Station),ground]).
transform(go(Line,Dir,SP,SA),[at(SP),in(Line,Dir)],[at(SA),in(Line,Dir)]):-
	route(Line,Dir,SP,SA).

equal(S,S).

distance([at(Station)|_],[at(NewStation)|_],C) :-
	station(Station,Coord1,Coord2),
	station(NewStation,Coord1New,Coord2New),
	DeltaX is Coord1 - Coord1New,
	DeltaY is Coord2 - Coord2New,
	AbsDeltaX is abs(DeltaX),
	AbsDeltaY is abs(DeltaY),
	C is AbsDeltaX + AbsDeltaY.

evaluate([at(Station)|_],Hn) :-
	final([at(FinalStation),_]),
	station(Station,Coord1,Coord2),
	station(FinalStation,Coord1New,Coord2New),
	DeltaX is Coord1 - Coord1New,
	DeltaY is Coord2 - Coord2New,
	AbsDeltaX is abs(DeltaX),
	AbsDeltaY is abs(DeltaY),
	Hn is AbsDeltaX + AbsDeltaY.
