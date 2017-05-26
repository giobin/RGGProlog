% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

%  -------------------------------COMMANDS-------------------------------
% consult('histories/history2-ok.pl'), consult('utility.pl').
% Ex: maxdepthsearch(10).

% Depth-limited search
maxdepthsearch(Depth) :-
	initial(InitialState),
	maxd_search(InitialState,Depth,[InitialState],Moves),
	write(Moves).

maxd_search(S,_,Visited,[]) :- 
	final(S),!,
	length(Visited,Length),
	format('~w~w~n', ['Closed nodes : ',Length]).
maxd_search(S,Depth,Visited,[Action|MovesSequence]) :-
	Depth > 0,
	NewDepth is Depth - 1,
	applicable(Action,S),
	transform(Action,S,NewState),
	\+member(NewState,Visited),
	maxd_search(NewState,NewDepth,[NewState|Visited],MovesSequence).
