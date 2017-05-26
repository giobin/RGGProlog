% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

%  -------------------------------COMMANDS-------------------------------
% consult('maps/map1-fail-10x10.pl'), ('utility.pl'), consult('astar.pl').
% astar.

% A* search algorithm
astar :-
	statistics(walltime, [_ | [_]]),
	initial(InitialState),
	evaluate(InitialState,Hn),
	astar_while([node(InitialState,0,Hn,father(nil,nil))],[],Solution),
	write(Solution).

astar_while(Open,Closed,Solution):-
	select(Open,Closed,node(State,Gn,Hn,Father),_,_),
	final(State),!,
	statistics(walltime, [_ | [ExecutionTime]]),
	format('~w~w~w~n', ['Time : ',ExecutionTime, 'ms.']),
  print_solution(node(State,Gn,Hn,Father),Solution).

astar_while(Open,Closed,Solution) :-
	select(Open,Closed,Node,NewOpen1,NewClosed1),
	expandStar(Node,NewNodes),
	updateStates(NewNodes,NewOpen1,NewClosed1,NewOpen2,NewClosed2),
  astar_while(NewOpen2,NewClosed2,Solution).

select(Open,Closed,MinNode,NewOpen,[MinNode|Closed]) :-
	min1(Open,MinNode),
	delete(Open,MinNode,NewOpen).

min1([Head],Head) :-!.
min1([Head|OtherNodes],MinNode) :-
	min1(OtherNodes,Head,MinNode).

min1([],MinNode,MinNode).
min1([node(State,Gn,Hn,Father)|OtherNodes],node(_,GnMin,HnMin,_),MinNode) :-
	Fn is Gn + Hn,
	FnMin is GnMin + HnMin,
	Fn < FnMin,!,
	min1(OtherNodes,node(State,Gn,Hn,Father),MinNode).
min1([_|OtherNodes],CurrentMin,MinNode) :-
	min1(OtherNodes,CurrentMin,MinNode).

expandStar(node(State,Gn,Hn,Father),SuccesorStates) :-
  findAll(State,ApplicableActions),
  successor(node(State,Gn,Hn,Father),ApplicableActions,SuccesorStates).

findAll(State,ApplicableActions) :-
  fAll([est,ovest,sud,nord],State,ApplicableActions). % qui quindi non c'è più il punto di scelta come in profondità e termina quando trova la prima soluzione che sarà anche quella ottima.

fAll([],_,[]) :- !.
fAll([Action|OtherActions],State,[Action|OtherApplicableActions]) :-
  applicable(Action,State),!,
  fAll(OtherActions,State,OtherApplicableActions).
fAll([_|OtherActions],State,OtherApplicableActions) :-
  fAll(OtherActions,State,OtherApplicableActions).

successor(_,[],[]) :- !.
successor(node(State,Gn,Hn,Father),[Action|OtherApplicableActions],[node(NewState,GnS,HnS,father(Action,node(State,Gn,Hn,Father)))|SuccessorList]) :-
  GnS is Gn + 1,
  transform(Action,State,NewState),
  evaluate(NewState,HnS), % calcoliamo già nell'expand fn prov
  successor(node(State,Gn,Hn,Father),OtherApplicableActions,SuccessorList).

updateStates([],Open,Closed,Open,Closed) :- !.
updateStates([node(State,GnProv,HnProv,FatherProv)|OtherNewNodes],Open,Closed,NewOpen,NewClosed) :-
  \+member(node(State,_,_,_),Open),
  \+member(node(State,_,_,_),Closed),!,
  updateStates(OtherNewNodes,[node(State,GnProv,HnProv,FatherProv)|Open],Closed,NewOpen,NewClosed).
updateStates([node(State,GnProv,HnProv,FatherProv)|OtherNewNodes],Open,Closed,NewOpen,NewClosed) :-
  member(node(State,Gn,Hn,Father),Open),!,
  openCase(node(State,Gn,Hn,Father),node(State,GnProv,HnProv,FatherProv),Open,TempOpen),
  updateStates(OtherNewNodes,TempOpen,Closed,NewOpen,NewClosed).
updateStates([node(State,GnProv,HnProv,FatherProv)|OtherNewNodes],Open,Closed,NewOpen,NewClosed) :-
  member(node(State,Gn,Hn,Father),Closed),!,
  closedCase(node(State,Gn,Hn,Father),node(State,GnProv,HnProv,FatherProv),Open,TempOpen,Closed,TempClosed),
  updateStates(OtherNewNodes,TempOpen,TempClosed,NewOpen,NewClosed).

openCase(node(State,Gn,Hn,Father),node(State,GnProv,HnProv,FatherProv),Open,[node(State,GnProv,HnProv,FatherProv)|TempOpen]) :-
  FnProv is GnProv + HnProv,
  Fn is Gn + Hn,
  FnProv < Fn,!,
  delete(Open,node(State,Gn,Hn,Father),TempOpen).
openCase(_,_,Open,Open).

closedCase(node(State,Gn,Hn,Father),node(State,GnProv,HnProv,FatherProv),Open,[node(State,GnProv,HnProv,FatherProv)|Open],Closed,NewClosed) :-
  FnProv is GnProv + HnProv,
  Fn is Gn + Hn,
  FnProv < Fn,!,
  delete(Closed,node(State,Gn,Hn,Father),NewClosed).
closedCase(_,_,Open,Open,Closed,Closed).

print_solution(node(_,_,_,father(nil,nil)),[]) :- !.
print_solution(node(_,_,_,father(Action,Node)),Solution) :-
    print_solution(Node,TempSolution),
    append(TempSolution,[Action],Solution).
