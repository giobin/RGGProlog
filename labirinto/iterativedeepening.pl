% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

%  -------------------------------COMMANDS-------------------------------
% consult('maps/map1-fail-10x10.pl'),consult('utility.pl'), consult('iterativedeeping.pl').
% startItDeep.

% Iterative deepening depth-first search
startItDeep :-
  retractall(currentMaxDepth(_)),
	assertz(currentMaxDepth(0)),
  assertz(cutoff),
  statistics(walltime, [_ | [_]]),
	iterativeDeepening(Moves),!,
	write(Moves).

iterativeDeepening(Moves) :-
	initial(InitialState),
	it_deep(InitialState,0,[InitialState],Moves).
iterativeDeepening(Moves) :-
  cutoff,
	currentMaxDepth(MaxDepth),
	NewMaxDepth is MaxDepth + 1,
	retractall(currentMaxDepth(_)),
  retractall(cutoff),
	assertz(currentMaxDepth(NewMaxDepth)),
	iterativeDeepening(Moves).

it_deep(State,_,_,[]) :- final(State),!,
  statistics(walltime, [_ | [ExecutionTime]]),
  format('~w~w~w~n', ['Time : ',ExecutionTime, 'ms.']).
it_deep(State,Depth,Visited,[Action|MovesSequence]) :-
	NewDepth is Depth + 1,
	currentMaxDepth(MaxDepth),
	NewDepth =< MaxDepth,!,
	applicable(Action,State),
	transform(Action,State,NewState),
	\+member(NewState,Visited),
	it_deep(NewState,NewDepth,[NewState|Visited],MovesSequence).
it_deep(State,_,_,[]) :-
  applicable(_,State),!,
  assertz(cutoff),
  fail.
