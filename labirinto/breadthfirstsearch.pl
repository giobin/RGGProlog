% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

% -------------------------------COMMANDS-------------------------------
% consult('maps/map1-fail-10x10.pl'),consult('utility.pl'), consult('breadthfirstsearch.pl').
% breadthfirstsearch.

% Breadth-first search
breadthfirstsearch :-
  statistics(walltime, [_ | [_]]),
  initial(State),
  bf_search([node(State,[])],[],Moves),
  length(Moves,Length),
  format('~w~w~w~n', ['Solution length : ',Length, '.']),
  write(Moves).

bf_search([node(State,ActionList)|_],_,ActionList) :-
  final(State),!,
  statistics(walltime, [_ | [ExecutionTime]]),
  format('~w~w~w~n', ['Time : ',ExecutionTime, 'ms.']).
bf_search([node(State,ActionList)|OtherNodes],Visited,Solution) :-
  expand(node(State,ActionList),[State|Visited],SuccesorStates),
  append(OtherNodes,SuccesorStates,NewTail),
  bf_search(NewTail,[State|Visited],Solution).

% Given a state State with its action list returns all successor states.
expand(node(State,ActionList),Visited,SuccesorStates) :-
  findAll(State,ApplicableActions),
  successor(node(State,ActionList),ApplicableActions,Visited,SuccesorStates).

% Returns all applicable actions of the state State.
findAll(State,ApplicableActions) :-
  fAll([est,ovest,sud,nord],State,ApplicableActions). % qui quindi non c'è più il punto di scelta come in profondità e termina quando trova la prima soluzione che sarà anche quella ottima.

fAll([],_,[]) :- !.
fAll([Action|OtherActions],State,[Action|OtherApplicableActions]) :-
  applicable(Action,State),!,
  fAll(OtherActions,State,OtherApplicableActions).
fAll([_|OtherActions],State,OtherApplicableActions) :-
  fAll(OtherActions,State,OtherApplicableActions).

successor(_,[],_,[]) :- !.
successor(node(State,ActionList),[Action|OtherApplicableActions],Visited,[node(NewState,NewActionList)|SuccessorList]) :-
  transform(Action,State,NewState),
  \+member(NewState,Visited),!,
  append(ActionList,[Action],NewActionList),
  successor(node(State,ActionList),OtherApplicableActions,Visited,SuccessorList).

successor(node(State,ActionList),[_|OtherApplicableActions],Visited,SuccessorList) :-
  successor(node(State,ActionList),OtherApplicableActions,Visited,SuccessorList).
