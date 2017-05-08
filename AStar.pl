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

    write("Current step is "), write(N), write("; Fetched: "), write(Node), nl,

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

% get node
fetch(node(State, Action,Parent, Cost, Score),
            [node(State, Action,Parent, Cost, Score) |RestQueue], ClosedSet,
            RestQueue, K) :-
    K>(0),
    \+ member(node(State, _, _, _, _), ClosedSet).

% wrong node (skip, and remove from Queue)
fetch(node(State, Action,Parent, Cost, Score),
            [node(State, Action,Parent, Cost, Score) |Queue], ClosedSet,
            RestQueue, K) :-
    K>(0),
    member(node(State, _, _, _, _), ClosedSet),
    fetch(node(State, Action,Parent, Cost, Score), Queue, ClosedSet , RestQueue, K).

% skip node (but keep in Queue)
fetch(Node,
            [node(State, Action,Parent, Cost, Score)|Queue], ClosedSet,
            [node(State, Action,Parent, Cost, Score)|RestQueue], K) :-
    K>(0),
    \+ member(node(State, _, _, _, _), ClosedSet),
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
