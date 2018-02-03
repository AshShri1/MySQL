use sakila;

/***

* 1a. You need a list of all the actors who have Display the first and last names of all actors from the table `actor`. 

* 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 

***/

SELECT actor.first_name, actor.last_name
FROM actor;

SELECT UPPER(CONCAT(actor.first_name, ' ', actor.last_name)) as "Actor Name"
FROM actor;

/***
* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
  	
* 2b. Find all actors whose last name contain the letters `GEN`:
  	
* 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

* * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:

***/

SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
WHERE actor.first_name  = 'Joe';

SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
WHERE actor.last_name  like '%GEN%';

SELECT  actor.last_name, actor.first_name
FROM actor
WHERE actor.last_name  like '%LI%'
order by actor.last_name, actor.first_name;

SELECT country_id, country
from country
WHERE country  IN ('Afghanistan', 'Bangladesh', 'China')

/***
* 3a. Add a `middle_name` column to the table `actor`. Position it betwee 4a. List the last names of actors, as well as how many actors have that last name.
  	
* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
  	
* 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
  	
* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)n `first_name` and `last_name`. Hint: you will need to specify the data type.
  	
* 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.

* 3c. Now delete the `middle_name` column.
***/

ALTER TABLE actor add middle_name VARCHAR(50)

ALTER TABLE actor modify middle_name BLOB;

ALTER TABLE actor drop middle_name

/***
 4a. List the last names of actors, as well as how many actors have that last name.
  	
* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
  	
* 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
  	
* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
It turns out that `GROUCHO` was the correct name after all! In a single query, 
if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. 
Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)

***/

SELECT LAST_NAME, count(*) AS "# of Actors"
FROM actor
GROUP BY LAST_NAME
ORDER BY 2 DESC;

SELECT LAST_NAME, count(*) AS "# of Actors"
FROM actor
GROUP BY LAST_NAME
HAVING count(*)  >= 2
ORDER BY 2 DESC;

SELECT actor_id , last_name, first_name
FROM actor
WHERE last_name = 'WILLIAMS'
AND first_name = 'GROUCHO'

UPDATE actor
set first_name = 'HARPO'
where actor_id = 172

UPDATE actor
set first_name = 'GROUCHO'
where actor_id = 172


/***
* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
****/



CREATE  OR REPLACE TABLE  sakila.address (
  address_id smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  address  varchar(50) NOT NULL,
  address2 varchar(50) DEFAULT NULL,
  district varchar(20) NOT NULL,
  city_id smallint(5) unsigned NOT NULL,
  postal_code varchar(10) DEFAULT NULL,
  phone  varchar(20) NOT NULL,
  location geometry NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (address_id),
  KEY idx_fk_city_id (city_id),
  SPATIAL KEY Idx_location (Location),
  CONSTRAINT  fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON UPDATE CASCADE
)


/***

* 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

* 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 
  	
* 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
  	
* 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

***/


SELECT s.first_name, s.last_name, a.address, a.address2
FROM staff s
INNER JOIN address a ON s.address_id = a.address_id;


SELECT s.first_name, s.last_name, SUM(p.amount) 
FROM staff s, payment p
WHERE s.staff_id = p.staff_id
###AND p.payment_date >-= '08/10/2005'   AND payment_date  <=  '08/30/2005' (CHECK)
GROUP BY s.first_name, s.last_name
ORDER  by 3 DESC;



SELECT f.title, count(fa.actor_id) AS "Number of Actors"
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.title;



SELECT f.title, count(i.inventory_id) AS "Number of Copies"
FROM film f
INNER JOIN  inventory i ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;


SELECT c.last_name, c.first_name, sum(amount) AS "Amount"
FROM customer c  
INNER JOIN payment p on  c.customer_id = p.customer_id
GROUP BY c.last_name, c.first_name
ORDER BY  c.last_name


/***

7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 

* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
   
* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

* 7e. Display the most frequently rented movies in descending order.
  	
* 7f. Write a query to display how much business, in dollars, each store brought in.

* 7g. Write a query to display for each store its store ID, city, and country.
  	
* 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
  	
***/


SELECT f.title
FROM film f
WHERE (f.title like 'K%' or f.title like 'Q%')
AND f.language_id IN ( SELECT language_id
									  FROM language l
                                      WHERE name = 'English')
                                      

SELECT a.first_name , a.last_name 
FROM actor a
WHERE a.actor_id IN (SELECT fa.actor_id
									 FROM film_actor fa
                                     WHERE fa.film_id IN ( SELECT f.film_id
																		FROM film f
                                                                        WHERE f.title = 'Alone Trip'
                                                                        )
									)

SELECT c.first_name, c.last_name, c.email
FROM customer c 
INNER JOIN address a on c.address_id = a.address_id
INNER JOIN city  on a.city_id = city.city_id
INNER JOIN country on city.country_id = country.country_id
WHERE country.country = 'CANADA'



SELECT title, rating
FROM film
WHERE rating in ('G', 'PG');


SELECT f.title , r.rental_date
FROM film f
INNER JOIN inventory i on f.film_id =  i.film_id 
INNER JOIN rental r on  r.inventory_id = i.inventory_id
ORDER BY r.rental_date DESC;



SELECT s.store_id , SUM(p.amount) "Sales"
FROM store s
INNER JOIN inventory i on s.store_id = i.store_id
INNER JOIN rental r on  i.inventory_id = r.inventory_id
INNER JOIN payment p on r.rental_id = p.	rental_id
GROUP BY s.store_id 
ORDER BY  SUM(p.amount) DESC;



SELECT s.store_id, c.city, cou.country
FROM store s
INNER JOIN address  a on s.address_id = a.address_id
INNER JOIN city c on a.city_id = c.city_id
INNER JOIN country cou ON c.country_id = cou.country_id;




SELECT cat.name AS GENRE, SUM(p.amount) "REVENUE"
FROM category cat
INNER JOIN film_category fc on fc.category_id = cat.category_id
INNER JOIN inventory i on fc.film_id = i.film_id 
INNER JOIN rental r on  i.inventory_id = r.inventory_id
INNER JOIN payment p on r.rental_id = p.	rental_id
GROUP BY cat.name 
order by SUM(p.amount)  DESC LIMIT 5




/***
8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
  	
* 8b. How would you display the view that you created in 8a?

* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
***/

CREATE VIEW TOP5_GENRE 
AS
SELECT cat.name AS GENRE, SUM(p.amount) "REVENUE"
FROM category cat
INNER JOIN film_category fc on fc.category_id = cat.category_id
INNER JOIN inventory i on fc.film_id = i.film_id 
INNER JOIN rental r on  i.inventory_id = r.inventory_id
INNER JOIN payment p on r.rental_id = p.	rental_id
GROUP BY cat.name 
order by SUM(p.amount)  DESC LIMIT 5;


SELECT * FROM TOP5_GENRE;


DROP VIEW TOP5_GENRE
