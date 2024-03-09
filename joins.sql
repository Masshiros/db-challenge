-- challange 1
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.email, 
    a.address || ', ' || ci.city || ', ' || co.country AS full_address
FROM 
    customer c
JOIN 
    address a ON c.address_id = a.address_id
JOIN 
    city ci ON a.city_id = ci.city_id
JOIN 
    country co ON ci.country_id = co.country_id;

-- b: Staff list
SELECT 
    s.staff_id, 
    s.first_name, 
    s.last_name, 
    s.email, 
    a.address || ', ' || ci.city || ', ' || co.country AS full_address
FROM 
    staff s
JOIN 
    address a ON s.address_id = a.address_id
JOIN 
    city ci ON a.city_id = ci.city_id
JOIN 
    country co ON ci.country_id = co.country_id;

-- c: Film List
SELECT 
    f.film_id, 
    f.title, 
    f.description, 
    cat.name AS category_name, 
    act.first_name || ' ' || act.last_name AS actor_name
FROM 
    film f
JOIN 
    film_category fc ON f.film_id = fc.film_id
JOIN 
    category cat ON fc.category_id = cat.category_id
JOIN 
    film_actor fa ON f.film_id = fa.film_id
JOIN 
    actor act ON fa.actor_id = act.actor_id;

-- d: top 10 rental
SELECT 
    cu.first_name, 
    cu.last_name, 
    cu.email, 
    a.address || ', ' || ci.city || ', ' || co.country AS full_address, 
    st.email AS staff_email, 
    f.title, 
    r.rental_date, 
    r.return_date, 
    p.amount
FROM 
    rental r
JOIN 
    inventory i ON r.inventory_id = i.inventory_id
JOIN 
    film f ON i.film_id = f.film_id
JOIN 
    customer cu ON r.customer_id = cu.customer_id
JOIN 
    address a ON cu.address_id = a.address_id
JOIN 
    city ci ON a.city_id = ci.city_id
JOIN 
    country co ON ci.country_id = co.country_id
JOIN 
    staff st ON r.staff_id = st.staff_id
JOIN 
    payment p ON r.rental_id = p.rental_id
ORDER BY 
    r.rental_date DESC
LIMIT 10;
