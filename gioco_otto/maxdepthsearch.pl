% Authors: Riccardo Renzulli, Gabriele Sartor
% Università degli Studi di Torino
% Department of Computer Science
% Date: September 2016
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it

% consult('utility.pl'), maxdepthsearch(...).

% Depth-limited search
maxdepthsearch(Depth) :-
	initial(InitialState),
	maxd_search(InitialState,Depth,[InitialState],Moves),
	write(Moves).

maxd_search(S,_,_,[]) :- final(S),!.
maxd_search(S,Depth,Visited,[Action|MovesSequence]) :-
	Depth > 0,
	NewDepth is Depth - 1,
	applicable(Action,S),
	transform(Action,S,NewState),
	\+member(NewState,Visited),
	maxd_search(NewState,NewDepth,[NewState|Visited],MovesSequence).
