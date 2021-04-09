parents( 'Федор Иванов', 'Алексей Иванов', 'Алла Гуськова' ).
parents( 'Данала Иванов', 'Алексей Иванов', 'Алла Гуськова' ).
parents( 'Галина Иванова', 'Иван Иванов', 'Лидия Кубышкина' ).
parents( 'Алексей Иванов', 'Иван Иванов', 'Лидия Кубышкина' ).
parents( 'Андрей Гуськов', 'Федор Гуськов', 'Александра Грачева' ).
parents( 'Алла Гуськова', 'Федор Гуськов', 'Александра Грачева' ).
parents( 'Лидия Кубышкина', 'Василий Кубышкин', 'Вера Качилина' ).
parents( 'Михаил Качилин', 'Ксенофонт Качилин', 'Акулина ' ).
parents( 'Егор Качилин', 'Ксенофонт Качилин', 'Акулина ' ).
parents( 'Вера Качилина', 'Ксенофонт Качилин', 'Акулина ' ).
parents( 'Иван Иванов', 'Данила Иванов', 'Ирина ' ).
parents( 'Алена Слётина', 'Игорь Слётин', 'Галина Иванова' ).
parents( 'Наталия Козлова', 'Николай Козлов', 'Алена Слётина' ).
parents( 'Александра Грачева', 'Семен Грачев', 'Елена ' ).
parents( 'Елена ', 'Сергей ', 'Орина ' ).
parents( 'Федор Гуськов', 'Иван Гуськов', 'Евдокия ' ).
parents( 'Иван Гуськов', 'Демид Гуськов', 'Катерина ' ).
parents( 'Евдокия ', 'Василий ', 'Полина ' ).
parents( 'Семен Грачев', 'Иван Грачев', 'Наталья ' ).
parents( 'Ксения Гуськова', 'Андрей Гуськов', 'Стефа ' ).
parents( 'Николай Гуськов', 'Андрей Гуськов', 'Стефа ' ).
parents( 'Агата Гуськова', 'Николай Гуськов', 'Ольга ' ).
parents( 'Влад Гуськов', 'Николай Гуськов', 'Ольга ' ).
parents( 'Лада Гуськов', 'Александр Гуськов', 'Ксения Гуськова' ).
parents( 'Сергей Гуськов', 'Александр Гуськов', 'Ксения Гуськова' ).

male( 'Федор Иванов' ).
male( 'Алексей Иванов' ).
female( 'Алла Гуськова' ).
male( 'Данала Иванов' ).
male( 'Иван Иванов' ).
female( 'Лидия Кубышкина' ).
male( 'Федор Гуськов' ).
female( 'Александра Грачева' ).
female( 'Галина Иванова' ).
male( 'Андрей Гуськов' ).
male( 'Василий Кубышкин' ).
female( 'Вера Качилина' ).
male( 'Ксенофонт Качилин' ).
female( 'Акулина ' ).
male( 'Егор Качилин' ).
male( 'Михаил Качилин' ).
male( 'Данила Иванов' ).
female( 'Ирина ' ).
male( 'Игорь Слётин' ).
female( 'Алена Слётина' ).
male( 'Николай Козлов' ).
female( 'Наталия Козлова' ).
male( 'Семен Грачев' ).
female( 'Елена ' ).
male( 'Сергей ' ).
female( 'Орина ' ).
male( 'Иван Гуськов' ).
female( 'Евдокия ' ).
male( 'Демид Гуськов' ).
female( 'Катерина ' ).
male( 'Василий ' ).
female( 'Полина ' ).
male( 'Иван Грачев' ).
female( 'Наталья ' ).
female( 'Стефа ' ).
male( 'Николай Гуськов' ).
female( 'Ксения Гуськова' ).
female( 'Ольга ' ).
male( 'Александр Гуськов' ).
male( 'Сергей Гуськов' ).
female( 'Лада Гуськов' ).
male( 'Влад Гуськов' ).
female( 'Агата Гуськова' ).



zolovka(Z, W) :- parents(_, _, Z), parents(_, H, W),
                 parents(H, F, M), parents(Z, F, M).

zolovka2(Z, W) :-  sister(Z, H), parents(_, H, W).

sister(X, Y) :- male(Y), female(X),parents(X, F, M), parents(Y, F, M).


sibling(X, Y) :- parents(X, F, M),
                parents(Y, F, M), 
                X \= Y.
cousin(X, Y) :- parents(X, A, B), parents(Y, C, D), (sibling(A, C);
                sibling(A, D); sibling(B, C); sibling(B, D)),
                X\=Y.

% все возможные предикаты которые я смог составить из моих первоначальных фактов
relative(child, A, B) :- parents(A, _, B); parents(A, B, _).    
relative(father, A, B) :- parents(B, A, _).
relative(mother, A, B) :- parents(B, _, A).
relative(husband, A, B) :- parents(_, A, B), !.
relative(wife, A, B) :- parents(_, A, B), !.
relative(sibling, A, B) :- sibling(A, B).
relative(cousin, A, B) :- cousin(A, B).
relative(zolovka, A, B) :- zolovka2(A, B), !.
relative(grandfather, A, B) :- parents(_, A, _), 
                                (parents(B, F, _), parents(F, A, _)); 
                                (parents(B, _, M), parents(M, A, _)).
relative(grandmother, A, B) :- parents(_, _, A), 
                                (parents(B, F, _), parents(F, _, A)); 
                                (parents(B, _, M), parents(M, _, A)).

    
% поиск в ширину 	
prolong([X|T],[Y,X|T]):-
	relative(_,X,Y),
	not(member(Y,[X|T])).

% кусок кода из лекции, отлично подошел 	
bdth([[H|T]|_],H,[H|T]).
bdth([Curr|QI],H,Way):-
	findall(W,prolong(Curr,W),Ways),
	append(QI,Ways,QO), !,
	bdth(QO,H,Way).

% добавление в список	
add([_], Obj, Obj). 
add([X,Y|T], Obj, Relation) :-
    relative(Relate, X, Y),
    add([Y|T], [Relate|Obj], Relation). 

% основная функ. для поиска всех возможных путей в моем дереве
related(Relation, X, Y) :-
    bdth([[X]], Y, R),
	reverse(R, Chain),
	add(Chain, [], Relation1),
	reverse(Relation1, Relation).

% простой пример возможного вопроса
question('Who is', X, 'to', Y,'?', ANSW) :-
    relative(ANSW, X, Y), !.


% списки родственников и глагола to be
relations(X):- member(X, [child, father, mother, sibling, husband, wife, cousin, zolovka, grandfather, grandmother]).
verb_to_be(X):- member(X, [is,are]).

% проверка корректности построения вопросов, в зависимости от типа
check_pred_how(QUESTION) :- 
    QUESTION = [how,many|_], 
    last(QUESTION,?), 
    without_last(QUESTION,SENTENCE1),
    last(SENTENCE1,have),
    find_person(QUESTION,Name),
    my_remove(Name,QUESTION,SENTENCE2),
    not(find_person(SENTENCE2,_)),
    find_relation(QUESTION,Rel),
    my_remove(Rel,QUESTION,SENTENCE3),
    not(find_relation(SENTENCE3,_)).

check_pred_who(QUESTION) :- 
    QUESTION = [who|Tail], 
    Tail = [ToBe|_], 
    verb_to_be(ToBe), 
    last(QUESTION,?),
    find_person(QUESTION,Name),
    my_remove(Name,QUESTION,SENTENCE2),
    not(find_person(SENTENCE2,_)),
    find_relation(QUESTION,Rel),
    my_remove(Rel,QUESTION,SENTENCE3),
    not(find_relation(SENTENCE3,_)).

check_pred_is(QUESTION) :-
    QUESTION = [ToBe|_], 
    verb_to_be(ToBe),
    find_person(QUESTION,Name),
    my_remove(Name,QUESTION,SENTENCE2),
    find_person(SENTENCE2,Name1),
    not(Name==Name1),
    find_relation(QUESTION,Rel),
    my_remove(Rel,QUESTION,SENTENCE3),
    not(find_relation(SENTENCE3,_)).

    

% вопрос
q(QUESTION) :- 
% how many Relation Name have ?
    (check_pred_how(QUESTION), find_person(QUESTION,Name),find_relation(QUESTION,Rel),
        findall(Res,relative(Rel, Res, Name),L), length(L,X),
    	write(Name),write(" has "),write(X),write(" "),write(Rel),write("s");
% who is Name Relation ?     
    check_pred_who(QUESTION), find_person(QUESTION,Name),find_relation(QUESTION,Rel),
        relative(Rel, Res, Name), write(Res), write(" is "), write(Name), write("'s "), write(Rel);
% is Name1 Name2 Relation ?    
   check_pred_is(QUESTION), find_relation(QUESTION,Rel),find_person(QUESTION,Name1),my_remove(Name1,QUESTION,SENTENCE1),find_person(SENTENCE1,Name2),
        (relative(Rel, Name1, Name2) -> write("Yes. "),write(Name1),write(" is "),write(Name2),write(" "),write(Rel);
      	not(relative(Rel, Name1, Name2)) -> write("No. "),write(Name1),write(" is not "),write(Name2),write(" "),write(Rel))).
   


% вспомогательные предикаты
find_name(X) :- parents(X,_,_),!;parents(_,X,_),!;parents(_,_,X).

find_person([],[]) :- fail.
find_person([Head|Tail],Name):-
    find_name(Head), Name = Head,!;
    find_person(Tail,Name).


find_relation([],[]) :- fail.
find_relation([Head|Tail],Rel):-
    relations(Head), Rel = Head,!;
    find_relation(Tail,Rel).
    
my_remove(X, [X|Tail], Tail).
my_remove(X, [Y|Tail], [Y|Z]):-my_remove(X, Tail, Z).

last([X], X):-!.
last([_|Tail], Element):- last(Tail, Element).

without_last([_], []).
without_last([X|Xs], [X|WithoutLast]) :- 
    without_last(Xs, WithoutLast).
