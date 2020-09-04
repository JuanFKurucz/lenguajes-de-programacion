% UT2 - Pruebas basicas
language(ut1, haskell).
language(ut2, prolog).
language(ut3, clang).
language(ut4, ruby).
language(ut5, javascript).

% UT2 - Ejercicio 1.1: Regla de 3
% rule3(A, B, C, X) :- X is B * C / A. % Es correcto pero puede generalizarse
rule3(A, B, C, X) :- var(X), X is B * C / A.
rule3(A, B, X, D) :- var(X), X is D * A / B.
rule3(A, X, C, D) :- var(X), X is D * A / C.
rule3(X, B, C, D) :- var(X), X is B * C / D.

% UT2 -  Ejercicio 1.2: inBetween
%inBetween(X, B, C) :- var(X), X is B =< C.
%inBetween(X, B, C) :- B >= A, B =< C.
%inBetween(A, X, C) :- var(X).
%inBetween(A, B, X) :- var(X).
%inBetween(A,B,C) :- \+ var(A), \+ var(B), \+ var(C), A =< B, B =< C.

% UT2 -  Ejercicio 1.3: Factorial
factorial(0, 1).
factorial(N, F) :- N > 0, M is N - 1, factorial(M, G), F is G * N.

% UT2 - Ejercicio 1.4: Zip
zip([], [], []).
zip([X|Xs], [Y|Ys], [X,Y|Zs]) :- zip(Xs,Ys,Zs).