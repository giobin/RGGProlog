% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

%  -------------------------------COMMANDS-------------------------------
% consult('maps/map1-fail-10x10.pl'), consult('utility.pl'), consult('maxdepthsearch.pl').
% Ex: maxdepthsearch(10).

% Depth-limited search
maxdepthsearch(Depth) :-
	statistics(walltime, [_ | [_]]),
	initial(InitialState),
	assertz(counterClosedNodes(0)),
	maxd_search(InitialState,Depth,[InitialState],Moves),
	length(Moves,Length),
	format('~w~w~w~n', ['Solution length : ',Length, '.']),
	counterClosedNodes(Counter),
  format('~w~w~n', ['Closed nodes : ',Counter]),
	write(Moves),!.

maxd_search(S,_,_,[]) :- final(S),!,
	statistics(walltime, [_ | [ExecutionTime]]),
	%length(Visited,Length),
	%format('~w~w~n', ['Closed nodes : ',Length]),
	format('~w~w~w~n', ['Time : ',ExecutionTime, 'ms.']).
maxd_search(S,Depth,Visited,[Action|MovesSequence]) :-
	Depth > 0,
	NewDepth is Depth - 1,
	applicable(Action,S),
	transform(Action,S,NewState),
	\+member(NewState,Visited),
	counterClosedNodes(Count),
  Counter is Count+1,
  retractall(counterClosedNodes(_)),
  assertz(counterClosedNodes(Counter)),
	maxd_search(NewState,NewDepth,[NewState|Visited],MovesSequence).
