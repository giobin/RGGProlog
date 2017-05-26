% Authors: Riccardo Renzulli, Gabriele Sartor, Giovanni Bonetta
% Università degli Studi di Torino
% Department of Computer Science
% Date: May 2017
% riccardo.renzulli@edu.unito.it
% gabriele.sartor@edu.unito.it
% giovanni.bonetta@edu.unito.it

%  -------------------------------COMMANDS-------------------------------
% consult('histories/history2-ok.pl'), consult('utility.pl'), consult('depthsearch.pl').
% depthsearch.

% Depthsearch with loop
depthsearch :-
	initial(InitialState),
	d_search(InitialState,Moves),
	write(Moves).

% Depthsearch with cycles control
depthsearch_cc :-
	initial(InitialState),
	d_search_cc(InitialState,[InitialState],Moves),
	write(Moves).

d_search(State,[]):-final(State),!.
d_search(State,[Action|MovesSequence]):-
	applicable(Action,State),
	transform(Action,State,NewState),
	d_search(NewState,MovesSequence).

d_search_cc(State,Visited,[]):-
	final(State),!,
	length(Visited,Length),
  format('~w~w~n', ['Closed nodes : ',Length]).
d_search_cc(State,Visited,[Action|MovesSequence]):-
	applicable(Action,State),
	transform(Action,State,NewState),
	\+member(NewState,Visited),
	d_search_cc(NewState,[NewState|Visited],MovesSequence).
