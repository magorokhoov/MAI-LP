# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Иванов Ф.А.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |     зач       |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*

## Введение

Помимо привычного всем императивного программирования существует еще много непохожих друг на друга парадигм: логическое программирование, функциональное программирование и др. Для каждой парадигмы были придуманы особые языки и правила для программирования. В рамках этого курсового проекта я познакомлюсь с парадигмой логического программирования: изучу механизмы и принципы работы первого декларативного языка Prolog, изучу основы построения фактов, предикатов и запросов в данном языке программирования и на примере приведенного ниже задания продемонстрирую изученные навыки программирования на декларативном языке.

## Задание

 1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM с использованием сервиса MyHeritage.com 
 2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog, используя следующее представление: ```parents(потомок, отец, мать)```.
 3. Реализовать предикат проверки/поиска золовка.
 4. Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве
 5. Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы. 

## Получение родословного дерева

Для получения родословного дерева я использовал сайт myheritage.ru, который преобразует информацию из интуитивно-понятной визуальной формы в формат GEDCOM. В моем дереве получилось 43 индивидума. У некоторых людей утеряна фамилия, поэтому этот человек обозначен только именем.

## Конвертация родословного дерева

Для конвертации .ged файла в факты языка Prolog я воспользовался языком Python. Я выбрал этот язык из-за его возможности быстро и просто работать с файлами и строками. По заданию мне нужно было выделить человека и задать отношение ребенок <-> отец <-> мать. 

Для начала, я составлял список из всех людей. Поряд в списке был такой: id-номер, Имя Фамилия, пол(это не обязательно, я использовал для проверки одного предиката).
```python
myTree = open('my_tree.ged', 'r')

for line in myTree:
    if line[2:4] == "@I":
        listMyFamilyPerson.append(int(line[5:10]))
    if line[0:6] == "1 NAME":
        listMyFamilyPerson.append(line[7:-1])
    if line[0:5] == "1 SEX":
        listMyFamilyPerson.append(line[6:-1])

myTree.close()
```

Далее этот список я преобразовал в словарь для более удобной работы.
```python
for line in range(0, len(listMyFamilyPerson), 3):
    dictionaryMyFamilyPerson[listMyFamilyPerson[line]] = listMyFamilyPerson[line+1]
print(dictionaryMyFamilyPerson)
```

Затем самая важная часть: нужно было выделить информацию по каждому родственнику о наличии ребенка, является ли человек отцом или матерью.
```python
myTree = open('my_tree.ged', 'r')
i = -1
for line in myTree:
    if line[2:4] == "@F":
        i += 1
    if line[0:6] == "1 HUSB":
        listAllFamily[i][0] = int(line[10:15])
    if line[0:6] == "1 WIFE":
        listAllFamily[i][1] = int(line[10:15])
    if line[0:6] == "1 CHIL":
        listAllFamily[i].append(int(line[10:15]))

myTree.close()

```
После этого создал матрицу отношений и на основе ее записал все факты в отдельный файл. После этого все факты были скопированны в рабочий файл проекта.

## Предикат поиска родственника

Золовка - это родная сестра мужа. Чтобы задать такой предикат, используя факты parents(ребенок, отец, мать), то нужно указать в первую очередь это женщина, в данном случае это можно подчеркнуть, только если объект является матерью. Также нужно показать, что объект является ребенком родителей мужа.

Соответственно, предикат будет выглядеть следующим образом:
```prolog
zolovka(Z, W) :- parents(_, _, Z), parents(_, H, W),
                 parents(H, F, M), parents(Z, F, M).
```
Но такой предикат выведет не все возможные исходы, т.к. сестра мужа может не иметь детей и не быть женатой. Для более полного получения информации, я выделил из дерева пол человека и описал отношение сестры:
```prolog
sister(X, Y) :- male(Y), female(X),parents(X, F, M), parents(Y, F, M).
```

Соответственно, отношение золовка можно задать, используя предикат сестра, следующим образом:
```prolog
zolovka2(Z, W) :-  sister(Z, H), parents(_, H, W).
```
Работа предикатов (выводы дублируются):
```prolog
?- zolovka(X, Y).
X = 'Алла Гуськова',
Y = 'Стефа ' ;
X = 'Алла Гуськова',
Y = 'Стефа ' ;;
X = 'Галина Иванова',
Y = 'Алла Гуськова' ;
X = 'Галина Иванова',
Y = 'Алла Гуськова' ;
X = 'Ксения Гуськова',
Y = 'Ольга ' ;
X = 'Ксения Гуськова',
Y = 'Ольга ' ;
false.

?- zolovka2(X, Y).
X = 'Галина Иванова',
Y = 'Алла Гуськова' ;
X = 'Галина Иванова',
Y = 'Алла Гуськова' ;
X = 'Алла Гуськова',
Y = 'Стефа ' ;
X = 'Алла Гуськова',
Y = 'Стефа ' ;
X = 'Ксения Гуськова',
Y = 'Ольга ' ;
X = 'Ксения Гуськова',
Y = 'Ольга ' ;
false.

?- zolovka2('Алла Гуськова', Y). 
Y = 'Стефа ' ;
false.
```


## Определение степени родства

Для начала я описал все предикаты (которые смог выделить из своих фактов), задающие отношения между людьми. Это: ребенок, отец, мать, брат/сестра, двоюродный брат/сестра, жена, муж, золовка, дед, бабушка. Из этих предикатов можно получить само название отношения между двумя людьми.
```prolog
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
```
Эти предикаты будут выступать в роли вершин графа, по которому будет выполнятся поиск. 
Я решил использовать алгоритм поиска в ширину, как неоднократно говорилось на лекции: именно этот алгоритм выводит самый короткий путь, а только после этого ищет более длинные пути. Алгоритм очень хорошо описан в лекции №8 и продублирован в 3 лабораторной работе.

Продвижение по графу:
```prolog
prolong([X|T],[Y,X|T]):-
	relative(_,X,Y),
	not(member(Y,[X|T])).
```

Алгоритм поиска в ширину:
```prolog
bdth([[H|T]|_],H,[H|T]).
bdth([Curr|QI],H,Way):-
	findall(W,prolong(Curr,W),Ways),
	append(QI,Ways,QO), !,
	bdth(QO,H,Way).
```
Добавление. 

Предикат получает на вход список имен, между двумя первыми ищет отношение и записывает в итоговый список, затем удаляет первый элемент. 
```prolog
add([_], Obj, Obj). 
add([X,Y|T], Obj, Relation) :-
    relative(Relate, X, Y),
    add([Y|T], [Relate|Obj], Relation). 
```
Основной предикат поиска всех возможных комбинаций отношений:
```prolog
related(Relation, X, Y) :-
    bdth([[X]], Y, R),
	reverse(R, Chain),
	add(Chain, [], Relation1),
	reverse(Relation1, Relation).
```

Пример работы:
```prolog
?- related(Relation, 'Федор Иванов', 'Алексей Иванов').
Relation = [child] ; % ребенок
Relation = [sibling, child] ; % брат ребенка
Relation = [child, mother, child] ; % ребенок матери ребенка
Relation = [cousin, child, sibling] ; % двоюродный брат ребенка брата
Relation = [cousin, cousin, child] ;
Relation = [cousin, cousin, child] ;
Relation = [child, child, grandmother, child] ;
Relation = [sibling, cousin, child, sibling] ;
Relation = [cousin, child, child, mother] ;
Relation = [cousin, child, child, father] ;
Relation = [cousin, child, husband, sibling] ;
Relation = [child, child, grandmother, cousin, child] ;
Relation = [child, child, grandmother, cousin, child] ;
Relation = [child, child, grandmother, cousin, child] ;
Relation = [child, child, grandmother, cousin, child] ;
Relation = [child, child, husband, grandmother, child] ;
Relation = [child, mother, cousin, child, sibling] ;
Relation = [child, sibling, child, grandmother, child] ;
Relation = [child, sibling, father, cousin, child] ;
Relation = [child, zolovka, mother, cousin, child] ;
Relation = [sibling, cousin, child, child, mother] ;
Relation = [sibling, cousin, child, child, father] ;
Relation = [sibling, cousin, child, husband, sibling] ;
Relation = [cousin, child, child, child, grandmother] ;
Relation = [cousin, child, child, grandmother, child] ;
Relation = [cousin, child, child, grandmother, child] ;
Relation = [cousin, child, child, grandmother, child] ;
Relation = [cousin, child, child, grandmother, child] ;
Relation = [cousin, child, child, child, grandmother] ;
Relation = [cousin, child, child, husband, mother] ;
Relation = [cousin, child, zolovka, mother, child] ;
Relation = [cousin, child, husband, child, mother] ;
Relation = [cousin, child, husband, child, father] ;
Relation = [cousin, child, child, grandmother, child] ;
Relation = [cousin, cousin, cousin, child, sibling] ;
Relation = [cousin, child, mother, cousin, child] ;
Relation = [cousin, child, child, grandmother, child] ;
Relation = [cousin, child, father, cousin, child] ;
Relation = [child, child, mother, father, cousin, child] ;
Relation = [child, child, grandmother, cousin, child, sibling] ;
......

?- related(Relation, 'Николай Гуськов', 'Алексей Иванов').
Relation = [child, mother, cousin, child] ;
Relation = [child, mother, cousin, child] ;
Relation = [child, father, cousin, child] ;
Relation = [child, father, cousin, child] ;
Relation = [child, mother, cousin, sibling, child] ;
Relation = [child, mother, cousin, sibling, child] ;
Relation = [child, child, mother, mother, child] ;
Relation = [child, child, mother, mother, child] ;
Relation = [child, child, father, mother, child] ;
Relation = [child, child, father, mother, child] ;
Relation = [child, father, cousin, sibling, child] ;
Relation = [child, father, cousin, sibling, child] ;
Relation = [child, husband, mother, cousin, child] ;
Relation = [child, husband, mother, cousin, child] ;
Relation = [father, cousin, child, cousin, child] ;
Relation = [father, cousin, child, cousin, child] ;
Relation = [father, cousin, child, cousin, child] ;
Relation = [father, cousin, child, cousin, child] ;
Relation = [father, cousin, child, cousin, child] ;
Relation = [father, cousin, child, cousin, child] ;
Relation = [father, cousin, child, cousin, child] ;
Relation = [father, cousin, child, cousin, child] ;
Relation = [child, mother, cousin, child, mother, child] ;
Relation = [child, mother, cousin, cousin, child, sibling] ;
Relation = [child, mother, cousin, cousin, cousin, child] ;
Relation = [child, mother, cousin, child, mother, child] ;
Relation = [child, mother, cousin, cousin, child, sibling] ;
Relation = [child, mother, cousin, cousin, cousin, child] ;
Relation = [child, child, mother, mother, sibling, child] ;
Relation = [child, child, mother, mother, sibling, child] ;
Relation = [child, child, father, mother, sibling, child] ;
Relation = [child, child, father, mother, sibling, child] ;
Relation = [child, child, husband, mother, mother, child] ;
Relation = [child, child, husband, mother, mother, child] ;
Relation = [child, father, cousin, child, mother, child] ;
.....

```

## Естественно-языковый интерфейс
Изначально у меня было несколько вариантов реализации естественно-языкового интерфейса. 
Самый первый вариант я решил оставить, как пример его неэффективности. Почему я говорю об неэффективности его использования? Дело в том, что малейшее изменение порядка (неважных слов) приведет к ошибке. Второе - это то, что реализация такого предиката требует простой, обычной структуры.

Вот этот предикат и результат его работы:
```prolog
question('Who is', X, 'to', Y,'?', ANSW) :-
    relative(ANSW, X, Y), !.
    
?- question('Who is', 'Алексей Иванов', 'to', 'Федор Иванов', '?', Answer).
Answer = father.
```

А как же реализовать сложный предикат?
Для этого мне потредуется 2 словарика:
```prolog
relations(X):- member(X, [child, father, mother, sibling, husband, wife, cousin, zolovka, grandfather, grandmother]).
verb_to_be(X):- member(X, [is,are]).
```
Первый из них обозначает отношения, а второй формы глагола to be.

Всего используем 3 типа вопроса:

---> how many 'Relation' 'Name' have? - сколько заданных родственников у данного человека


---> who is 'Name' 'Relation'? - кто является заданным родственником заданного человека


---> is 'Name1' 'Name2' 'Relation'? - является ли кто-то заданным родственником заданного человека


Для того чтобы понять, какой вопрос задан, делаем 3 предиката проверки корректности заданного вопроса, а точнее проверки ключевых моментов заданного вопроса. Первый предикат я распишу подробно, остальные - по-анологии:

```prolog
check_pred_how(QUESTION) :- 
    QUESTION = [how,many|_], % проверка начала вопроса и соответственно типа
    last(QUESTION,?), % проверка наличия знака вопроса
    without_last(QUESTION,SENTENCE1), % получение предложения без знака вопроса
    last(SENTENCE1,have), % проверка того, что последний символ в полученном предложении - have
    find_person(QUESTION,Name), % осуществление поиска имени человека в полученном предложении
    my_remove(Name,QUESTION,SENTENCE2), % удаление этого имени
    not(find_person(SENTENCE2,_)), % проверка того, что второго человека не найдено
    find_relation(QUESTION,Rel), % поиск отношения в предложении
    my_remove(Rel,QUESTION,SENTENCE3), % удаление слова отношения из предложения
    not(find_relation(SENTENCE3,_)). % проверка, что больше слов-отношений не найдено

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
```
Соответственно, главный предикат определения вопроса и поиска ответа на него:
```prolog
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
```
Принцип работы предиката заключается в следующем:
1. на вход подается вопрос
2. выполняется проверка типа вопроса
3. в зависимости от типа заданного вопроса ищуюся разные параметры: имя(имена) и слово обозначающее отношение
4. в зависимости от типа заданного вопроса используются разные способы(предикаты) для получения конечного результата
5. Результат записывается в форме диалогового ответа.

Пример использования:

```prolog
?- q([how,many,child,'Алексей Иванов',have,?]).
Алексей Иванов has 2 childs
true;
false.

?- q([how,many,wife,'Данила Иванов',have,?]).
Алексей Иванов has 0 wifes
true ;
false.

?- q([how,many,cousin,'Алексей Иванов',have,?]).
Алексей Иванов has 0 cousins
true ;
false.

?- q([how,many,cousin,'Федор Иванов',have,?]).
Федор Иванов has 3 cousins
true ;
false.


?- q([who,are,'Федор Иванов',cousin,?]).
Алена Слётина is Федор Иванов's cousin
true 
Unknown action: ж (h for help)
Action? ;
Ксения Гуськова is Федор Иванов's cousin
true ;
Николай Гуськов is Федор Иванов's cousin
true ;
false.

?- q([who,are,'Алексей Иванов',mother,?]).
Лидия Кубышкина is Алексей Иванов's mother
true ;
false.

?- q([who,are,'Ксения Гуськова',father,?]).
Андрей Гуськов is Ксения Гуськова's father
true ;
false.

?- q([who,are,'Ксения Гуськова',sibling,?]).
Николай Гуськов is Ксения Гуськова's sibling
true ;
false.

?- q([who,are,'Федор Иванов',sibling,?]).
Данала Иванов is Федор Иванов's sibling
true;
false.


?- q([is,'Алла Гуськова','Андрей Гуськов',sibling,?]).
Yes. Алла Гуськова is Андрей Гуськов sibling
true ;
false.

?- q([is,'Галина Иванова','Алла Гуськова',zolovka,?]).
Yes. Галина Иванова is Алла Гуськова zolovka
true;
false.
```

Для реализации главного и проверочных предикатов я использовал несколько важных предикатов.

Предикат существования имени:
```prolog
find_name(X) :- parents(X,_,_),!;parents(_,X,_),!;parents(_,_,X).

```
Предикат нахождения слова(имени) в списке слов:
```prolog
find_person([],[]) :- fail.
find_person([Head|Tail],Name):-
    find_name(Head), Name = Head,!;
    find_person(Tail,Name).
```
Предикат нахождения слова-отношения в списке слов:
```prolog
find_relation([],[]) :- fail.
find_relation([Head|Tail],Rel):-
    relations(Head), Rel = Head,!;
    find_relation(Tail,Rel).
```
Предикат удаления элемента из списка (отсылка к первой лабораторной работе):
```prolog
my_remove(X, [X|Tail], Tail).
my_remove(X, [Y|Tail], [Y|Z]):-my_remove(X, Tail, Z).
```

Поиск последнего элемента в списке:
```prolog
last([X], X):-!.
last([_|Tail], Element):- last(Tail, Element).
```

Получение списка без последнего элемента:
```prolog
without_last([_], []).
without_last([X|Xs], [X|WithoutLast]) :- 
    without_last(Xs, WithoutLast).
```

## Выводы

Прежде всего хочу отметить, что на этапе создания генеалогическое древа, я узнал о многих своих родствеников, о которых раньше ничего не слышал! Мне стыдно за то, что я так мало знаю о своей семье. У некоторых людей из моей семьи я не сог найти даже фамилии. Это печально. Но я задался целью, собратьмаксимально подробное генеалогическое древо.

В процессе написания курсового проекта, я изучил принцип работы языка Пролог, познал суть логического программирования и научился писать работающие программы с использованием данной парадигмы. Свое изучение пролога я начал с азов: писал неуверенных код, почти 80% приходилось переписывать по нескольку раз, из за того, что я не понимал логику работы предикатов, а уже ближе к концу я стал писать уверенный код, использовал более сложные и полезные алгоритмы: алгоритм поиска и алгоритм обработки естественно-языковых предложений.

Для себя я отметил, что Пролог - очень интересный язык программирования.  В осовном он используется для проектирования каких-либо заготовок, для обработки простейших естественно-языковых запросов и для поиска в пространстве некоторых состояний. Всё это было проделано и мной в рамках данной работы. Но я уверен, что применение Пролога в моей жизни не закончится с последней точкой этого проекта. На одной из лекций Дмитрий Валерьевич Сошников рассказывал, как с помощью Пролога за сутки удалось написать сложный проект,а чтобы его переписать на императивный язык программирования потребовалось намного больше времени. Я думаю, что Порлог я буду использовать в жизни для решения сложных задач, от которых требуется получить только ответ.
