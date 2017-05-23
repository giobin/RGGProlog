num_col(10).
num_rows(10).

initial(pos(4,2)).

% occupied(pos(2,5)).
% occupied(pos(3,5)).
% occupied(pos(4,5)).
% occupied(pos(5,5)).
% occupied(pos(6,5)).
% occupied(pos(7,5)).
% occupied(pos(7,1)).
% occupied(pos(7,2)).
% occupied(pos(7,3)).
% occupied(pos(7,4)).
% occupied(pos(5,7)).
% occupied(pos(6,7)).
% occupied(pos(7,7)).
% occupied(pos(8,7)).
% occupied(pos(4,7)).
% occupied(pos(4,8)).
% occupied(pos(4,9)).
% occupied(pos(4,10)).
%
% final(pos(7,9)).
%
%-------------------
% Fail
occupied(pos(3,1)).
occupied(pos(3,2)).
occupied(pos(3,3)).
occupied(pos(3,4)).
occupied(pos(4,4)).
occupied(pos(5,4)).
occupied(pos(6,4)).
occupied(pos(6,3)).
occupied(pos(6,2)).
occupied(pos(6,1)).

final(pos(1,8)).
%-------------------

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
