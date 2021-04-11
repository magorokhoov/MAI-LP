mlr([X|L], [Y|R], L, [X, Y|R]) :- not(X = Y).
mlr([X|L], [], L, [X]).

mtr([X|T], [Y|R], T, [X, Y|R]) :- not(X = Y).
mtr([X|T], [], T, [X]).

mlt([X|L], [Y|T], L, [X, Y|T]).
mlt([X|L], [], L, [X]).

move([L, T, R], [LN, TN, RN]) :- 
    T = TN, mlr(L, R, LN, RN);
    L = LN, mtr(T, R, TN, RN);
    R = RN, mlt(L, T, LN, TN).

prolong([X|T], [Y, X|T]) :- 
    move(X, Y).

algor([w], [w], []).
algor([b], [], [b]).
algor([w|T], [w|W], B) :-
    algor(T, W, B).
algor([b|T], W, [b|B]) :-
    algor(T, W, B).

bnw([], [], []).
bnw([X|TX], [Y|TY], [X, Y|T]) :- 
    bnw(TX, TY, T).

goal([X|T], R) :- 
    algor([X|T], W, B),
   ((X = w, bnw(B, W, R)); 
    (X = b, bnw(W, B, R))).

extra([H | T], R) :- 
    H = R;
    extra(T, R).



dpath(X, R) :-
    goal(X, G),
    dpath1([[X, [], []]], [[], [], G], R1),
    reverse(R1, R).

dpath1([H | T], H, [H | T]).
dpath1(P, G, R) :-
    prolong(P, P1),
    dpath1(P1, G, R).

dcpath(X, R) :-
    goal(X, G),
    length(G, C1),
    C is (3 * C1 / 2) - 1,
    dcpath1([[X, [], []]], [[], [], G], R1, C), !,
    reverse(R1, R2),
    extra(R2, R).

dcpath1([H | T], H, [H | T], _).
dcpath1(P, G, R, C) :-
    C > 0,
    prolong(P, P1), 
    C1 is C - 1,
    dcpath1(P1, G, R, C1).

int(0).
int(X) :- int(X1), X is X1 + 1.

dipath(X, R) :- 
    goal(X, G),
    int(CC),
    dcpath1([[X, [], []]], [[], [], G], R1, CC), !,
    reverse(R1, R2), 
    extra(R2, R).

wpath(S, R) :-
   goal(S, G),
   wpath1([[[S, [], []]]], [[], [], G], R1),
   !,
   reverse(R1, R2),
   extra(R2, R).

mfindall(P, R) :-
   findall(S, prolong(P, S), R);
   not(findall(S, prolong(P, S), R)), R = [].

wpath1([[H | T] | _], H, [H | T]).
wpath1([H | Qin], G, R) :-
   mfindall(H, L),
   append(Qin, L, Qout),
   wpath1(Qout, G, R).
