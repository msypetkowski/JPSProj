:- begin_tests(astar2).
:- include("AStar2.pl").
% :- use_module(library(lists)).

test(replace_node1) :-
        replace_node(
            node(c,9,8,7,6),
            [
                node(a,1,8,3,4),
                node(b,1,0,3,4),
                node(c,1,2,3,4),
                node(x,1,2,3,9)
            ],
            [
                node(a,1,8,3,4),
                node(b,1,0,3,4),
                node(c,9,8,7,6),
                node(x,1,2,3,9)
            ]).

test(replace_node2) :-
        replace_node(
            node(c,9,8,7,6),
            [
                node(c,1,8,3,4)
            ],
            [
                node(c,9,8,7,6)
            ]).

/*

a
|\
| \
b  c
|  |\
|  | \
|  e  f
d

ClosedSet:
    [node(a,nil, nil, 0, 0),
     node(b,ab, a, 1, 1),
     node(c,ac, a, 1, 1),
     node(d,bd, b, 2, 2),
     node(e,ce, c, 2, 2),
     node(f,cf, c, 2, 2)]

*/
test(is_ancestor1) :-
    is_ancestor(
        node(c,ac,a,1,1), a,

        [node(a,nil, nil, 0, 0),
        node(b,ab, a, 1, 1),
        node(c,ac, a, 1, 1),
        node(d,bd, b, 2, 2),
        node(e,ce, c, 2, 2),
        node(f,cf, c, 2, 2)]).

test(is_ancestor2, [fail]) :-
    is_ancestor(
        node(c,ac,a,1,1), f,

        [node(a,nil, nil, 0, 0),
        node(b,ab, a, 1, 1),
        node(c,ac, a, 1, 1),
        node(d,bd, b, 2, 2),
        node(e,ce, c, 2, 2),
        node(f,cf, c, 2, 2)]).

test(is_ancestor3, [nondet]) :- % practically it is deterministic, returns true then fail
    is_ancestor(
        node(e,ce, c, 2, 2), a,

        [node(a,nil, nil, 0, 0),
        node(b,ab, a, 1, 1),
        node(c,ac, a, 1, 1),
        node(d,bd, b, 2, 2),
        node(e,ce, c, 2, 2),
        node(f,cf, c, 2, 2)]).

:- end_tests(astar2).
