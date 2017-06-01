% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

%  -------------------------------COMMANDS-------------------------------
% consult('histories/history2-ok.pl'), consult('utility.pl'), consult('idastar.pl').
% startItDeepStar.

% Iterative deepening A*
startItDeepStar :-
  retractall(currentMaxFn(_)),
  retractall(newMinFn(_)),
  assertz(counterClosedNodes(0)),
  statistics(walltime, [_ | [_]]),
  initial(InitialState),
  evaluate(InitialState,0,Hn),
  assertz(currentMaxFn(Hn)),
  idastar,!.

idastar :-
  initial(InitialState),
  i_star(InitialState,0,[InitialState],Moves), %InitialState,Gn,ecc
  statistics(walltime, [_ | [ExecutionTime]]),
	length(Moves,Length),
  counterClosedNodes(Counter),
  format('~w~w~n', ['Closed nodes : ',Counter]),
	format('~w~w~w~n', ['Solution length : ',Length, '.']),
  format('~w~w~w~n', ['Time : ',ExecutionTime, 'ms.']),
  write(Moves).
idastar :-
  retractall(currentMaxFn(_)),
  newMinFn(Fn),
  assertz(currentMaxFn(Fn)),
  retractall(newMinFn(Fn)),
  idastar.

i_star([1,2,3,4,5,6,empty,8,7],_,_,_):- write('Fail.\n'),abort.
i_star(State,Gn,_,[]) :-
  final(State),
  evaluate(State,0,Hn),
  currentMaxFn(FnC),
  Fn is Gn + Hn,
  Fn =< FnC,!.
i_star(State,Gn,Visited,[Action|MovesSequence]) :-
  evaluate(State,0,Hn),
  currentMaxFn(FnC),
  Fn is Gn + Hn,
  Fn =< FnC,!,
  applicable(Action,State),
  transform(Action,State,NewState),
  \+member(NewState,Visited),
  GnNew is Gn + 1,
  counterClosedNodes(Count),
  Counter is Count+1,
  retractall(counterClosedNodes(_)),
  assertz(counterClosedNodes(Counter)),
  i_star(NewState,GnNew,[NewState|Visited],MovesSequence).
i_star(State,Gn,_,_) :-
  newMinFn(FnN),!,
  evaluate(State,0,Hn),
  Fn is Gn + Hn,
  Fn =< FnN,
  retractall(newMinFn(FnN)),
  assertz(newMinFn(Fn)),
  fail.
i_star(State,Gn,_,_) :-
  evaluate(State,0,Hn),
  Fn is Gn + Hn,
  assertz(newMinFn(Fn)),
  fail.
