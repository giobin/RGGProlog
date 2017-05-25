% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

applicable(est,pos(R,C)) :-
	num_col(NC), C<NC,
	C1 is C+1,
	\+ occupied(pos(R,C1)).
applicable(sud,pos(R,C)) :-
	num_rows(NR), R<NR,
	R1 is R+1,
	\+ occupied(pos(R1,C)).
applicable(ovest,pos(R,C)) :-
	C>1,
	C1 is C-1,
	\+ occupied(pos(R,C1)).
applicable(nord,pos(R,C)) :-
	R>1,
	R1 is R-1,
	\+ occupied(pos(R1,C)).

transform(est,pos(R,C),pos(R,C1)) :- C1 is C+1.
transform(ovest,pos(R,C),pos(R,C1)) :- C1 is C-1.
transform(sud,pos(R,C),pos(R1,C)) :- R1 is R+1.
transform(nord,pos(R,C),pos(R1,C)) :- R1 is R-1.

% Given a state State, returns the heuristic function h(n) using Manhattan distance
evaluate(pos(Xc,Yc),Hs):-
	final(pos(Xf,Yf)),
	DeltaX is Xc - Xf,
	DeltaY is Yc - Yf,
	AbsDeltaX is abs(DeltaX),
	AbsDeltaY is abs(DeltaY),
	Hs is AbsDeltaX + AbsDeltaY.
