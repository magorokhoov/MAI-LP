% describing all possible moves
move(Cur, Next) :- append(Head, ['w', '_' | Tail], Cur), append(Head, ['_', 'w' | Tail], Next).
move(Cur, Next) :- append(Head, ['_', 'b' | Tail], Cur), append(Head, ['b', '_' | Tail], Next).
move(Cur, Next) :- append(Head, ['_', 'w', 'b' | Tail], Cur), append(Head, ['b', 'w', '_' | Tail], Next).
move(Cur, Next) :- append(Head, ['w', 'b', '_' | Tail], Cur), append(Head, ['_', 'b', 'w' | Tail], Next).

% prolonging our path to New_Pos
prolong([Cur_Pos | Tail], [New_Pos, Cur_Pos | Tail]) :- move(Cur_Pos, New_Pos), 
                                                    not(member(New_Pos, [Cur_Pos | Tail])).

% Depth First Search
dfs(Start, Finish) :- get_time(Begin), path_dfs([Start], Finish, Path), print_path(Path), get_time(End),
                        Diff is End - Begin, write(Diff), nl.

% found the result
path_dfs([Finish | Tail], Finish, [Finish | Tail]).

% prolonging Cur_Path and continue our search
path_dfs(Cur_Path, Finish, Res_Path) :- prolong(Cur_Path, Next_Path), 
                                        path_dfs(Next_Path, Finish, Res_Path).




% Breadth First Search
bfs(Start, Finish) :- get_time(Begin), path_bfs([[Start]], Finish, Path), print_path(Path), get_time(End),
                        Diff is End - Begin, write(Diff), nl.

% found the result
path_bfs([[Finish | Tail] | _], Finish, [Finish | Tail]).

% prolonging Cur_Path in all possible ways
path_bfs([Cur_Path | Cur_Queue], Finish, Path) :- findall(New_Path, prolong(Cur_Path, New_Path), List),
                                                append(Cur_Queue, List, New_Queue), !,
                                                path_bfs(New_Queue, Finish, Path).

% if Cur_Path can't be prolonged, we should remove it
path_bfs([ _ | Queue], Finish, Path) :- path_bfs(Queue, Finish, Path).




% Search with iterative deepening
iter(Start, Finish) :- get_time(Begin), for(Cur_Depth, 1, 20), iter(Start, Finish, Path, Cur_Depth), 
                        print_path(Path), get_time(End), Diff is End - Begin, write(Diff), nl.

% searching for the path with length = DepthLimit
iter(Start, Finish, Path, DepthLimit) :- path_iter([Start], Finish, Path, DepthLimit).

% found the result at the depth of current DepthLimit
path_iter([Finish | Path], Finish, [Finish | Path], 0).

% prolonging Cur_Path and continue our search
path_iter(Cur_Path, Finish, Path, Depth) :- Depth > 0, prolong(Cur_Path, New_Path),
                                                        New_Depth is Depth - 1,
                                                        path_iter(New_Path, Finish, Path, New_Depth).



for(A, A, _).
for(X, A, B) :- A < B, A1 is A + 1, for(X, A1, B).

% prints instructions to solve the task
print_path([]).
print_path([Head | Tail]) :- print_path(Tail), write(Head), nl.

% dfs(['w', 'w', 'w', '_', 'b', 'b', 'b'], ['b', 'b', 'b', '_', 'w', 'w', 'w']).
% bfs(['w', 'w', 'w', '_', 'b', 'b', 'b'], ['b', 'b', 'b', '_', 'w', 'w', 'w']).
% iter(['w', 'w', 'w', '_', 'b', 'b', 'b'], ['b', 'b', 'b', '_', 'w', 'w', 'w']).