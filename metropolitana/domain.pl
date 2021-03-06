% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

% path(Line, Dir, ListaFermate)

path(piccadilly,0,['Kings Cross','Holborn','Covent Garden',
	'Leicester Square','Piccadilly Circus','Green Park','South Kensington',
	'Gloucester Road','Earls Court']).
path(jubilee,0,['Baker Street','Bond Street','Green Park',
	'Westminster','Waterloo','London Bridge']).
path(central,0,['Notting Hill Gate','Bond Street','Oxford Circus',
	'Tottenham Court Road','Holborn','Bank']).
path(victoria,0,['Kings Cross','Euston','Warren Street',
	'Oxford Circus','Green Park','Victoria']).
path(bakerloo,0,['Paddington','Baker Street','Oxford Circus',
	'Piccadilly Circus','Embankment','Waterloo']).
path(circle,0,['Embankment','Westminster','Victoria','South Kensington',
	'Gloucester Road','Notting Hill Gate','Bayswater','Paddington',
	'Baker Street','Kings Cross']).

path(Line,1,LR):- path(Line,0,L), reverse(L,LR).


% route(NomeLine, Dir, StationPartenza, StationArrivo)

route(Line,Dir,SP,SA):- path(Line,Dir,LF), member_pair(SP,SA,LF).

member_pair(X,Y,[X,Y|_]).
member_pair(X,Y,[_,Z|Rest]):- member_pair(X,Y,[Z|Rest]).


% Station(Station, Coord1, Coord2)

station('Baker Street',4.5,5.6).
station('Bank',12,4).
station('Bayswater',1,3.7).
station('Bond Street',5.4,4.1).
station('Covent Garden',8,4).
station('Earls Court',0,0).
station('Embankment',8.2,3).
station('Euston',7.1,6.6).
station('Gloucester Road',1.6,0.6).
station('Green Park',6,2.8).
station('Holborn',8.6,4.8).
station('Kings Cross',8.2,7.1).
station('Leicester Square',7.6,3.6).
station('London Bridge',0,0).
station('Notting Hill Gate',0,3.2).
station('Oxford Circus',6.2,4.3).
station('Paddington',2.4,4.2).
station('Piccadilly Circus',7,3.3).
station('South Kensington',2.6,0.5).
station('Tottenham Court Road',7.4,4.5).
station('Victoria',5.8,1).
station('Warren Street',6.5,6).
station('Waterloo',9.2,2.4).
station('Westminster',8,1.8).


stop(Station,Line):- path(Line,0,P), member(Station,P).
