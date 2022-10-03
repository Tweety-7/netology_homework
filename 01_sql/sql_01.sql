--=============== МОДУЛЬ 2. РАБОТА С БАЗАМИ ДАННЫХ =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите уникальные названия городов из таблицы городов.

select DISTINCT city from city



--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания, чтобы запрос выводил только те города,
--названия которых начинаются на “L” и заканчиваются на “a”, и названия не содержат пробелов.


select DISTINCT city from city where  city NOT LIKE '% %'
and city like 'L%a'


--ЗАДАНИЕ №3
--Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись 
--в промежуток с 17 июня 2005 года по 19 июня 2005 года включительно, 
--и стоимость которых превышает 1.00.
--Платежи нужно отсортировать по дате платежа.


select r.rental_date, p.amount  from rental r
join 
 payment p  on r.rental_id =p.rental_id
 where date(r.rental_date) between '17-06-2005' and  '19-06-2005' and p.amount > 1
 order by r.rental_date


--ЗАДАНИЕ №4
-- Выведите информацию о 10-ти последних платежах за прокат фильмов.


 select payment_id , payment_date , amount  from payment p
 order by payment_date desc
 limit 10
--ЗАДАНИЕ №5
--Выведите следующую информацию по покупателям:
--  1. Фамилия и имя (в одной колонке через пробел)
--  2. Электронная почта
--  3. Длину значения поля email
--  4. Дату последнего обновления записи о покупателе (без времени)
--Каждой колонке задайте наименование на русском языке.


   select concat(c.first_name, ' ',c.last_name ) "имя", c.email "почта", character_length(c.email) "длина", cast(c.last_update as DATE) "последнее_обновление" from customer c



--ВОПРОС правильно же поняла, что надо именно отбросить, а не обнулить  "последнее обновление" как показано в лекции
-- если поняла не правильно, для быстрого исправления оставлю тут обнуление из лекции =))))
-- воть туть
-- cast(c.last_update as DATE) date_trunc('day',c.last_update) не отбрасывает, а обнуляет


--ЗАДАНИЕ №6
--Выведите одним запросом только активных покупателей, имена которых KELLY или WILLIE.
--Все буквы в фамилии и имени из верхнего регистра должны быть переведены в нижний регистр.


select lower(c.last_name) , lower(c.first_name),  c.active  from customer c where  (c.first_name like 'KELLY' or c.first_name like 'WILLIE') and c.active =1


--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите одним запросом информацию о фильмах, у которых рейтинг "R" 
--и стоимость аренды указана от 0.00 до 3.00 включительно, 
--а также фильмы c рейтингом "PG-13" и стоимостью аренды больше или равной 4.00.

select film_id,description , rating,rental_rate  from film
where (rating = 'R' and rental_rate between 0.0 and 3.0) or (rating = 'PG-13' and rental_rate >= 4.0)
order by film_id 

--ЗАДАНИЕ №2
--Получите информацию о трёх фильмах с самым длинным описанием фильма.


select f.film_id ,f.title , f.description  from film f
order by length(f.description) desc, film_id 
limit 3



--ЗАДАНИЕ №3
-- Выведите Email каждого покупателя, разделив значение Email на 2 отдельных колонки:
--в первой колонке должно быть значение, указанное до @, 
--во второй колонке должно быть значение, указанное после @.


select split_part(email,'@',1) "before", split_part(email,'@',2) "after"  from customer  


--ЗАДАНИЕ №4
--Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: 
--первая буква должна быть заглавной, остальные строчными.



