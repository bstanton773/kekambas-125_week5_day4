-- Stored Procedures!


SELECT *
FROM customer;

-- If you don't have loyalty member column, execute the following:
--ALTER TABLE customer
--ADD COLUMN loyalty_member BOOLEAN;


-- Reset all of our customers to be loyalty_member = False
UPDATE customer
SET loyalty_member = FALSE;

SELECT *
FROM customer 
WHERE loyalty_member = FALSE;


-- Create a Procedure that will set anyone who has spent >= $100 to be a loyalty_member


-- Step 1. Get all of the IDs of the customers who have spent at least $100
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) >= 100;


-- Step 2. Update the customer table and set the loyalty_member = TRUE if the customer_id is in the IDs from Step 1
UPDATE customer
SET loyalty_member = TRUE
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) >= 100
);

SELECT *
FROM customer 
WHERE loyalty_member = TRUE;


-- Take the previous command and put it in a Stored Procedure
CREATE OR REPLACE PROCEDURE update_loyalty_status(loyalty_min NUMERIC(5,2) DEFAULT 100.00)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customer
	SET loyalty_member = TRUE
	WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		HAVING SUM(amount) >= loyalty_min
	);
END;
$$;


-- Execute a procedure - use CALL
CALL update_loyalty_status();

SELECT *
FROM customer
WHERE loyalty_member = TRUE;

-- Mimic a custoemr making a new purchase that will put them over the threshold

-- Find a customer who is close to the threshold ($100)
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id 
HAVING SUM(amount) BETWEEN 95 AND 100;

SELECT *
FROM customer 
WHERE customer_id = 554; -- Loyalty MEMBER IS currently FALSE

-- Add a new payment of 4.99 with that customer to push them over the threshold
INSERT INTO payment(customer_id, staff_id, rental_id, amount, payment_date)
VALUES (554, 1, 1, 4.99, '2023-08-10 13:46:45');

-- Call the procedure again
CALL update_loyalty_status();

SELECT *
FROM customer 
WHERE customer_id = 554; -- Loyalty MEMBER IS now TRUE 


SELECT COUNT(*)
FROM customer
WHERE loyalty_member = TRUE; -- 297


-- Call the update_loyalty_status and override the default
CALL update_loyalty_status(75); 

SELECT COUNT(*)
FROM customer
WHERE loyalty_member = TRUE; -- 521



-- Create a procedure to add new rows to actor table
SELECT *
FROM actor;

SELECT NOW();

INSERT INTO actor (first_name, last_name, last_update)
VALUES ('Brian', 'Stanton', NOW());

INSERT INTO actor (first_name, last_name, last_update)
VALUES ('Sarah', 'Stodder', NOW());

INSERT INTO actor (first_name, last_name)
VALUES ('Kevin', 'Beier');

SELECT *
FROM actor
ORDER BY actor_id DESC;

-- Put the into a procedure that will accept a first and last name and create a new record
CREATE OR REPLACE PROCEDURE add_actor(first_name VARCHAR, last_name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO actor (first_name, last_name)
	VALUES (first_name, last_name);
END;
$$;


CALL add_actor('Tom', 'Hanks');
CALL add_actor('Tom', 'Cruise');

SELECT *
FROM actor
ORDER BY actor_id DESC;


-- To delete a procedure, we use DROP PROCEDURE procedure_name
DROP PROCEDURE IF EXISTS add_actor;




