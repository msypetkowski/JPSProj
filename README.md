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
