-- Challenge 1

1/Create a list of all the distinct districts customers are from:
SELECT DISTINCT district
FROM address
JOIN customer ON customer.address_id = address.address_id;

2/ What is the latest rental date?
SELECT MAX(rental_date)
FROM rental;

3/How many films does the company have?
SELECT COUNT(*)
FROM film;
4/How many distinct last names of the customers are there?
SELECT COUNT(DISTINCT last_name)
FROM customer;

5/How many payments were made by the customer with customer_id = 100?
SELECT COUNT(*)
FROM payment
WHERE customer_id = 100;

6/What is the last name of our customer with the first name 'ERICA'?
SELECT last_name
FROM customer
WHERE first_name = 'ERICA';

7/How many rentals have not been returned yet (return_date is null)?
SELECT COUNT(*)
FROM rental
WHERE return_date IS NULL;

8/List of all the payment_ids with an amount less than or equal to $2:
SELECT payment_id
FROM payment
WHERE amount <= 2;

9/List of all the payments of the customer 322, 346, and 354 where the amount is either less than $2 or greater than $10:
SELECT *
FROM payment
WHERE customer_id IN (322, 346, 354)
AND (amount < 2 OR amount > 10);

10/SQL to get the list of concerned payments for customers 12, 25, 67, 93, 124, 234 with amounts 4.99, 7.99, and 9.99 in January 2020:
SELECT *
FROM payment
WHERE customer_id IN (12, 25, 67, 93, 124, 234)
AND amount IN (4.99, 7.99, 9.99)
AND date_trunc('month', payment_date) = date_trunc('month', CAST('2020-01-01' AS TIMESTAMP));


11/ How many payments have been made on January 26th and 27th 2020 with an amount between 1.99 and 3.99?
SELECT COUNT(*)
FROM payment
WHERE payment_date::DATE IN ('2020-01-26', '2020-01-27')
AND amount BETWEEN 1.99 AND 3.99;

12/How many movies are there that contain the "Documentary" in the description?
SELECT COUNT(*)
FROM film
WHERE description LIKE '%Documentary%';

13/How many customers are there  a first name that is Result 3 letters long and either an 'X' or a 'Y' as the last letter in the last name?

SELECT COUNT(*) AS customer_count
FROM customer
WHERE LENGTH(first_name) = 3 AND (last_name LIKE '%X' OR last_name LIKE '%Y');

14/  How many movies are there that contain 'Saga' in the description and where the title starts either with 'A' or ends with 'R'?
SELECT COUNT(*) AS movie_count
FROM film
WHERE description LIKE '%Saga%' AND (title LIKE 'A%' OR title LIKE '%R');

15/ Create a list of all customers where the first name contains 'ER' and has an 'A' as the second letter. Order the results by the last name descendingly.
SELECT *
FROM customer
WHERE first_name LIKE '_ER%' AND first_name LIKE 'A%'
ORDER BY last_name DESC;
16/ How many paymentsare there where the amount is either 0 or is between 3.99 and 7.99 and in the same time has happened on 2020-05-0
SELECT COUNT(*) AS payment_count
FROM payment
WHERE (amount = 0 OR amount BETWEEN 3.99 AND 7.99) AND payment_date::DATE = '2020-05-01';

17/ Your manager wants to which of the two employees (staff_id)
is responsible for more payments?

SELECT staff_id, COUNT(*) AS payment_count
FROM payment
GROUP BY staff_id
ORDER BY payment_count DESC
LIMIT 1;

18/ Which of the two is responsible for a higher overall payment
amount?

SELECT staff_id, SUM(amount) AS total_amount
FROM payment
GROUP BY staff_id
ORDER BY total_amount DESC
LIMIT 1;

19/ How do these amounts change if we don't consider amounts
equal to 0?
SELECT staff_id, SUM(amount) AS total_amount
FROM payment
WHERE amount > 0
GROUP BY staff_id
ORDER BY total_amount DESC;

20/ Which employee had the highest sales amount in a single day?
SELECT staff_id, payment_date::DATE, SUM(amount) AS total_sales
FROM payment
GROUP BY staff_id, payment_date::DATE
ORDER BY total_sales DESC
LIMIT 1;

21/Which employee had the most sales in a single day (not
counting payments with amount = 0?
SELECT staff_id, payment_date::DATE, COUNT(*) AS sales_count
FROM payment
WHERE amount > 0
GROUP BY staff_id, payment_date::DATE
ORDER BY sales_count DESC
LIMIT 1;

22/  In 2020, April 28, 29 and 30 were days with very high revenue.
That's why we want to focus in this task only on these days
SELECT customer_id, payment_date::DATE, AVG(amount) AS average_payment_amount
FROM payment
WHERE payment_date::DATE IN ('2020-04-28', '2020-04-29', '2020-04-30')
GROUP BY customer_id, payment_date::DATE
HAVING COUNT(*) > 1
ORDER BY average_payment_amount DESC;

23/In the email system there was a problem with names where either the first name or the last name is more than 10 characters long. Find these customers and output the list of these first and last names in all lower case.
SELECT LOWER(first_name) AS first_name, LOWER(last_name) AS last_name
FROM customer
WHERE LENGTH(first_name) > 10 OR LENGTH(last_name) > 10;

24/ Extract the first name from the email address and concatenate it with the last name. It should be in the form: "Last name, First name".
SELECT CONCAT(SPLIT_PART(email, '.', 2), ', ', SPLIT_PART(email, '@', 1)) AS name
FROM customer;

25/You need to create an anonymized form of the email addresses in the following way: M***.S***@sakillacustomer.org
SELECT CONCAT(SUBSTRING(first_name, 1, 1), '***.', SUBSTRING(last_name, 1, 1), '***@sakillacustomer.org') AS anonymized_email
FROM customer;

26/ You need to create a list for the suppcity team of all rental durations of customer with customer_id 35. Also you need to find out for the suppcity team which customer has the longest average rental duration?

SELECT rental_id, (EXTRACT(EPOCH FROM (return_date - rental_date)) / 3600) AS rental_duration_hours
FROM rental
WHERE customer_id = 35;

SELECT customer_id, AVG(EXTRACT(EPOCH FROM (return_date - rental_date)) / 3600) AS avg_rental_duration_hours
FROM rental
WHERE return_date IS NOT NULL
GROUP BY customer_id
ORDER BY avg_rental_duration_hours DESC
LIMIT 1;

-- Challenge 2
SELECT SUM(amount) AS total_amount, 
       TO_CHAR(payment_date, 'Dy, DD/MM/YYYY') AS day
FROM payment
GROUP BY day;


SELECT SUM(amount) AS total_amount, 
       EXTRACT(DOW FROM payment_date) AS day,
       TO_CHAR(payment_date, 'Month, YYYY') AS month_year
FROM payment
GROUP BY day, month_year;


SELECT SUM(amount) AS total_amount, 
       TO_CHAR(payment_date, 'Dy, HH24:MI') AS day
FROM payment
GROUP BY day;
