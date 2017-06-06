JPSProj
=======

Project for JPS classes.
Modified A* algorithm.

Running tests
-------------
```bash
swipl tests2.pl # tests for stage 2
```
then in prolog console
```prolog
run_tests.
```

Example 1
---------

#### input data:

```prolog
succ(a, passX1, 2, x).
succ(x, passX2, 1, b).

succ(a, passY1, 1, y).
succ(y, passY2, 3, b).

succ(a, passZ1, 3, z).
succ(z, passZ2, 1, b).

hScore(a, 0).

hScore(x, 0).
hScore(y, 0).
hScore(z, 0).

hScore(b, 0).

goal(b).

% global variable
fetch_choices(2).
```

#### Example call:

```prolog
a_star(a, PathAndCost, 1, 10).
```

Example 2
---------

#### input data

```prolog
succ([pos(0, EmptyPos)|TilePositions], passX, 1,  [pos(0, NewEmptyPos)|NewTilePositions]):-
    find_neighbour(EmptyPos, TilePositions, NewEmptyPos, NewTilePositions).


find_neighbour(EmptyPos, [pos(Neighb, NeighbPos)|RestPositions], NeighbPos, [pos(Neighb, EmptyPos)|RestPositions]) :-
    adjacent(EmptyPos, NeighbPos).
find_neighbour(EmptyPos, [T|RestPositions], NewEmptyPos, [T|NewPositions]):-
    find_neighbour(EmptyPos, RestPositions, NewEmptyPos, NewPositions).

adjacent(X1/Y1, X2/Y1):-
    DiffX is X1-X2,
    abs(DiffX, 1).
adjacent(X1/Y1, X1/Y2):-
    DiffY is Y1-Y2,
    abs(DiffY, 1).

abs(X, X) :-
    X >=0, !.
abs(X,AbsX) :-
    AbsX is -X.

% TODO
hScore(_, 0).

fetch_choices(1).

% 1 2 3
% 4 5 6
% 7 8
goal( [ pos(0 , 3/1), pos(1 , 1/3), pos(2 , 2/3),
    pos(3 , 3/3), pos(4 , 1/2), pos(5 , 2/2),
    pos(6 , 3/2), pos(7 , 1/1), pos(8 , 2/1) ] ).
```
#### example calls

```prolog
% TODO: why this one is not working
a_star([ pos(0 , 3/2), pos(1 , 2/3), pos(2 , 1/1), pos(3 , 1/3), pos(4 , 3/1), pos(5 , 1/2), pos(6 , 3/3), pos(7 , 2/1), pos(8 , 2/2) ], PC , 10, 10).
```

```prolog
% 1 2 3
% 4 5 6
% 7   8
a_star([ pos(0 , 2/1), pos(1 , 1/3), pos(2 , 2/3), pos(3 , 3/3), pos(4 , 1/2), pos(5 , 2/2), pos(6 , 3/2), pos(7 , 1/1), pos(8 , 3/1) ], PC, 2, 2).
```

```prolog
% TODO: why this one is not working
% 1 2 3
% 4   6
% 7 5 8
a_star([ pos(0 , 2/2), pos(1 , 1/3), pos(2 , 2/3), pos(3 , 3/3), pos(4 , 1/2), pos(5 , 2/1), pos(6 , 3/2), pos(7 , 1/1), pos(8 , 3/1) ], PC, 2, 2).
```

Example 1 for AStar2
--------------------

Not monotonic score function.
TODO: make it work - next stage of the project

#### input data:

```prolog
succ(a, ax, 1, x).
succ(a, ay, 2, y).

succ(x, xz, 1, z).
succ(y, yz, 1, z).

succ(z, zb, 10, b).

hScore(a, 0).
hScore(x, 11).
hScore(y, 0).
hScore(z, 0).
hScore(b, 0).

goal(b).

% global variable
fetch_choices(1).

```

#### Example call:

```prolog
start_A_star(a, PC).
```

Example 2 for AStar2
--------------------

Bigger version of Example3

#### input data:

```prolog
succ(a, ax, 1, x).
succ(a, ay, 2, y).

succ(x, xz, 1, z).
succ(y, yz, 1, z).

succ(z, zw, 1, w).
succ(w, wv, 1, v).
succ(v, vb, 10, b).

hScore(a, 0).
hScore(x, 13).
hScore(y, 0).
hScore(z, 0).
hScore(v, 0).
hScore(w, 0).

hScore(b, 0).


goal(b).

```

#### Example call:

```prolog
start_A_star(a, PC).
```
