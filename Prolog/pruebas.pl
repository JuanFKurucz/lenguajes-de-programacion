%UT2 - Pruebas basicas
language(ut1, haskell).
language(ut2, prolog).
language(ut3, clang).
language(ut4, ruby).
language(ut5, javascript).

%UT2 - Ejercicio 1.1: Regla de 3.
%rule3(A, B, C, X) :- X is B * C / A. % Es correcto pero puede generalizarse.
rule3(A, B, C, X) :- var(X), X is B * C / A.
rule3(A, B, X, D) :- var(X), X is D * A / B.
rule3(A, X, C, D) :- var(X), X is D * A / C.
rule3(X, B, C, D) :- var(X), X is B * C / D.

%UT2 -  Ejercicio 1.2: inBetween.
%inBetween(X, B, C) :- var(X), X is B =< C.
%inBetween(X, B, C) :- B >= A, B =< C.
%inBetween(A, X, C) :- var(X).
%inBetween(A, B, X) :- var(X).
%inBetween(A,B,C) :- \+ var(A), \+ var(B), \+ var(C), A =< B, B =< C.

%UT2 -  Ejercicio 1.3: Factorial.
factorial(0, 1).
factorial(N, F) :- N > 0, M is N - 1, factorial(M, G), F is G * N.

%UT2 - Ejercicio 1.4: Zip.
zip([], _ , []).
zip(_, [], []).
zip([X|XS], [Y|YS], [pair(X,Y)|Z]) :- zip(XS,YS,Z).

% UT2 - Ejercicio 1.5: treeHeight
treeHeight(nil, 0).
treeHeight(tree(_, Y, Z), H) :- treeHeight(Y, R1), treeHeight(Z,R2), H is max(R1,R2) + 1.

%UT2 - TicTacToe

% Condiciones para determinar ganador
winner(tictactoe(P,P,P,_,_,_,_,_,_), P) :- P \= empty.
winner(tictactoe(_,_,_,P,P,P,_,_,_), P) :- P \= empty.
winner(tictactoe(_,_,_,_,_,_,P,P,P), P) :- P \= empty.
winner(tictactoe(P,_,_,P,_,_,P,_,_), P) :- P \= empty.
winner(tictactoe(_,P,_,_,P,_,_,P,_), P) :- P \= empty.
winner(tictactoe(_,_,P,_,_,P,_,_,P), P) :- P \= empty.
winner(tictactoe(P,_,_,_,P,_,_,_,P), P) :- P \= empty.
winner(tictactoe(_,_,P,_,P,_,P,_,_), P) :- P \= empty.

% Condiciones para determinar perdedor (por opuesto)
loser(T,playerX) :- winner(T,player0).
loser(T,player0) :- winner(T,playerX).

% De un tablero devuelve una lista
tictactoe2List(tictactoe(S0,S1,S2,S3,S4,S5,S6,S7,S8),[S0,S1,S2,S3,S4,S5,S6,S7,S8]).

% Cuenta cuantos casilleros quedan vacios
emptyCount(tictactoe(S1,S2,S3,S4,S5,S6,S7,S8,S9),N) :-
                                                    emptyCount([S1,S2,S3,S4,S5,S6,S7,S8,S9], N).

emptyCount([],0).
emptyCount([empty|SS],N) :- emptyCount(SS,M), N is M + 1.
emptyCount([S|SS], N) :- S \= empty, emptyCount(SS,N).

% Devuelve el jugador activo para el tablero T
activePlayer(T, playerX) :- emptyCount(T,N), 1 is mod(N,2).
activePlayer(T, player0) :- emptyCount(T,N), 0 is mod(N,2).

% Devuelve si el casillero esta vacio
emptySquare(T, N) :- tictactoe2List(T, L), Z = L ! N, Z = empty. 

%
validAction(T, mark(P, C)) :- activePlayer(T, P), emptySquare(T, C).

% Marca un casillero vacio con el jugador activo
aux(T,[],[]).
aux(T,[Mark|Marks],R) :- aux(T,Marks,R), validAction(T,Mark), append(R,[Mark]).

validActions(T, AS) :- aux(T,[mark(playerX,0),mark(playerX,1),mark(playerX,2),mark(playerX,3),mark(playerX,4),mark(playerX,5),mark(playerX,6),mark(playerX,7),mark(playerX,8),mark(player0,0),mark(player0,1),mark(player0,2),mark(player0,3),mark(player0,4),mark(player0,5),mark(player0,6),mark(player0,7),mark(player0,8)], AS).

start(tictactoe(empty,empty,empty,empty,empty,empty,empty,empty,empty)).
%winner(tictactoe(A,B,C,D,E,F,G,H,I), P) :- ((A=B,A=C,P is A);(A=D,A=G,P is A);(B=E,B=H,P is B);(C=F,C=I,P is C);(D=E,D=F,P is D);(G=H,G=I, P is G);(A=E,A=I, P is A);(G=E,G=C, P is G)),P \= empty.

%tictactoe(playerX,playerX,playerX,empty,empty,player0,player0,empty,empty)

nextState(tictactoe(empty,S1,S2,S3,S4,S5,S6,S7,S8), mark(P,0), tictactoe(P,S1,S2,S3,S4,S5,S6,S7,S8)).
nextState(tictactoe(S0,empty,S2,S3,S4,S5,S6,S7,S8), mark(P,1), tictactoe(S0,P,S2,S3,S4,S5,S6,S7,S8)).
nextState(tictactoe(S0,S1,empty,S3,S4,S5,S6,S7,S8), mark(P,2), tictactoe(S0,S1,P,S3,S4,S5,S6,S7,S8)).
nextState(tictactoe(S0,S1,S2,empty,S4,S5,S6,S7,S8), mark(P,3), tictactoe(S0,S1,S2,P,S4,S5,S6,S7,S8)).
nextState(tictactoe(S0,S1,S2,S3,empty,S5,S6,S7,S8), mark(P,4), tictactoe(S0,S1,S2,S3,P,S5,S6,S7,S8)).
nextState(tictactoe(S0,S1,S2,S3,S4,S5,S6,empty,S8), mark(P,7), tictactoe(S0,S1,S2,S3,S4,S5,S6,P,S8)).
nextState(tictactoe(S0,S1,S2,S3,S4,S5,S6,S7,empty), mark(P,8), tictactoe(S0,S1,S2,S3,S4,S5,S6,S7,P)).

result(tictactoe, R) :- winner(tictactoe, P), P /= _, 
result(tictactoe, R) :- winner(tictactoe, P)