SET search_path TO bookings;
--ЗАДАНИЕ №1
-- В каких городах больше одного аэропорта?
select city from airports a
group by city
having count(airport_code) > 1
--ЗАДАНИЕ №2
--В каких аэропортах есть рейсы, выполняемые самолетом 
--с максимальной дальностью перелета? 
--- Подзапрос

select distinct departure_airport  from flights f 
where aircraft_code = (select aircraft_code from  aircrafts a2 
order by "range" desc
limit 1)
UNION
select distinct arrival_airport  from flights f 
where aircraft_code = (select aircraft_code from  aircrafts a3 
order by "range" desc
limit 1)


--ЗАДАНИЕ №3
--Вывести 10 рейсов с максимальным временем задержки вылета
--- Оператор LIMIT


select flight_id, (scheduled_departure - actual_departure) as delta from flights f
order by delta 
limit 10


--ЗАДАНИЕ №4
-- Были ли брони, по которым не были получены посадочные талоны?
-- - Верный тип JOIN

select b.book_ref from  bookings b
left join tickets t 
on b.book_ref  = t.book_ref
left join boarding_passes bp 
on bp.ticket_no  = t.ticket_no 
where bp.ticket_no is null

--ЗАДАНИЕ №5
-- Найдите количество свободных мест для каждого рейса, их % отношение к общему 
-- количеству мест в самолете.
-- Добавьте столбец с накопительным итогом - суммарное накопление количества 
-- вывезенных пассажиров из каждого аэропорта на каждый день. Т.е. в этом столбце 
-- должна отражаться накопительная сумма - сколько человек уже вылетело из данного 
-- аэропорта на этом или более ранних рейсах в течении дня.
-- - Оконная функция
-- - Подзапросы или/и cte

select date_time, port,free, perc_free, seat,sum(seat) over (partition by port, DATE(date_time) order by date_time)
from
(
select f.actual_departure "date_time" , f.flight_no ,f.departure_airport "port" ,all_seat - col_z_no as "free", ((all_seat - col_z_no)*100)/all_seat as "perc_free" , col_z_no "seat"  from flights f 
join
(select s.aircraft_code, count(s.seat_no) all_seat
from seats s 
group by aircraft_code) as t_seat
on t_seat.aircraft_code = f.aircraft_code
join 
(select f.flight_id , count(tf.ticket_no) col_z_no  from flights f 
join ticket_flights tf 
on tf.flight_id = f.flight_id
group by f.flight_id) as flight_col_s
on flight_col_s.flight_id = f.flight_id
) as ta



--ЗАДАНИЕ №6
-- Найдите процентное соотношение перелетов по типам 
-- самолетов от общего количества.
-- - Подзапрос или окно
-- - Оператор ROUND

select count(flight_id) from flights f;
select aircraft_code, round(count(flight_id)*100/(select count(flight_id) from flights f))  "per" from flights f
group by aircraft_code 
order by per desc;

--ЗАДАНИЕ №7
-- Были ли города, в которые можно  добраться 
-- бизнес - классом дешевле, чем эконом-классом в рамках перелета?
-- - CTE

with cte_business as
(select flight_id ,fare_conditions , amount  from  ticket_flights tf
where fare_conditions = 'Business'),
cte_economy as
(select flight_id,fare_conditions , amount  from  ticket_flights tf
where fare_conditions = 'Economy')
select cte_business.flight_id, cte_economy.amount "econ",cte_business.amount "bus",  cte_economy.amount - cte_business.amount "delta"
from cte_business
join cte_economy
on cte_business.flight_id = cte_economy.flight_id
where cte_economy.amount > cte_business.amount
order by delta;


--ЗАДАНИЕ №8
-- Между какими городами нет прямых рейсов?
-- - Декартово произведение в предложении FROM
-- - Самостоятельно созданные представления 
-- (если облачное подключение, то без представления)
-- - Оператор EXCEPT



--ЗАДАНИЕ №9
-- Вычислите расстояние между аэропортами, связанными прямыми рейсами, 
-- сравните с допустимой максимальной дальностью перелетов  в самолетах, 
-- обслуживающих эти рейсы *
-- - Оператор RADIANS или использование sind/cosd
-- - CASE 










select *,
row_number() over (order by payment_date),
row_number() over (partition by customer_id  order by payment_date),
sum(amount) over (partition by customer_id order by payment_date,'sum'),
dense_rank() over (partition by customer_id order by amount desc)
from payment p

--ЗАДАНИЕ №2
--С помощью оконной функции выведите для каждого покупателя стоимость платежа и стоимость 
--платежа из предыдущей строки со значением по умолчанию 0.0 с сортировкой по дате.


select customer_id ,payment_id , payment_date , amount , lag(amount,1, 0.0) over (partition by customer_id order by payment_date)
from payment p 



--ЗАДАНИЕ №3
--С помощью оконной функции определите, на сколько каждый следующий платеж покупателя больше или меньше текущего.


select 
customer_id , payment_id , amount , lead(amount,1) over (partition by customer_id order by payment_date) - amount as "diff" 
from payment p 


--ЗАДАНИЕ №4
--С помощью оконной функции для каждого покупателя выведите данные о его последней оплате аренды.


select * from 
(select customer_id, payment_id, payment_date, amount, row_number() over (partition by customer_id  order by payment_date desc) 
from payment p) as t
where row_number = 1

--легче и быстрее вариант, оставляет только по 1 записи для каждого customer_id !!!!!!!!!!!1

select distinct on(customer_id)
from payment p
order by customer_id, payment_date desc

--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--С помощью оконной функции выведите для каждого сотрудника сумму продаж за август 2005 года 
--с нарастающим итогом по каждому сотруднику и по каждой дате продажи (без учёта времени) 
--с сортировкой по дате.

-- payment_date::date
select date_trunc('day', payment_date),staff_id, sum(amount) over (partition by staff_id order by date_trunc('day', payment_date))  from payment p
where date_trunc('day', payment_date) between '2005-08-01' and '2005-08-31'
order by staff_id, date_trunc('day', payment_date)
-- where date_trunc('mounth', payment_date) ='2005-08-01'
-- order by 1,2


--ЗАДАНИЕ №2
--20 августа 2005 года в магазинах проходила акция: покупатель каждого сотого платежа получал
--дополнительную скидку на следующую аренду. С помощью оконной функции выведите всех покупателей,
--которые в день проведения акции получили скидку

select distinct customer_id  from payment p 
where payment_id % 100 = 0 and date_trunc('day', payment_date) = '2005-08-20'


select * from 
(select customer_id, payment_date, row_number() over (order by payment_date)
from p
where payment_date::date = '2005-08-20') t
where t.row_number % 100 = 0

--ЗАДАНИЕ №3
--Для каждой страны ??? определите и выведите одним SQL-запросом покупателей, которые попадают под условия:
-- 1. покупатель, арендовавший наибольшее количество фильмов
-- 2. покупатель, арендовавший фильмов на самую большую сумму
-- 3. покупатель, который последним арендовал фильм


	-- не делала

with x1 as (
	select c.country_id, c.country, c3.first_name || ' ' || c3.last_name pname,
	count(i.film_id), sum(amount),
	max(r.rental_date) from country c
	join city c2 on c2.country_id = c.country_id
	join address a on a.city_id = c2.city_id
	left join customer c3 on c3.address_id  = a.address_id 
	left join payment p on p.customer_id = c3.customer_id
	left join rental r on r.rental_id = p.rental_id
	left join inventory i on i.inventory_id = r.inventory_id
	group by c.country_id, c3.customer_id
	),
x2 as(select distinct on (country_id) country_id, country,pname 
from x1
order by country_id, count desc),
x3 as (select distinct on(country_id) country_id, pname from x1
order by country_id, sum desc)
select
x2.country, x2.pname,x3.pname


