# JPSProj

Project for JPS classes.
Modified A* algorithm.

## Example input data:

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

## Example call:

```prolog
a_star(a, PathAndCost, 1, 10).
```

## Example input2 data:

```prolog
succ( [ pos(0, EmptyPos)|TilePositions], [pos(0, NewEmptyPos)|NewTilePositions ] ) :-
    find_neighbour(EmptyPos, TilePositions,
    NewEmptyPos, NewTilePositions) .

find_neighbour(EmptyPos, [pos(Neighb, NeighbPos)|RestPositions], NeighbPos, [pos(Neighb, EmptyPos)|RestPositions]) :-
    adjacent(EmptyPos, NeighbPos).
find_neighbour(EmptyPos, [T|RestPositions], NewEmptyPos, [T|NewPositions]) :-
    find_neighbour(EmptyPos, RestPositions, NewEmptyPos, NewPositions) .

adjacent(X1/Y1, X2/Y1) :- DiffX is X1-X2,

abs(DiffX, 1). adjacent(X1/Y1, X1/Y2) :-
    DiffY is Y1-Y2, abs(DiffY, 1).

abs(X, X) :-
    X >=0, !.

abs(X,AbsX) :- AbsX is -X.
```
