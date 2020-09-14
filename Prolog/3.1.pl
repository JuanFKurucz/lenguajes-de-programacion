numToList(1,[queen,empty,empty,empty,empty,empty,empty,empty]).
numToList(2,[empty,queen,empty,empty,empty,empty,empty,empty]).
numToList(3,[empty,empty,queen,empty,empty,empty,empty,empty]).
numToList(4,[empty,empty,empty,queen,empty,empty,empty,empty]).
numToList(5,[empty,empty,empty,empty,queen,empty,empty,empty]).
numToList(6,[empty,empty,empty,empty,empty,queen,empty,empty]).
numToList(7,[empty,empty,empty,empty,empty,empty,queen,empty]).
numToList(8,[empty,empty,empty,empty,empty,empty,empty,queen]).


boardRows([A1,B1,C1,D1,E1,F1,G1,H1],[A,B,C,D,E,F,G,H]) :- numToList(A,A1), numToList(B,B1), numToList(C,C1), numToList(D,D1), 
numToList(E,E1), numToList(F,F1), numToList(G,G1), numToList(H,H1).



diagonalChecker(A, B, C) :- abs(A-B) =\= C. 

eightQueens([A,B,C,D,E,F,G,H]) :- 
    permutation([A,B,C,D,E,F,G,H], [1,2,3,4,5,6,7,8]), 

    diagonalChecker(A,B,1),
    diagonalChecker(A,C,2),
    diagonalChecker(A,D,3),
    diagonalChecker(A,E,4),
    diagonalChecker(A,F,5),
    diagonalChecker(A,G,6),
    diagonalChecker(A,H,7),

    diagonalChecker(B,C,1),
    diagonalChecker(B,D,2),
    diagonalChecker(B,E,3),
    diagonalChecker(B,F,4),
    diagonalChecker(B,G,5),
    diagonalChecker(B,H,6),

    diagonalChecker(C,D,1),
    diagonalChecker(C,E,2),
    diagonalChecker(C,F,3),
    diagonalChecker(C,G,4),
    diagonalChecker(C,H,5),

    diagonalChecker(D,E,1),
    diagonalChecker(D,F,2),
    diagonalChecker(D,G,3),
    diagonalChecker(D,H,4),

    diagonalChecker(E,F,1),
    diagonalChecker(E,G,2),
    diagonalChecker(E,H,3),

    diagonalChecker(F,G,1),
    diagonalChecker(F,H,2),

    diagonalChecker(G,H,1).

eightQueensBoard(B) :- boardRows(B,R), eightQueens(R).


% ?- boardRows(B,[1,2,3,4,5,6,7,8]).
% B = [[queen, empty, empty, empty, empty, empty, empty, empty], [empty, queen, empty, empty, empty, empty, empty|...], [empty, empty, queen, empty, empty, empty|...], [empty, empty, empty, queen, empty|...], [empty, empty, empty, empty|...], [empty, empty, empty|...], [empty, empty|...]].

%[[queen,empty,empty,empty,empty,empty,empty,empty],[empty,queen,empty,empty,empty,empty,empty,empty],[empty,empty,queen,empty,empty,empty,empty,empty],[empty,empty,empty,queen,empty,empty,empty,empty],[empty,empty,empty,empty,queen,empty,empty,empty],[empty,empty,empty,empty,empty,queen,empty,empty],[empty,empty,empty,empty,empty,empty,queen,empty],[empty,empty,empty,empty,empty,empty,empty,queen]]