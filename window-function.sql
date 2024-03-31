-- s1
CREATE VIEW customer_rental_view AS
SELECT 
    cu.first_name AS customer_first_name,
    cu.last_name AS customer_last_name,
    cu.email AS customer_email,
    CONCAT(ad.address, ', ', ci.city, ', ', co.country) AS customer_address,
    st.email AS staff_email,
    fi.title AS film_title,
    re.rental_date,
    re.return_date,
    pa.amount
FROM customer cu
JOIN address ad ON cu.address_id = ad.address_id
JOIN city ci ON ad.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN rental re ON cu.customer_id = re.customer_id
JOIN inventory inv ON re.inventory_id = inv.inventory_id
JOIN film fi ON inv.film_id = fi.film_id
JOIN payment pa ON re.rental_id = pa.rental_id
JOIN staff st ON re.staff_id = st.staff_id;

-- s2
-- 1
SELECT 
    f.film_id, 
    f.title, 
    f.length, 
    c.name AS category,
    AVG(f.length) OVER (PARTITION BY fc.category_id) AS average_category_length
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category c ON fc.category_id = c.category_id
ORDER BY 
    f.film_id;

-- 2
SELECT 
    p.payment_id, 
    p.customer_id, 
    p.amount,
    COUNT(p.payment_id) OVER (PARTITION BY p.customer_id) AS number_of_payments
FROM 
    payment p
ORDER BY 
    p.payment_id;

--3 
WITH RankedCustomers AS (
    SELECT 
        cl.customer_id,
        cl.name, 
        cl.country, 
        COUNT(p.payment_id) AS payment_count,
        RANK() OVER (PARTITION BY cl.country ORDER BY COUNT(p.payment_id) DESC) AS customer_rank
    FROM 
        customer_list cl
    JOIN 
        payment p ON cl.customer_id = p.customer_id
    GROUP BY 
        cl.customer_id, cl.name, cl.country
)
SELECT 
    customer_id,
    name, 
    country, 
    payment_count
FROM 
    RankedCustomers
WHERE 
    customer_rank <= 3
ORDER BY 
    country, 
    customer_rank;

--s3
WITH TotalRevenue AS (
    SELECT
        c.first_name,
        c.last_name,
        p.staff_id,
        SUM(p.amount) AS total_amount
    FROM
        payment p
    JOIN customer c ON p.customer_id = c.customer_id
    GROUP BY
        c.first_name,
        c.last_name,
        p.staff_id
),
RevenueShare AS (
    SELECT
        first_name,
        last_name,
        staff_id,
        total_amount,
        SUM(total_amount) OVER (PARTITION BY first_name, last_name) AS total_revenue
    FROM
        TotalRevenue
)
SELECT
    first_name,
    last_name,
    staff_id,
    total_amount,
    ROUND((total_amount / total_revenue * 100), 2) AS percentage
FROM
    RevenueShare
ORDER BY
    first_name,
    last_name,
    staff_id;


