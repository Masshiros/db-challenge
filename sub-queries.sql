-- Q1: 
SELECT MIN(replacement_cost) AS lowest_replacement_cost
FROM film;

-- Q2: 
SELECT 
  CASE
    WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
    WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
    WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 'high'
  END AS cost_range,
  COUNT(*) AS film_count
FROM film
GROUP BY cost_range;

-- q3
SELECT f.title, f.length, c.name AS category_name
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name IN ('Drama', 'Sports')
ORDER BY f.length DESC
LIMIT 1;

-- q4
SELECT c.name AS category_name, COUNT(*) AS film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY film_count DESC
LIMIT 1;

-- q5 
SELECT a.first_name, a.last_name, COUNT(fa.film_id) AS movie_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY movie_count DESC
LIMIT 1;
-- q6
SELECT COUNT(*) AS address_count
FROM address a
LEFT JOIN customer c ON a.address_id = c.address_id
WHERE c.address_id IS NULL;

-- q7
SELECT ci.city, SUM(p.amount) AS total_sales
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
GROUP BY ci.city_id
ORDER BY total_sales DESC
LIMIT 1;

-- q8
SELECT CONCAT(co.country, ', ', ci.city) AS location, SUM(p.amount) AS total_sales
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY location
ORDER BY total_sales ASC
LIMIT 1;

-- q9 
SELECT staff_id, AVG(total_sales) AS avg_revenue_per_customer
FROM (
    SELECT staff_id, customer_id, SUM(amount) AS total_sales
    FROM payment
    GROUP BY staff_id, customer_id
) AS sales_per_customer
GROUP BY staff_id
ORDER BY avg_revenue_per_customer DESC
LIMIT 1;

-- q10
SELECT AVG(daily_total) AS avg_sunday_revenue
FROM (
    SELECT SUM(amount) AS daily_total, DATE(payment_date) AS payment_date
    FROM payment
    WHERE EXTRACT(DOW FROM payment_date) = 0 -- 0 is Sunday in some SQL dialects
    GROUP BY DATE(payment_date)
) AS sunday_revenues;

-- q11
SELECT title, length, replacement_cost
FROM film
WHERE length > (
    SELECT AVG(length) 
    FROM film AS f2
    WHERE f2.replacement_cost = film.replacement_cost
)
ORDER BY length ASC
LIMIT 2;
-- q13
SELECT 
  p.payment_id,
  p.amount,
  c.name AS category_name,
  (
    SELECT SUM(p2.amount) 
    FROM payment p2
    JOIN rental r2 ON p2.rental_id = r2.rental_id
    JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    JOIN film f2 ON i2.film_id = f2.film_id
    JOIN film_category fc2 ON f2.film_id = fc2.film_id
    JOIN category c2 ON fc2.category_id = c2.category_id
    WHERE c2.name = c.name
  ) AS total_amount
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action'
ORDER BY c.name ASC, p.payment_id ASC;

-- q14 
SELECT 
  c.name AS category_name, 
  f.title,
  SUM(p.amount) AS total_revenue
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name, f.title
ORDER BY c.name, total_revenue DESC;
