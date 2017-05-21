start_A_star( InitState, PathCost):-
    score(InitState, 0, 0, InitCost, InitScore),
    search_A_star( [node(InitState, nil, nil, InitCost , InitScore ) ], [ ], PathCost) .

search_A_star(Queue, ClosedSet, PathCost):-
    fetch(Node, Queue, ClosedSet , RestQueue, NewClosedSet),
    write("Fetched: "), write(Node), nl,
    continue(Node, RestQueue, NewClosedSet, PathCost).


continue(node(State, Action, Parent, Cost, _) , _  ,  ClosedSet, path_cost(Path, Cost)):-
    goal(State), !,
    build_path(node(Parent, _ ,_ , _ , _ ), ClosedSet, [Action/State], Path) .

continue(Node, RestQueue, ClosedSet, Path):-
    expand( Node, NewNodes),
    insert_new_nodes(NewNodes, RestQueue, NewQueue),
    search_A_star(NewQueue, [Node | ClosedSet ], Path).


fetch(node(State, Action,Parent, Cost, Score),
            [node(State, Action,Parent, Cost, Score) |RestQueue], ClosedSet,
            RestQueue, ClosedSet) :-
    \+ member(node(State, _, _, _, _), ClosedSet), !.

fetch(Node,
            [node(State, Action,Parent, Cost, Score) |QueueRest], ClosedSet,
            FinalQueueRest, FinalClosedSet) :-
    member(node(State, _, _, Cost1, _), ClosedSet),
    write("Conflict on state: "), write(State), write(" new: "), write(Cost), write(" old: "), write(Cost1), nl,
    Cost < Cost1,
    replace_node(node(State, Action, Parent, Cost, Score), ClosedSet, NewClosedSet),
    Diff is Cost1 - Cost,
    write("Diff: "), write(Diff), nl,
    update_nodes(State, Diff, QueueRest, NewQueueRest),
    fetch(Node, NewQueueRest, NewClosedSet,
                FinalQueueRest, FinalClosedSet),
    !.

fetch(Node, [_|RestQueue], ClosedSet, NewRest, NewClosedSet):-
    fetch(Node, RestQueue, ClosedSet , NewRest, NewClosedSet).

% TODO:

% insert Node into Set replacing other node with same State
% bond result to NewSet
replace_node(Node, Set, NewSet):-
    write('not implemented'), nl, fail.

% decrease Cost and Score of all Nodes in Queue,
% that are ancestors of Node with State=RootState.
% bond result to NewQueue (it is priority queue)
update_nodes(RootState, Diff, Queue, NewQueue):-
    write('not implemented'), nl, fail.


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
