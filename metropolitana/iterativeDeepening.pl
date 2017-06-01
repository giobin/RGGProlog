% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

%  -------------------------------COMMANDS-------------------------------
% consult('domain.pl'), consult('utility.pl'), consult('histories/history1.pl'), consult('iterativeDeepening.pl').
% startItDeep.

% Iterative deepening depth-first search
startItDeep :-
  retractall(currentMaxDepth(_)),
	assertz(currentMaxDepth(0)),
  assertz(counterClosedNodes(0)),
  statistics(walltime, [_ | [_]]),
	iterativeDeepening(Moves),
  length(Moves,Length),
  counterClosedNodes(Counter),
  format('~w~w~n', ['Closed nodes : ',Counter]),
  format('~w~w~w~n', ['Solution length : ',Length, '.']),!,
	write(Moves).

iterativeDeepening(Moves) :-
	initial(InitialState),
	it_deep(InitialState,0,[InitialState],Moves).
iterativeDeepening(Moves) :-
	currentMaxDepth(MaxDepth),
	NewMaxDepth is MaxDepth + 1,
	retractall(currentMaxDepth(_)),
	assertz(currentMaxDepth(NewMaxDepth)),
	iterativeDeepening(Moves).

it_deep(State,_,_,[]) :-
  final(State),!,
  statistics(walltime, [_ | [ExecutionTime]]),
  %length(Visited,Length),
  %format('~w~w~n', ['Closed nodes : ',Length]),
  format('~w~w~w~n', ['Time : ',ExecutionTime, 'ms.']).
it_deep(State,Depth,Visited,[Action|MovesSequence]) :-
	NewDepth is Depth + 1,
	currentMaxDepth(MaxDepth),
	NewDepth =< MaxDepth,
	applicable(Action,State),
	transform(Action,State,NewState),
	\+member(NewState,Visited),
  counterClosedNodes(Count),
  Counter is Count+1,
  retractall(counterClosedNodes(_)),
  assertz(counterClosedNodes(Counter)),
	it_deep(NewState,NewDepth,[NewState|Visited],MovesSequence).
