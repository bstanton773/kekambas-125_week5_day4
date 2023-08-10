-- Stored Functions!


SELECT COUNT(*)
FROM actor
WHERE last_name LIKE 'S%';


SELECT COUNT(*)
FROM actor
WHERE last_name LIKE 'T%';


-- Create a stored function that will give the count of actors with a 
-- last name that starts with *letter*

CREATE OR REPLACE FUNCTION get_actor_count(letter VARCHAR)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	DECLARE actor_count INTEGER;
BEGIN
	SELECT COUNT(*) INTO actor_count
	FROM actor 
	WHERE last_name ILIKE CONCAT(letter, '%');
	RETURN actor_count;
END;
$$;

-- Execute the function - use SELECT
SELECT get_actor_count('S');
SELECT get_actor_count('T');
SELECT get_actor_count('A');
SELECT get_actor_count('r');

SELECT get_actor_count('a');

-- Delete the get_actor_count function that takes in an integer
-- DROP FUNCTION IF EXISTS function_name
-- DROP FUNCTION IF EXISTS function_name(argtype)

DROP FUNCTION IF EXISTS get_actor_count(INTEGER);


-- Create a function that will return the employee with the most transactions (based on the payment table)


SELECT CONCAT(first_name, ' ', last_name) AS employee
FROM staff 
WHERE staff_id = (
	SELECT staff_id
	FROM payment
	GROUP BY staff_id
	ORDER BY COUNT(*) DESC
	LIMIT 1
);

-- Store the above as function
CREATE OR REPLACE FUNCTION employee_with_most_transactions()
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
	DECLARE employee VARCHAR;
BEGIN
	SELECT CONCAT(first_name, ' ', last_name) INTO employee
	FROM staff 
	WHERE staff_id = (
		SELECT staff_id
		FROM payment
		GROUP BY staff_id
		ORDER BY COUNT(*) DESC
		LIMIT 1
	);
	RETURN employee;
END;
$$;


SELECT employee_with_most_transactions();


-- Create a function that returns a table

SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country 
FROM customer c
JOIN address a
ON c.address_id = a.address_id 
JOIN city ci
ON a.city_id = ci.city_id 
JOIN country co
ON ci.country_id = co.country_id 
WHERE co.country = 'United States';

-- When returning a table, you need to define what the table will look like (col_name DATATYPE, )

CREATE OR REPLACE FUNCTION customers_in_country(country_name VARCHAR)
RETURNS TABLE (
	first_name VARCHAR(45),
	last_name VARCHAR(45),
	address VARCHAR(50),
	city VARCHAR(50),
	district VARCHAR(20),
	country VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country 
	FROM customer c
	JOIN address a
	ON c.address_id = a.address_id 
	JOIN city ci
	ON a.city_id = ci.city_id 
	JOIN country co
	ON ci.country_id = co.country_id 
	WHERE co.country = country_name;
END;
$$;

-- Execute a function that returns a table - use SELECT ... FROM function_name();
SELECT *
FROM customers_in_country('India');

SELECT *
FROM customers_in_country('France');

SELECT *
FROM customers_in_country('United States')
WHERE district = 'Texas';

SELECT district, COUNT(*)
FROM customers_in_country('United States')
GROUP BY district;


-- To delete a function, use DROP FUNCTION
-- add IF EXISTS to avoid error
DROP FUNCTION IF EXISTS employee_with_most_transactions;