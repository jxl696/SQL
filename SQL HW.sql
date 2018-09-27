#1a You need a list of all the actors who have Display the first and last names of all actors from the table actor.
SELECT * FROM sakila.actor;
Select first_name, last_name
From actor;

#1b Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
Select CONCAT(first_name, ' ', last_name) as "Actor Name"
from actor;

#2a You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
Select actor_id, first_name, last_name
from actor
where first_name = "JOE";

#2b Find all actors whose last name contain the letters GEN:
Select actor_id, first_name, last_name
from actor
Where last_name like "%GEN%";

#2c Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
Select first_name, last_name
from actor
Where last_name like "%LI%"
Order By last_name, first_name;

#2d Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM sakila.country
Where country in ("Afghanistan", "Bangladesh", "China");

#3a Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
#3b You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.
Alter Table sakila.actor
Add Column middle_name BLOB After first_name;
SELECT * FROM sakila.actor;

#3c Now delete the middle_name column.
SET SQL_SAFE_UPDATES= 0;
Alter Table sakila.actor
Drop middle_name;
SELECT * FROM sakila.actor;

#4a List the last names of actors, as well as how many actors have that last name.
Select last_name, Count(*) as last_name_count
from sakila.actor 
Group By last_name;

#4b List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
Select last_name, Count(*) as last_name_count_2
from sakila.actor 
Group By last_name
Having last_name_count_2 >=2;

#4c The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
Update sakila.actor
Set first_name = "HARPO"
Where first_name = "GROUCHO" And last_name = "WILLIAMS";

#4d Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
Update sakila.actor Set first_name = 
Case When first_name = "HARPO" Then "GROUCHO"
Else "MUCHO GROUCHO" 
END
WHERE actor_id=172;
END
END

#5a You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE sakila.address;

#6a  Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
Select staff.first_name, staff.last_name, address.address
From sakila.staff 
Inner Join sakila.address 
on staff.address_id = address.address_id;

#6b Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT staff.first_name, staff.last_name, sum(payment.amount) as total_amount
From sakila.staff
Inner Join sakila.payment
on staff.staff_id = payment.staff_id
Where Month(payment.payment_date) = 8 and Year (payment.payment_date) = 2005
Group By payment.staff_id;

#6c List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
Select film.title, Count(film_actor.actor_id) as actor_total
from sakila.film
Inner Join sakila.film_actor
on film.film_id = film_actor.film_id
Group By film_actor.film_id;

#6d How many copies of the film Hunchback Impossible exist in the inventory system?
Select film.title, Count(inventory.film_id) as copies_total
from sakila.film
Inner Join sakila.inventory
on film.film_id = inventory.film_id
Where film.title = "Hunchback Impossible"
Group By inventory.film_id;

#6e Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select customer.first_name, customer.last_name, sum(payment.amount) as customer_total_payment
from sakila.customer
Inner Join sakila.payment
on customer.customer_id = payment.customer_id
Group By payment.customer_id
Order By customer.last_name;

#7a The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
#   Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select film.title
from sakila.film
where film.language_id IN(
	Select language.language_id
    From sakila.language 
	Where language.name = "English"
) and
film.title like "K%" or film.title like "Q%";

#7b Use subqueries to display all actors who appear in the film Alone Trip.
select actor.actor_id, actor.first_name, actor.last_name
from sakila.actor
where actor.actor_id in(
	Select film_actor.actor_id 
    from sakila.film_actor
    where film_actor.film_id in(
		Select film.film_id
        from sakila.film
        where film.title = "Alone Trip")
);

#7c You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
Select customer.first_name, customer.last_name, customer.email
from sakila.customer
Inner Join sakila.address
on customer.address_id = address.address_id
Where address.city_id in(
	Select city.city_id
	from sakila.city
    Inner Join sakila.country
    on city.country_id = country.country_id
    where country.country = "Canada");
    
#7d Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
Select film.title
from sakila.film
inner join sakila.film_category
on film.film_id = film_category.film_id
Where film_category.category_id in(
	Select category.category_id
    from sakila.category
    Where category.name = "Family");
    
#7e  Display the most frequently rented movies in descending order.
Select film.title, count(rental.rental_id) as film_rental_count
from sakila.film
inner join sakila.inventory
on film.film_id = inventory.film_id

inner join sakila.rental
on inventory.inventory_id = rental.inventory_id

Group By film.title
Order by film_rental_count desc;

#7f Write a query to display how much business, in dollars, each store brought in.
Select store.store_id, sum(payment.amount) as "total_revenue"
from sakila.store
Inner Join sakila.staff
On store.store_id = staff.store_id

Inner Join sakila.payment
On payment.staff_id = staff.staff_id

Group By store.store_id;

#7g Write a query to display for each store its store ID, city, and country.
Select store.store_id, city.city, country.country
FROM  sakila.store
INNER JOIN sakila.address
on store.address_id = address.address_id

Inner Join sakila.city
on address.city_id = city.city_id

Inner Join sakila.country
on city.country_id = country.country_id;

#7h List the top five genres in gross revenue in descending order. 
# (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
Select category.name, sum(payment.amount) as revenue
From sakila.payment
Inner Join sakila.rental
on payment.rental_id = rental.rental_id

Inner Join sakila.inventory
on inventory.inventory_id = rental.inventory_id

Inner Join sakila.film_category
on film_category.film_id = inventory.film_id

Inner Join sakila.category
on category.category_id = film_category.category_id

Group BY category.name
Order by revenue desc
Limit 5;

#8a  In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
#    If you haven't solved 7h, you can substitute another query to create a view.
Create View Top_5 as 
(Select category.name as name, sum(payment.amount) as revenue
From sakila.payment
Inner Join sakila.rental
on payment.rental_id = rental.rental_id

Inner Join sakila.inventory
on inventory.inventory_id = rental.inventory_id

Inner Join sakila.film_category
on film_category.film_id = inventory.film_id

Inner Join sakila.category
on category.category_id = film_category.category_id

Group BY category.name
Order by revenue desc
Limit 5);


#8b How would you display the view that you created in 8a?
Select * from Top_5;

#8c You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view Top_5;
