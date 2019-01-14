-- 1a
SELECT first_name, last_name FROM sakila.actor;

-- 1b
SELECT concat(first_name, ' ',last_name)  as ActorName FROM sakila.actor;

-- 2a
select actor_id , first_name , last_name from sakila.actor
where first_name = 'JOE'

-- 2b
select first_name , last_name from sakila.actor
where last_name like '%GEN'

-- 2c
select first_name , last_name from sakila.actor
where last_name like '%LI%'
order by last_name, first_name

-- 2d
select country_id, country from sakila.country
where country in ('Afghanistan', 'Bangladesh', 'China')

-- 3a
alter table sakila.actor
add column description blob

-- 3b
alter table sakila.actor
drop column description

-- 4a
select last_name, count(last_name) frequency from sakila.actor
group by (last_name)
order by frequency desc

-- 4b
select last_name, count(last_name) frequency from sakila.actor
group by (last_name)
having count(last_name) > 1
order by frequency desc

-- 4c
update sakila.actor
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS'

-- 4d
update sakila.actor
set first_name = 'GROUCHO'
where first_name = 'HARPO' and last_name = 'WILLIAMS'

-- 5a
SHOW CREATE TABLE sakila.actor;

-- 6a
select* from sakila.staff;

select staff.first_name, staff.last_name, address.address from sakila.staff
join sakila.address on staff.address_id = address.address_id;

-- 6b
select staff.first_name, staff.last_name, payment.amount from sakila.staff
join sakila.payment on  payment.payment_id =staff.staff_id 
where payment.payment_date > '2005-07-31' or payment.payment_date < '2005-09-01';

-- 6c
select film.title, count(film_actor.actor_id) No_of_Actors from sakila.film
inner join sakila.film_actor on film_actor.film_id = film.film_id
group by film.title;

-- 6d
select film.title, count(inventory.film_id) Copies from sakila.film
inner join sakila.inventory on film.film_id = inventory.film_id 
where film.title = 'Hunchback Impossible'
group by film.title;

-- 6e
select customer.first_name, customer.last_name, sum(payment.amount) 'Total Amount Paid' from sakila.customer
join sakila.payment on customer.customer_id = payment.customer_id
group by customer.last_name
order by customer.last_name asc;

-- 7a
select title
from film 
where title like 'K%' or title like 'Q%' -- Is there a better way?
and language_id in
(
	select language_id
    from language
    where language_id = 1
);

-- 7b
select first_name, last_name 
from actor
where actor_id in
	(select actor_id 
     from film_actor
     where film_id in
		(select film_id
		 from film
         where title = 'Alone Trip'
		)
	)
;
    
-- 7c
select email from customer
join sakila.address on customer.address_id = address.address_id
join sakila.city on city.city_id = address.city_id
join sakila.country on country.country_id = city.country_id
where country.country like 'Can%';

-- 7d
select title from film
join sakila.film_category on film_category.film_id = film.film_id
join sakila.category on film_category.category_id = category.category_id
where category.name = 'Family'

-- 7e
select film.title, count(rental.inventory_id) 'Times rented' from film
join sakila.inventory on inventory.film_id = film.film_id
join sakila.rental on inventory.inventory_id = rental.inventory_id
group by film.title 
order by count(rental.inventory_id) desc;

-- 7f
select customer.store_id, sum(payment.amount) '$ Earned' from customer
join sakila.payment on payment.customer_id = customer.customer_id
group by (customer.store_id);

-- 7g
select customer.store_id, city.city_id, country.country from customer
join sakila.address on address.address_id = customer.address_id
join sakila.city on city.city_id = address.city_id
join sakila.country on city.country_id = country.country_id;

-- 7h
select category.name, sum(payment.amount) Turnover from category
join sakila.film_category on category.category_id = film_category.category_id
join sakila.inventory on film_category.film_id = inventory.film_id
join sakila.rental on inventory.inventory_id = rental.inventory_id
join sakila.payment on rental.rental_id = payment.rental_id
group by category.name
order by Turnover desc limit 5 ;

-- 8a
create view Top5revenue as
select category.name, sum(payment.amount) Turnover from category
join sakila.film_category on category.category_id = film_category.category_id
join sakila.inventory on film_category.film_id = inventory.film_id
join sakila.rental on inventory.inventory_id = rental.inventory_id
join sakila.payment on rental.rental_id = payment.rental_id
group by category.name
order by Turnover desc limit 5;

-- 8b
select * from sakila.top5revenue;

-- 8c
drop view if exists sakila.top5revenue;