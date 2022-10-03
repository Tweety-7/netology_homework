--=============== МОДУЛЬ 4. УГЛУБЛЕНИЕ В SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--База данных: если подключение к облачной базе, то создаёте новую схему с префиксом в --виде фамилии, название должно быть на латинице в нижнем регистре и таблицы создаете --в этой новой схеме, если подключение к локальному серверу, то создаёте новую схему и --в ней создаёте таблицы.

--Спроектируйте базу данных, содержащую три справочника:
--· язык (английский, французский и т. п.);
--· народность (славяне, англосаксы и т. п.);
--· страны (Россия, Германия и т. п.).



--Две таблицы со связями: язык-народность и народность-страна, отношения многие ко многим. Пример таблицы со связями — film_actor.
--Требования к таблицам-справочникам:
--· наличие ограничений первичных ключей.
--· идентификатору сущности должен присваиваться автоинкрементом;
--· наименования сущностей не должны содержать null-значения, не должны допускаться --дубликаты в названиях сущностей.
--Требования к таблицам со связями:
--· наличие ограничений первичных и внешних ключей.

--В качестве ответа на задание пришлите запросы создания таблиц и запросы по --добавлению в каждую таблицу по 5 строк с данными.
 
--СОЗДАНИЕ ТАБЛИЦЫ ЯЗЫКИ

create table language (lang_id serial primary key,
 lang varchar(50) unique not null);

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ ЯЗЫКИ

insert into "language" (lang)
values
('English'),
('Russian'),
('Italian'),
('German'),
('Ukrainian');

--СОЗДАНИЕ ТАБЛИЦЫ НАРОДНОСТИ

create table nationality(nati_id serial primary key,
nationality varchar(50) unique not null)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ НАРОДНОСТИ


insert into  nationality(nationality)
values
('Slavs'),
('Anglo-Saxons'),
('italiani'),
('Deutsche'),
('українці');

--СОЗДАНИЕ ТАБЛИЦЫ СТРАНЫ

create table country(country_id serial primary key,
country varchar(50) unique not null)

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СТРАНЫ

insert into  country(country)
values
('England'),
('Russia'),
('Italy'),
('Germany'),
('Ukraine');

--СОЗДАНИЕ ПЕРВОЙ ТАБЛИЦЫ СО СВЯЗЯМИ
--наличие ограничений первичных и внешних ключей.
--язык-народность и отношения многие ко многим. Пример таблицы со связями — film_actor.
create table language_nationality(language_id integer not null,
nationality_id integer not null,
foreign key (language_id) references language(lang_id),foreign key (nationality_id) references nationality(nati_id));

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ

insert into language_nationality (language_id, nationality_id)
values
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);
--СОЗДАНИЕ ВТОРОЙ ТАБЛИЦЫ СО СВЯЗЯМИ
--народность-страна
create table nationality_country(nationality_id integer not null,country_id integer not null,
foreign key (nationality_id) references nationality(nati_id),
foreign key (counrty_id) references country(country_id));

--ВНЕСЕНИЕ ДАННЫХ В ТАБЛИЦУ СО СВЯЗЯМИ
insert into nationality_country(nationality_id,country_id)
values
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============


--ЗАДАНИЕ №1 
--Создайте новую таблицу film_new со следующими полями:
--·   	film_name - название фильма - тип данных varchar(255) и ограничение not null
--·   	film_year - год выпуска фильма - тип данных integer, условие, что значение должно быть больше 0
--·   	film_rental_rate - стоимость аренды фильма - тип данных numeric(4,2), значение по умолчанию 0.99
--·   	film_duration - длительность фильма в минутах - тип данных integer, ограничение not null и условие, что значение должно быть больше 0
--Если работаете в облачной базе, то перед названием таблицы задайте наименование вашей схемы.

create table film_new(film_name varchar(255) not null,
film_year integer check(film_year >0),
film_rental_rate numeric(4,2) default 0.99,
film_duration integer not null check(film_duration > 0)
);

--ЗАДАНИЕ №2 
--Заполните таблицу film_new данными с помощью SQL-запроса, где колонкам соответствуют массивы данных:
--·       film_name - array['The Shawshank Redemption', 'The Green Mile', 'Back to the Future', 'Forrest Gump', 'Schindlers List']
--·       film_year - array[1994, 1999, 1985, 1994, 1993]
--·       film_rental_rate - array[2.99, 0.99, 1.99, 2.99, 3.99]
--·   	  film_duration - array[142, 189, 116, 142, 195]

insert into film_new(film_name, film_year, film_rental_rate, film_duration)
values
('The Shawshank Redemption',1994,2.99, 142),
('The Green Mile', 1999, 0.99,189),
('Back to the Future',1985,1.99, 116),
('Forrest Gump',1994,2.99,142),
('Schindlers List', 1993, 3.99, 195);

--ЗАДАНИЕ №3
--Обновите стоимость аренды фильмов в таблице film_new с учетом информации, 
--что стоимость аренды всех фильмов поднялась на 1.41

update film_new 
set film_rental_rate = film_rental_rate + 1.41;

--ЗАДАНИЕ №4
--Фильм с названием "Back to the Future" был снят с аренды, 
--удалите строку с этим фильмом из таблицы film_new

delete from film_new 
where film_name = 'Back to the Future';

--ЗАДАНИЕ №5
--Добавьте в таблицу film_new запись о любом другом новом фильме

insert into film_new(film_name, film_year, film_rental_rate, film_duration)
values
('The Pursuit of Happyness',2006,4.99, 117);

--ЗАДАНИЕ №6
--Напишите SQL-запрос, который выведет все колонки из таблицы film_new, 
--а также новую вычисляемую колонку "длительность фильма в часах", округлённую до десятых

select *, round(cast(film_duration as decimal) / 60 , 1) as duration_hour from film_new; 

--ЗАДАНИЕ №7 
--Удалите таблицу film_new
drop table film_new;

