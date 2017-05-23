% Authors: Riccardo Renzulli, Gabriele Sartor
% Università degli Studi di Torino
% Department of Computer Science
% Date: September 2016
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it

% consult('utility.pl'), consult('iterativedeeping.pl'), startItDeep.

% Iterative deepening depth-first search
startItDeep :-
  retractall(currentMaxDepth(_)),
	assertz(currentMaxDepth(0)),
  assertz(cutoff),
	iterativeDeepening(Moves),
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

it_deep(State,_,_,[]) :- final(State),!.
it_deep(State,Depth,Visited,[Action|MovesSequence]) :-
	NewDepth is Depth + 1,
	currentMaxDepth(MaxDepth),
	NewDepth =< MaxDepth,!,
	applicable(Action,State),
	transform(Action,State,NewState),
	\+member(NewState,Visited),
	it_deep(NewState,NewDepth,[NewState|Visited],MovesSequence).
it_deep(State,_,_,[]) :-
  applicable(_,State),
  assertz(cutoff),
  fail.