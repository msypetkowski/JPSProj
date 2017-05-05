# JPSProj

Project for JPS classes.
Modified A* algorithm.

## Example input data:

```prolog
succ(a, passAB, 1, b).
succ(b, passBC, 3, c).

succ(a, passAD, 3, d).
succ(d, passDC, 1, c).

hScore(a, 0).
hScore(b, 3).
hScore(c, 0).
hScore(d, 0).

goal(c).
```

## Example call:

```prolog
a_star(a, PathAndCost, 1, 10).
```
