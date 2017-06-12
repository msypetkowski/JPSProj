%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
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

fetch_choices(10).

% 1 2 3
% 4 5 6
% 7 8
goal( [ pos(0 , 3/1), pos(1 , 1/3), pos(2 , 2/3),
    pos(3 , 3/3), pos(4 , 1/2), pos(5 , 2/2),
    pos(6 , 3/2), pos(7 , 1/1), pos(8 , 2/1) ] ).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

/*
* run start_A_star with N from NMin to NMax
*/
a_star(InitState, PathCost, NMin, NMax):-
    incr(NMax, NMax1),
    NMin < NMax1,
    write("Running start_A_star with N="), write(NMin), nl,
    start_A_star(InitState, PathCost, NMin),
    write("Path found!"), !.

a_star(InitState, PathCost, NMin, NMax):-
    incr(NMax, NMax1),
    NMin < NMax1,
    incr(NMin, NMin1),
    a_star(InitState, PathCost, NMin1, NMax).

a_star(_, _, NMax, NMax):-
    write("Max steps count reached!"), nl, fail.


/*
* wrapper for search_A_star
*/
start_A_star(InitState, PathCost, N):-
    score(InitState, 0, 0, InitCost, InitScore),
    search_A_star([node(InitState, nil, nil, InitCost , InitScore ) ], [ ], PathCost, N).

search_A_star(Queue, ClosedSet, PathCost, N):-
    N>(-1),
    next_node(Node, Queue, ClosedSet , RestQueue),
    write("--------------------------------------"),nl,
    write("Current step is "), write(N), nl,
    write("Possible choices: "), nl, print_nodes(Queue), nl,
    write("; Fetching "), nl, print_node(Node), nl,
    write(" OK ? (y/n) "), read(Continue),
    Continue == y,
    % write("Closed Set: "), write(ClosedSet), nl,
    continue(Node, RestQueue, ClosedSet, PathCost, N).


continue(node(State, Action, Parent, Cost, _) , _  ,  ClosedSet, path_cost(Path, Cost), _):-
    goal(State), !,
    build_path(node(Parent, _ ,_ , _ , _ ), ClosedSet, [Action/State], Path) .

continue(Node, RestQueue, ClosedSet, Path, N):-
    expand( Node, NewNodes),
    insert_new_nodes(NewNodes, RestQueue, NewQueue),
    decr(N, NewN),
    search_A_star(NewQueue, [Node | ClosedSet ], Path, NewN).

/*
* K is how many nodes at most will be produced
*/
next_node(Node, Queue, ClosedSet, RestQueue):-
    fetch_choices(K),
    fetch(Node, Queue, ClosedSet , RestQueue, K).

% wrong node (skip, and remove from Queue)
fetch(Node,
            [node(State, _,_, _, _) |Queue], ClosedSet,
            RestQueue, K) :-
    K>(0),
    member(node(State, _, _, _, _), ClosedSet), !,
    fetch(Node, Queue, ClosedSet , RestQueue, K).

% get node
fetch(N,
            [N|RestQueue], _,
            RestQueue, K) :-
    K>(0).


% skip node (but keep in Queue)
fetch(Node,
            [N|Queue], ClosedSet,
            [N|RestQueue], K) :-
    K>(0),
    decr(K, KDecr),
    fetch(Node, Queue, ClosedSet , RestQueue, KDecr).


expand(node(State, _, _, Cost, _), NewNodes):-
    findall(node(ChildState, Action, State, NewCost, ChildScore) ,
            (succ(State, Action, StepCost, ChildState),
                score(ChildState, Cost, StepCost, NewCost, ChildScore)) ,
                                            NewNodes).


score(State, ParentCost, StepCost, Cost, FScore):-
    Cost is ParentCost + StepCost,
    hScore(State, HScore),
    FScore is Cost + HScore.


insert_new_nodes([], Queue, Queue).

insert_new_nodes([Node|RestNodes], Queue, NewQueue):-
    insert_p_queue(Node, Queue, Queue1),
    insert_new_nodes( RestNodes, Queue1, NewQueue).


insert_p_queue(Node, [], [Node] ):- ! .

insert_p_queue(node(State, Action, Parent, Cost, FScore),
        [node(State1, Action1, Parent1, Cost1, FScore1)|RestQueue],
            [node(State1, Action1, Parent1, Cost1, FScore1)|Rest1]):-
    FScore >= FScore1, !,
    insert_p_queue(node(State, Action, Parent, Cost, FScore), RestQueue, Rest1) .

insert_p_queue(node(State, Action, Parent, Cost, FScore), Queue,
                [node(State, Action, Parent, Cost, FScore)|Queue]).


build_path(node(nil, _, _, _, _ ), _, Path, Path):- !.

build_path(node(EndState, _ , _ , _, _ ), Nodes, PartialPath, Path):-
    del(Nodes, node(EndState, Action, Parent , _ , _), Nodes1),
    build_path( node(Parent, _, _, _, _), Nodes1,
                        [Action/EndState|PartialPath],Path).

del([X|R],X,R).

del([Y|R],X,[Y|R1]):-
    X\=Y,
    del(R,X,R1).

decr(X,Y):-
    Y is X-1.
incr(X,Y):-
    Y is X+1.

print_nodes([]).
print_nodes([Node|Rest]):-
    print_node(Node), nl,
    print_nodes(Rest).

print_node(node(State, _, _, _, FScore)):-
    print_state(State),
    write("Score: "), write(FScore), nl.

print_state(State):-
    sort1(State, Sorted),
    print_all(Sorted).

print_all([pos(X1, Y1/Z1), pos(X2, Y2/Z2), pos(X3, Y3/Z3),
           pos(X4, Y4/Z4), pos(X5, Y5/Z5), pos(X6, Y6/Z6),
           pos(X7, Y7/Z7), pos(X8, Y8/Z8), pos(X9, Y9/Z9) ]):-
    write(X1), write(" "),
    write(X2), write(" "),
    write(X3), write(" "), nl,
    write(X4), write(" "),
    write(X5), write(" "),
    write(X6), write(" "), nl,
    write(X7), write(" "),
    write(X8), write(" "),
    write(X9), write(" "), nl.

cheaper(>, pos(_, Y1/Z1), pos(_, Y2/Z2)):-
    Z1 < Z2.

cheaper(>, pos(_, Y1/Z), pos(_, Y2/Z)):-
    Y1 > Y2.

cheaper(<, pos(_, Y1/Z1), pos(_, Y2/Z2)):-
    Z1 > Z2.

cheaper(<, pos(_, Y1/Z), pos(_, Y2/Z)):-
    Y1 < Y2.

cheaper(=, pos(_, Y/Z), pos(_, Y/Z)).

sort1(List, Sorted):-
    predsort(cheaper, List, Sorted).
