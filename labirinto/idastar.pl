% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

%  -------------------------------COMMANDS-------------------------------
% consult('maps/map1-fail-10x10.pl'), consult('utility.pl'), consult('idastar.pl').
% startItDeepStar.

% Iterative deepening A*
startItDeepStar :-
  retractall(currentMaxFn(_)),
  retractall(newMinFn(_)),
  statistics(walltime, [_ | [_]]),
  initial(InitialState),
  evaluate(InitialState,Hn),
  assertz(currentMaxFn(Hn)),
  assertz(cutoff),
  idastar.

idastar :-
  initial(InitialState),
  i_star(InitialState,0,[InitialState],Moves), %InitialState,Gn,ecc
  statistics(walltime, [_ | [ExecutionTime]]),
  format('~w~w~w~n', ['Time : ',ExecutionTime, 'ms.']),
  length(Moves,Length),
  format('~w~w~w~n', ['Solution length : ',Length, '.']),
  write(Moves).
idastar :-
  retractall(currentMaxFn(_)),
  newMinFn(Fn),
  assertz(currentMaxFn(Fn)),
  retractall(newMinFn(Fn)),
  idastar.

 i_star(State,Gn,Visited,[]) :-
    final(State),
    evaluate(State,Hn),
    currentMaxFn(FnC),
    Fn is Gn + Hn,
    Fn =< FnC,!,
    length(Visited,Length),
    format('~w~w~n', ['Closed nodes : ',Length]).
 i_star(State,Gn,Visited,[Action|MovesSequence]) :-
    evaluate(State,Hn),
    currentMaxFn(FnC),
    Fn is Gn + Hn,
    Fn =< FnC,!,
    applicable(Action,State),
    transform(Action,State,NewState),
    \+member(NewState,Visited),
    GnNew is Gn + 1,
    i_star(NewState,GnNew,[NewState|Visited],MovesSequence).
 i_star(State,Gn,_,_) :-
    applicable(_,State),        % It is necessary in case of no solution (similiar to cutoff in iterativedeeping)
    newMinFn(FnN),!,
    evaluate(State,Hn),
    Fn is Gn + Hn,
    Fn =< FnN,
    retractall(newMinFn(FnN)),
    assertz(newMinFn(Fn)),
    fail.
 i_star(State,Gn,_,_) :-
    applicable(_,State),        % It is necessary in case of no solution (similiar to cutoff in iterativedeeping)
    evaluate(State,Hn),
    Fn is Gn + Hn,
    assertz(newMinFn(Fn)),
    fail.
