use sakila;

select * from actor;

-- display first & last names from table actor 
select first_name, last_name from actor;

-- find ID number, first name, last name by an actors first name only 
select actor_id, last_name, first_name
from actor
group by first_name;

-- find all actors whose last name contains letters GEN
select last_name
from actor 
where last_name like '%GEN%';

-- find all actors whose last name contains letters LI
-- order rows by last name & first name
select last_name, first_name
from actor
where last_name like '%LI%'
order by last_name, first_name; 

-- using IN, display country_id & country columns for Afghanistan, Bangladesh & China, 
select country_id, country 
from country 
where country in ('Afghanistan', 'Bangladesh', 'China');

-- create column called description in table actor & use data type BLOB 
-- binary large object
alter table actor 
add column Description BLOB after last_name;
select * from actor;

-- delete description column 
alter table actor 
drop column Description;
select * from actor;

-- list last names of actors & how many actors have each last name 
select last_name, count(last_name) as actor_count
from actor
group by last_name; 

-- list last name of actors & number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(last_name) as actor_count
from actor
group by last_name having actor_count >= 2; 

-- actor Harpo Williams was entered as Groucho Williams, fix it 
update actor 
set first_name = "Harpo" 
where first_name = "Groucho" and last_name = "Williams";

-- query to recreate address table 
show create table address;

-- use JOIN to display first and last names & address of each staff member
-- use tables staff & address
select s.first_name, s.last_name, a.address 
from staff s 
inner join address a 
on (s.address_id = a.address_id);

-- use JOIN to display total amount rung up by each staff member in August of 2005
select * from staff;
select s.first_name, s.last_name, sum(p.amount)
from staff s 
inner join payment p 
on (p.staff_id = s.staff_id);

-- list each film & number of actors who are listed for that film 
-- use tables film_actor & film & inner join 
select f.title, count(fa.actor_id) as actors 
from film_actor fa 
inner join film f 
on (f.film_id = fa.film_id);

-- number of copoies of the film Hunchback Impossible exist in inventory system 
select title, count(inventory_id) as "Number of Copies"
from film 
inner join inventory using (film_id)
where title = "Hunchback Impossible"
group by title;

-- using tables payment & customer & JOIN, list total paid  by each customer
-- list customers alphabetically by last name 
select c.first_name, c.last_name, sum(p.amount) as "Total Amount Paid" 
from payment p
inner join customer c using(customer_id)
group by c.customer_id
order by c.last_name; 

-- use subqueries to display titles of movies starting with letter K and Q whose language is English 
select title
from film 
where title like "K%" or title like "Q%" and language_id in 
(select language_id from language where name = "English");

-- use subqueries to display actors who appear in the film Alone Trip 
select first_name, last_name
from actor
where actor_id in 
(select actor_id from film_actor where film_id = 
(select film_id from film where title = "Alone Trip"));

-- use JOINS to retrieve names & emails of all Canadian customers 
select first_name, last_name, email, country 
from customer
inner join address using (address_id)
inner join city using (city_id)
inner join country using (country_id)
where country = "canada";

-- identify all movies categorized as family films 
select title, name
from film 
inner join film_category using (film_id)
inner join category using (category_id)
where name = "family";

-- display most frequently rented movies in descending order
select title, count(title) as "Rentals"
from film 
inner join inventory using (film_id)
inner join rental using (inventory_id)
group by title 
order by rentals desc;

-- write a query to display how much business, in dollars, each store brought in 
select store_id, sum(amount) as "Gross Amount"
from payment 
inner join rental using (rental_id)
inner join inventory using (inventory_id)
inner join store using (store_id)
group by store_id;

-- an easy way to view top 5 genres by gross revenueuse solution from above to create a view
create view top_5_genres as select sum(amount) as "Total Sales"
, name as genre 
from payment 
inner join rental using (rental_id)
inner join inventory using (inventory_id)
inner join film_category using (film_id)
inner join category using (category_id)
group by name 
order by sum(amount) desc
limit 5;

-- how would you display view created above 
select * from top_5_genres;

-- no longer need the view top_five_genres & delete it  
drop view top_5_genres;