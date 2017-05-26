% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

%  -------------------------------COMMANDS-------------------------------
% consult('histories/history2-ok.pl'), consult('utility.pl'), consult('iterativedeeping.pl').
% startItDeep.

% Iterative deepening depth-first search
startItDeep :-
  retractall(currentMaxDepth(_)),
	assertz(currentMaxDepth(0)),
  statistics(walltime, [_ | [_]]),
	iterativeDeepening(Moves),
  statistics(walltime, [_ | [ExecutionTime]]),
	length(Moves,Length),
	format('~w~w~w~n', ['Solution length : ',Length, '.']),
  format('~w~w~w~n', ['Time : ',ExecutionTime, 'ms.']),
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

it_deep(State,_,Visited,[]) :-
  final(State),!,
  length(Visited,Length),
  format('~w~w~n', ['Closed nodes : ',Length]).
it_deep(State,Depth,Visited,[Action|MovesSequence]) :-
	NewDepth is Depth + 1,
	currentMaxDepth(MaxDepth),
	NewDepth =< MaxDepth,
	applicable(Action,State),
	transform(Action,State,NewState),
	\+member(NewState,Visited),
	it_deep(NewState,NewDepth,[NewState|Visited],MovesSequence).
