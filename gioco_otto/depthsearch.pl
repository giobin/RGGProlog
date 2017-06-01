% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

%  -------------------------------COMMANDS-------------------------------
% consult('histories/history2-ok.pl'), consult('utility.pl'), consult('depthsearch.pl').
% depthsearch_cc.

% Depthsearch with loop
depthsearch :-
	statistics(walltime, [_ | [_]]),
	initial(InitialState),
	d_search(InitialState,Moves),
	length(Moves,Length),
	format('~w~w~w~n', ['Solution length : ',Length, '.']),
	write(Moves),!.

% Depthsearch with cycles control
depthsearch_cc :-
	assertz(counterClosedNodes(0)),
	statistics(walltime, [_ | [_]]),
	initial(InitialState),
	d_search_cc(InitialState,[InitialState],Moves),
	length(Moves,Length),
  counterClosedNodes(Counter),
  format('~w~w~n', ['Closed nodes : ',Counter]),
	format('~w~w~w~n', ['Solution length : ',Length, '.']),
	write(Moves),!.

d_search([1,2,3,4,5,6,empty,8,7],_):- write('Fail.\n'),abort.
d_search(State,[]):-final(State),!,
	statistics(walltime, [_ | [ExecutionTime]]),
	format('~w~w~w~n', ['Time : ',ExecutionTime, 'ms.']).
d_search(State,[Action|MovesSequence]):-
	applicable(Action,State),
	transform(Action,State,NewState),
	d_search(NewState,MovesSequence).

d_search_cc([1,2,3,4,5,6,empty,8,7],_,_):- write('Fail.\n'),abort.
d_search_cc(State,_,[]):-
	final(State),!,
	statistics(walltime, [_ | [ExecutionTime]]),
	format('~w~w~w~n', ['Time : ',ExecutionTime, 'ms.']).
d_search_cc(State,Visited,[Action|MovesSequence]):-
	applicable(Action,State),
	transform(Action,State,NewState),
	\+member(NewState,Visited),
	counterClosedNodes(Count),
  Counter is Count+1,
  retractall(counterClosedNodes(_)),
  assertz(counterClosedNodes(Counter)),
	d_search_cc(NewState,[NewState|Visited],MovesSequence).
