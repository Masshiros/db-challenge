Challenge 1
-- Create the customer table
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(35) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    created TIMESTAMP WITHOUT TIME ZONE,
    updated TIMESTAMP WITHOUT TIME ZONE
);

-- Create the film table
CREATE TABLE film (
    film_id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    is_new BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITHOUT TIME ZONE,
    updated TIMESTAMP WITHOUT TIME ZONE
);

-- Create the on_sales table
CREATE TABLE on_sales (
    transaction_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    film_id INTEGER,
    amount DECIMAL(5,2) NOT NULL CHECK (amount >= 0.00 AND amount <= 999.99),
    promotion_code VARCHAR(15) DEFAULT NULL CHECK (CHAR_LENGTH(promotion_code) <= 10 OR promotion_code IS NULL),
    created TIMESTAMP WITHOUT TIME ZONE,
    updated TIMESTAMP WITHOUT TIME ZONE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);
Answer question: 
The value 'SUMMERDEAL2022' consists of 14 characters, which exceeds this limit.

Challenge 2

CREATE TABLE songs (
    song_id SERIAL PRIMARY KEY,
    song_name VARCHAR(30),
    genre VARCHAR(30) DEFAULT 'Not defined',
    price NUMERIC(4,2),
    release_date DATE
);


ALTER TABLE songs ALTER COLUMN song_name SET NOT NULL;


ALTER TABLE songs ADD CONSTRAINT price_check CHECK (price >= 1.99);


ALTER TABLE songs ADD CONSTRAINT date_check CHECK (release_date BETWEEN '1995-01-01' AND CURRENT_DATE);


CHALLENGE 3

CREATE TABLE country (
    country_id SERIAL PRIMARY KEY,
    country TEXT NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE city (
    city_id SERIAL PRIMARY KEY,
    city TEXT NOT NULL,
    country_id INTEGER NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);


CREATE TABLE language (
    language_id SERIAL PRIMARY KEY,
    name CHARACTER VARYING(20) NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE address (
    address_id SERIAL PRIMARY KEY,
    address TEXT NOT NULL,
    address2 TEXT,
    district TEXT NOT NULL,
    city_id INTEGER NOT NULL,
    postal_code TEXT,
    phone TEXT NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

CREATE TABLE store (
    store_id SERIAL PRIMARY KEY,
    manager_staff_id SMALLINT UNIQUE NOT NULL,
    address_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    address_id SMALLINT NOT NULL,
    email TEXT,
    store_id SMALLINT,
    active BOOLEAN DEFAULT TRUE,
    username TEXT NOT NULL,
    password TEXT,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    picture BYTEA,
    FOREIGN KEY (address_id) REFERENCES address(address_id),
    FOREIGN KEY (store_id) REFERENCES store(store_id)
);

ALTER TABLE store
ADD CONSTRAINT fk_manager_staff_id
FOREIGN KEY (manager_staff_id) REFERENCES staff(staff_id);

-- Table creation for 'customer'
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    store_id SMALLINT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    address_id SMALLINT NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    create_date DATE NOT NULL DEFAULT CURRENT_DATE,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    activebool BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (address_id) REFERENCES address(address_id)
    FOREIGN KEY (store_id) REFERENCES store(store_id)
    
);


CREATE TABLE actor (
    actor_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table creation for 'category'
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table creation for 'film'
CREATE TABLE film (
    film_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    release_year YEAR,
    language_id SMALLINT NOT NULL,
    original_language_id SMALLINT,
    rental_duration SMALLINT NOT NULL,
    rental_rate NUMERIC(4,2) NOT NULL,
    length SMALLINT,
    replacement_cost NUMERIC(5,2) NOT NULL,
    rating MPAA_RATING,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    special_features TEXT[],
    fulltext TSVECTOR,
    FOREIGN KEY (language_id) REFERENCES language(language_id),
    FOREIGN KEY (original_language_id) REFERENCES language(language_id)
);

-- Table creation for 'film_actor'
CREATE TABLE film_actor (
    actor_id SMALLINT NOT NULL,
    film_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (actor_id, film_id),
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

-- Table creation for 'film_category'
CREATE TABLE film_category (
    film_id SMALLINT NOT NULL,
    category_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (film_id, category_id),
    FOREIGN KEY (film_id) REFERENCES film(film_id),
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);



-- Table creation for 'inventory'
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    film_id SMALLINT NOT NULL,
    store_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (film_id) REFERENCES film(film_id),
    FOREIGN KEY (store_id) REFERENCES store(store_id)
);

-- Table creation for 'rental'
CREATE TABLE rental (
    rental_id SERIAL PRIMARY KEY,
    rental_date TIMESTAMP WITH TIME ZONE NOT NULL,
    inventory_id INTEGER NOT NULL,
    customer_id SMALLINT NOT NULL,
    return_date TIMESTAMP WITH TIME ZONE,
    staff_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- Table creation for 'payment'
CREATE TABLE payment (
    payment_id SERIAL PRIMARY KEY,
    customer_id SMALLINT NOT NULL,
    staff_id SMALLINT NOT NULL,
    rental_id INTEGER NOT NULL,
    amount NUMERIC(5,2) NOT NULL,
    payment_date TIMESTAMP WITH TIME ZONE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (rental_id) REFERENCES rental(rental_id)
);



