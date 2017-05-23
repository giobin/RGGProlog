% Authors: Riccardo Renzulli, Gabriele Sartor
% Università degli Studi di Torino
% Department of Computer Science
% Date: September 2016
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it

% consult('utility.pl'), consult('idastar.pl'), startItDeepStar.

% Iterative deepening A*
startItDeepStar :-
  retractall(currentMaxFn(_)),
  retractall(newMinFn(_)),
  initial(InitialState),
  evaluate(InitialState,0,Hn),
  assertz(currentMaxFn(Hn)),
  idastar.

idastar :-
  initial(InitialState),
  i_star(InitialState,0,[InitialState],Moves), %InitialState,Gn,ecc
  write(Moves).
idastar :-
    retractall(currentMaxFn(_)),
    newMinFn(Fn),
    assertz(currentMaxFn(Fn)),
    retractall(newMinFn(Fn)),
    idastar.

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