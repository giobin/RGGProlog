% Authors: Riccardo Renzulli, Gabriele Sartor
% Università degli Studi di Torino
% Department of Computer Science
% Date: September 2016
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it

% consult('utility.pl'), consult('breadthfirstsearch.pl'), breadthfirstsearch.

% Breadth-first search / Uniform-cost search
breadthfirstsearch :-
  initial(State),
  bf_search([node(State,0,[])],[],Moves),  %node(State,Gn,Action)
  write(Moves).

bf_search([node(State,_,ActionList)|_],_,ActionList) :- final(State),!.
bf_search(Frontier,Visited,Solution) :-
  min1(Frontier,MinNode),
  delete(Frontier,MinNode,TempFrontier),
  expand(MinNode,[MinNode|Visited],TempFrontier,NewFrontier),
  bf_search(NewFrontier,[MinNode|Visited],Solution).

% Given a state State with its action list returns all successor states.
expand(node(State,Gn,ActionList),Visited,Frontier,NewFrontier) :-
  findAll(State,ApplicableActions),
  successor(node(State,Gn,ActionList),ApplicableActions,Visited,Frontier,NewFrontier).

% Returns all applicable actions of the state State.
% findAll(State,ApplicableActions) :-
%   fAll([geton(_,_),getoff(_),go(_,_,_,_)],State,ApplicableActions). % qui quindi non c'è più il punto di scelta come in profondità e termina quando trova la prima soluzione che sarà anche quella ottima.

findAll([at(Station),ground],ApplicableActions) :- !,
  fAll([geton(_,0),geton(_,1)],[at(Station),ground],ApplicableActions). % qui quindi non c'è più il punto di scelta come in profondità e termina quando trova la prima soluzione che sarà anche quella ottima.
findAll([at(Station),in(Line,Dir)],ApplicableActions) :-
  fAll([getoff(Station),go(Line,Dir,Station,_)],[at(Station),in(Line,Dir)],ApplicableActions). % qui quindi non c'è più il punto di scelta come in profondità e termina quando trova la prima soluzione che sarà anche quella ottima.

fAll([],_,[]) :- !.
fAll([Action|OtherActions],State,[Action|OtherApplicableActions]) :-
  applicable(Action,State),!,
  fAll(OtherActions,State,OtherApplicableActions).
fAll([_|OtherActions],State,OtherApplicableActions) :-
  fAll(OtherActions,State,OtherApplicableActions).

successor(_,[],_,Frontier,Frontier) :- !.
successor(node(State,Gn,ActionList),[Action|OtherApplicableActions],Visited,Frontier,NewFrontier) :-
  transform(Action,State,NewState),
  \+member(node(NewState,_,_),Visited),!,
  append(ActionList,[Action],NewActionList),
  checkDistance(State,Gn,NewState,NewActionList,Frontier,TempFrontier),
  successor(node(State,Gn,ActionList),OtherApplicableActions,Visited,TempFrontier,NewFrontier).

successor(node(State,Gn,ActionList),[_|OtherApplicableActions],Visited,Frontier,NewFrontier) :-
  successor(node(State,Gn,ActionList),OtherApplicableActions,Visited,Frontier,NewFrontier).

checkDistance(State,Gn,NewState,NewActionList,Frontier,[node(NewState,NewGn,NewActionList)|NewFrontier]) :-
  distance(State,NewState,C),
  NewGn is Gn + C,
  member(node(NewState,OldGn,OldActionList),Frontier),
  NewGn < OldGn,!,
  delete(Frontier,node(NewState,OldGn,OldActionList),NewFrontier).

checkDistance(_,_,NewState,_,Frontier,Frontier) :-
  member(node(NewState,_,_),Frontier),!.

checkDistance(State,Gn,NewState,NewActionList,Frontier,[node(NewState,NewGn,NewActionList)|Frontier]) :-
  distance(State,NewState,C),
  NewGn is Gn + C.

min1([Head],Head) :-!.
min1([Head|OtherNodes],MinNode) :-
	min1(OtherNodes,Head,MinNode).

min1([],MinNode,MinNode).
min1([node(State,Gn,ActionList)|OtherNodes],node(_,GnMin,_),MinNode) :-
	Gn < GnMin,!,
	min1(OtherNodes,node(State,Gn,ActionList),MinNode).
min1([_|OtherNodes],CurrentMin,MinNode) :-
	min1(OtherNodes,CurrentMin,MinNode).
