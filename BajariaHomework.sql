-- 1a. Display the first and last names of all actors from the table actor.
use sakila;
select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
use sakila;
select concat(first_name, last_name) as 'Actor Name' from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
use sakila;
select actor_id, first_name, last_name from actor where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
use sakila;
select * from actor where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
use sakila;
select * from actor where last_name like '%LI%' 
order by last_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
use sakila;
select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
use sakila;
alter table actor add column middle_name varchar(30) after first_name;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
use sakila;
alter table actor modify column middle_name blob;

-- 3c. Now delete the middle_name column.
use sakila;
alter table actor drop column middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
use sakila;
select last_name, count(*) from actor group by last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
use sakila;
select last_name, count(*) from actor group by last_name 
having count(*) >= 2;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
use sakila;
update actor 
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)
use sakila;
update actor
set first_name = 'GROUCHO' 
where actor_id = 172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
use sakila;
select a.first_name, a.last_name, b.address
from staff a, address b
where a.address_id = b.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
use sakila;
SELECT staff.last_name, staff.first_name, sum(payment.amount)
FROM staff, payment
WHERE staff.staff_id = payment.staff_id and payment_date between '2005-08-01' and '2005-08-31'
GROUP BY staff.last_name, staff.first_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
use sakila;
SELECT b.title, count(*) 
from film_actor a inner join film b
on a.film_id = b.film_id
group by title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
use sakila;
SELECT film.title, count(inventory.film_id)
FROM film, inventory
WHERE film.film_id = inventory.film_id
AND film.title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name
use sakila;
SELECT customer.last_name, customer.first_name, sum(payment.amount)
FROM customer
INNER JOIN payment
	ON customer.customer_id = payment.customer_id
GROUP BY customer.last_name, customer.first_name
ORDER BY customer.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
use sakila;
select title from film where language_id = 
(select language_id from language where name = 'English')
and title like 'K%'or title like 'U%';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
use sakila;
SELECT actor.last_name, actor.first_name
FROM actor
WHERE actor.actor_id IN
	(SELECT film_actor.actor_id
    FROM film_actor
    WHERE film_actor.film_id =
		(SELECT film.film_id
        FROM film
        WHERE film.title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
use sakila;
SELECT first_name, last_name, email
FROM customer
	INNER JOIN address
		ON customer.address_id = address.address_id
	INNER JOIN city
		ON address.city_id = city.city_id
	INNER JOIN country
		ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
use sakila;
SELECT title 
FROM film 
	INNER JOIN film_category
		ON film.film_id = film_category.film_id
	INNER JOIN category
		ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
use sakila;
SELECT film.title, COUNT(film.title) AS rental_count
	FROM film
    INNER JOIN inventory
		ON film.film_id = inventory.film_id
	INNER JOIN rental
		ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER by rental_count desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
use sakila;
SELECT 
        `c`.`city`, `cy`.`country`,
        SUM(`p`.`amount`) AS `total_sales`
    FROM
        `payment` `p`
        JOIN `rental` `r` ON `p`.`rental_id` = `r`.`rental_id`
        JOIN `inventory` `i` ON `r`.`inventory_id` = `i`.`inventory_id`
        JOIN `store` `s` ON `i`.`store_id` = `s`.`store_id`
        JOIN `address` `a` ON `s`.`address_id` = `a`.`address_id`
        JOIN `city` `c` ON `a`.`city_id` = `c`.`city_id`
        JOIN `country` `cy` ON `c`.`country_id` = `cy`.`country_id`
        JOIN .`staff` `m` ON `s`.`manager_staff_id` = `m`.`staff_id`
    GROUP BY `s`.`store_id`
    ORDER BY `cy`.`country` , `c`.`city`;

-- 7g. Write a query to display for each store its store ID, city, and country.
use sakila;
SELECT store.store_id, address.address_id, city.city, country.country
FROM store, address, city, country
WHERE store.address_id = address.address_id
AND address.city_id = city.city_id
AND city.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
use sakila;
SELECT
        `c`.`name` AS `category`, SUM(`p`.`amount`) AS `total_sales`
FROM
        `payment` `p`
        JOIN `rental` `r` ON `p`.`rental_id` = `r`.`rental_id`
        JOIN `inventory` `i` ON `r`.`inventory_id` = `i`.`inventory_id`
        JOIN `film` `f` ON `i`.`film_id` = `f`.`film_id`
        JOIN `film_category` `fc` ON `f`.`film_id` = `fc`.`film_id`
        JOIN `category` `c` ON `fc`.`category_id` = `c`.`category_id`
GROUP BY `c`.`name`
ORDER BY `total_sales` DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres AS
SELECT
        `c`.`name` AS `category`, SUM(`p`.`amount`) AS `total_sales`
FROM
        `payment` `p`
        JOIN `rental` `r` ON `p`.`rental_id` = `r`.`rental_id`
        JOIN `inventory` `i` ON `r`.`inventory_id` = `i`.`inventory_id`
        JOIN `film` `f` ON `i`.`film_id` = `f`.`film_id`
        JOIN `film_category` `fc` ON `f`.`film_id` = `fc`.`film_id`
        JOIN `category` `c` ON `fc`.`category_id` = `c`.`category_id`
GROUP BY `c`.`name`
ORDER BY `total_sales` DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
use sakila;
select * from top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
use sakila;
drop view top_five_genres;
