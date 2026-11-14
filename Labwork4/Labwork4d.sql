-- 1. List names of all the languages in the database (sorted alphabetically)?
SELECT name 
FROM language 
ORDER BY name ASC;


-- 2. List full names of actors with "GER" in their last name, ordered by their first name
SELECT first_name, last_name 
FROM actor 
WHERE last_name LIKE '%GER%' 
ORDER BY first_name ASC;


-- 3. Find all the addresses where postal code starts with "57", and return addresses sorted.
SELECT address 
FROM address 
WHERE postal_code LIKE '57%' 
ORDER BY address ASC;


-- 4. How many films involve a "DWARF" in their titles?
SELECT COUNT(*) AS film_count
FROM film 
WHERE title LIKE '%DWARF%';


-- 5. Find full names of actors who played in a film involving 'WAR' in title and longer than 2.5 hours, 
-- along with the title, run length and release year of the movie, sorted by the actors' last names.
-- Note: 2.5 hours = 150 minutes
SELECT 
    a.first_name, 
    a.last_name, 
    f.title, 
    f.length, 
    f.release_year
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title LIKE '%WAR%' 
  AND f.length > 150
ORDER BY a.last_name ASC;


-- 6. Find all the film categories in which there are between 55 and 65 films. 
-- Return the names of these categories and the number of films per category, sorted by the number of films descending.
SELECT 
    c.name AS category_name, 
    COUNT(fc.film_id) AS number_of_films
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
HAVING number_of_films BETWEEN 55 AND 65
ORDER BY number_of_films DESC;


-- 7. In how many film categories is the average difference between the film replacement cost and the rental rate larger than 17?
SELECT COUNT(*) AS category_count
FROM (
    SELECT c.category_id
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    GROUP BY c.category_id
    HAVING AVG(f.replacement_cost - f.rental_rate) > 17
) AS categories_above_17;


-- 8. Find the address district(s) name(s) such that the minimal postal code in the district(s) is maximal over all the districts. 
-- Make sure your query ignores empty postal codes and district names.
SELECT district
FROM address
WHERE postal_code IS NOT NULL AND postal_code != '' 
  AND district IS NOT NULL AND district != ''
GROUP BY district
HAVING MIN(postal_code) = (
    -- Subquery to find the maximum of the minimal postal codes across all districts
    SELECT MAX(min_postal_code)
    FROM (
        SELECT MIN(postal_code) AS min_postal_code
        FROM address
        WHERE postal_code IS NOT NULL AND postal_code != '' 
          AND district IS NOT NULL AND district != ''
        GROUP BY district
    ) AS district_min_postals
);


-- 9. Find the names (first and last) of all the actors and customers whose first name is 
-- the same as the first name of the actor with ID 101 (exclude the actor with ID 101).
SELECT first_name, last_name, 'Actor' AS person_type
FROM actor
WHERE first_name = (SELECT first_name FROM actor WHERE actor_id = 101)
  AND actor_id != 101
UNION
SELECT first_name, last_name, 'Customer' AS person_type
FROM customer
WHERE first_name = (SELECT first_name FROM actor WHERE actor_id = 101);