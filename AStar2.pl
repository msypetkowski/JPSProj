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

    write("Conflict on state: "), write(State),
    write(" new cost: "), write(Cost),
    write(" old cost: "), write(Cost1), nl,

    Cost < Cost1,
    replace_node(node(State, Action, Parent, Cost, Score), ClosedSet, NewClosedSet),
    Diff is Cost1 - Cost,
    write("Diff: "), write(Diff), nl,

    % update Cost and Score of nodes in Queue
    write("Open nodes before update: "), write(QueueRest), nl,
    update_nodes_p_queue(State, Diff, ClosedSet, QueueRest, [], NewQueueRest),
    write("Open nodes after  update: "), write(NewQueueRest), nl,

    % update Cost and Score of nodes in ClosedSet
    write("Closed nodes before update: "), write(NewClosedSet), nl,
    update_nodes(State, Diff, ClosedSet, NewClosedSet, NewClosedSetUpdated),
    write("Closed nodes after  update: "), write(NewClosedSetUpdated), nl,
    fetch(Node, NewQueueRest, NewClosedSetUpdated,
                FinalQueueRest, FinalClosedSet),
    !.

fetch(Node, [_|RestQueue], ClosedSet, NewRest, NewClosedSet):-
    fetch(Node, RestQueue, ClosedSet , NewRest, NewClosedSet).

% insert Node into Set replacing other node with same State
% bond result to NewSet
replace_node(node(State,Action,Parent,Cost,Score),
            [node(State,_,_,_,_)|Set],
            [node(State,Action,Parent,Cost,Score)|Set]):-
    !.

replace_node(Node, [N|Set], [N|NewSet]):-
    replace_node(Node, Set, NewSet).

% decrease Cost and Score of all Nodes in given Queue,
% that are ancestors of Node with State=RootState.
% bond result to NewQueue (it is priority queue)
update_nodes(_,_,_,[],[]).

update_nodes(RootState, Diff, ClosedSet, [Node|Set], [UpdatedNode|NewSet]):-
    update_node(RootState, Diff, ClosedSet, Node, UpdatedNode),
    update_nodes(RootState, Diff, ClosedSet, Set, NewSet).


% decrease Cost and Score of all Nodes in given priority Queue,
% that are ancestors of Node with State=RootState.
% bond result to NewQueue (it is priority queue)
update_nodes_p_queue(_,_,_,[],Result, Result).

update_nodes_p_queue(RootState, Diff, ClosedSet, [Node|QueueRest], PartialResult, Result):-
    update_node(RootState, Diff, ClosedSet, Node, UpdatedNode),
    insert_p_queue(UpdatedNode, PartialResult, PartialResult1),
    update_nodes_p_queue(RootState, Diff, ClosedSet, QueueRest, PartialResult1, Result).

update_node(RootState, Diff, ClosedSet,
        node(State,Action,Parent,Cost,   Score   ),
        node(State,Action,Parent,NewCost,NewScore)):-
    is_ancestor(node(State,Action,Parent,Cost,Score), RootState, ClosedSet),
    NewCost is Cost - Diff,
    NewScore is Score - Diff, !.

% don't update
update_node(_, _, _, Node, Node).

is_ancestor(node(_,_,RootState,_,_), RootState, _):- !.
is_ancestor(node(_,_,Parent,_,_), RootState, ClosedSet):-
    member(node(Parent, Ac, Pa, Co, Sc), ClosedSet),
    is_ancestor(node(Parent, Ac, Pa, Co, Sc), RootState, ClosedSet).


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
