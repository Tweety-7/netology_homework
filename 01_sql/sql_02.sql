--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.

SELECT concat(c.first_name, ' ', c.last_name) "customer name",
a.address,c2.city,
c3.country 
from customer as c
join address  as a
on c.address_id = a.address_id
join 
city c2 
on c2.city_id =a.city_id 
join country c3 
on c3.country_id = c2.country_id 



--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.

select c.store_id , count(customer_id) from customer c 
group by store_id 



--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.


select c.store_id , count(customer_id) from customer c 
group by store_id 
having count(customer_id) > 300


-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.


select s.store_id,t.count,ci.city "город", concat(sf.first_name, ' ', sf.last_name) "имя" 
from store s 
join address a 
on a.address_id = s.address_id 
join city ci
on ci.city_id = a.city_id 
join staff sf
on sf.staff_id = s.manager_staff_id
right join 
(select c.store_id , count(customer_id) from customer c 
group by store_id
having count(customer_id) > 300) as t
on t.store_id = s.store_id 

--ВОПРОС??????????????????????????/  inner или right join  использовать? подумала, что при правом как будто бы меньше сравнений будет


--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов


select concat(c.last_name,' ',c.first_name) "namebig", count(r.rental_id)  from rental r
join customer c 
on c.customer_id = r.customer_id 
group by namebig
order by count(r.rental_id) desc 
limit  5


--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма

select concat(c.first_name, ' ', c.last_name) "name"  , count(r.rental_id) "кол-во фильмов", round(sum(p.amount),0) "сумма", min(p.amount), max(p.amount) from rental r
join payment p 
on p.rental_id = r.rental_id
join customer c 
on c.customer_id = r.customer_id 
group  by name



--ЗАДАНИЕ №5
--Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
 --чтобы в результате не было пар с одинаковыми названиями городов. 
 --Для решения необходимо использовать декартово произведение.
 
select c.city, c2.city  from city c
cross join city c2
where c.city != c2.city 

select c.city "город 1" , c2.city "город 2"  from city c, city c2
where c.city != c2.city 

???? есть ли разница?

--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--и дате возврата фильма (поле return_date), 
--вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.
 

select r.customer_id, round(avg(cast(r.return_date as DATE)- cast(r.rental_date as DATE)),2)  from rental r
group by r.customer_id 
order by customer_id 


--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.


select f.title, f.rating "рейтинг",c.name "жанр",f.release_year "год",l.name "язык", count(r.rental_id), sum(p.amount)  from  rental r
join inventory i 
on r.inventory_id = i.inventory_id 
join film f 
on f.film_id = i.film_id
join payment p
on p.rental_id = r.rental_id
join "language" l 
on l.language_id = f.language_id
join film_category fc 
on fc.film_id  = f.film_id 
join category c 
on c.category_id = fc.category_id 
group by f.title, f.rating, f.language_id,f.release_year ,c.name , l.name
order by f.title

???????????????? 
--а можно как то не групировать по всем столбцам?



--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью запроса фильмы, которые ни разу не брали в аренду.

--СДАЮСЬ =(( после любых операци	 будто нет таких фильмов



--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".

select s.staff_id , count(p.payment_id),
case
	when count(p.payment_id) > 7300 then 'Да'
	else 'нет'
end "премия"
from staff s
join payment p 
on p.staff_id = s.staff_id
group by s.staff_id 





