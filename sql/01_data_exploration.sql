-- table customers
CREATE TABLE customers (
	customer_id VARCHAR(32) PRIMARY KEY,
    customer_unique_id VARCHAR(32),
    customer_zip_code_prefix VARCHAR(5),
    customer_city VARCHAR(50),
    customer_state CHAR(2)
);

-- table geolocation
CREATE TABLE geolocation (
	geolocation_zip_code_prefix VARCHAR(5),
    geolocation_lat DECIMAL(10,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(50),
    geolocation_state CHAR(2)
);

-- table order items
CREATE TABLE order_items (
 	order_id VARCHAR(32),
    order_item_id INT,
    product_id VARCHAR(32),
    seller_id VARCHAR(32),
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- table order payments
CREATE TABLE order_payments (
	order_id VARCHAR(32),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

-- 5. Tabel order_reviews (TIDAK ada PRIMARY KEY, sengaja, karena ada duplicate)
CREATE TABLE order_reviews (
    review_id VARCHAR(32),
    order_id VARCHAR(32),
    review_score SMALLINT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

-- 6. Tabel orders
CREATE TABLE orders (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(32),
    order_status VARCHAR(15),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

-- 7. Tabel products
CREATE TABLE products (
    product_id VARCHAR(32) PRIMARY KEY,
    product_category_name VARCHAR(50),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g DECIMAL(10,2),
    product_length_cm DECIMAL(10,2),
    product_height_cm DECIMAL(10,2),
    product_width_cm DECIMAL(10,2)
);

-- 8. Tabel sellers
CREATE TABLE sellers (
    seller_id VARCHAR(32) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(5),
    seller_city VARCHAR(50),
    seller_state CHAR(2)
);

-- 9. Tabel category_translation
CREATE TABLE category_translation (
    product_category_name VARCHAR(60) PRIMARY KEY,
    product_category_name_english VARCHAR(60)
);

-- IMPORT CSV
COPY customers(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
FROM 'C:\RamaFiles\Data Analyst Project\E Commerce Analyst\data\raw\olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Sellers
COPY sellers(seller_id, seller_zip_code_prefix, seller_city, seller_state)
FROM 'C:\RamaFiles\Data Analyst Project\E Commerce Analyst\data\raw\olist_sellers_dataset.csv'
DELIMITER ',' CSV HEADER;

-- Products
COPY products(product_id, product_category_name, product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)
FROM 'C:\RamaFiles\Data Analyst Project\E Commerce Analyst\data\raw\olist_products_dataset.csv'
DELIMITER ',' CSV HEADER;

-- Orders
COPY orders(order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date)
FROM 'C:\RamaFiles\Data Analyst Project\E Commerce Analyst\data\raw\olist_orders_dataset.csv'
DELIMITER ',' CSV HEADER;

-- Order Items
COPY order_items(order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value)
FROM 'C:\RamaFiles\Data Analyst Project\E Commerce Analyst\data\raw\olist_order_items_dataset.csv'
DELIMITER ',' CSV HEADER;

-- Order Payments
COPY order_payments(order_id, payment_sequential, payment_type, payment_installments, payment_value)
FROM 'C:\RamaFiles\Data Analyst Project\E Commerce Analyst\data\raw\olist_order_payments_dataset.csv'
DELIMITER ',' CSV HEADER;

-- Order Reviews
COPY order_reviews(review_id, order_id, review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp)
FROM 'C:\RamaFiles\Data Analyst Project\E Commerce Analyst\data\raw\olist_order_reviews_dataset.csv'
DELIMITER ',' CSV HEADER;

-- Geolocation
COPY geolocation(geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state)
FROM 'C:\RamaFiles\Data Analyst Project\E Commerce Analyst\data\raw\olist_geolocation_dataset.csv'
DELIMITER ',' CSV HEADER;

-- Category Translation
COPY category_translation(product_category_name, product_category_name_english)
FROM 'C:\RamaFiles\Data Analyst Project\E Commerce Analyst\data\raw\product_category_name_translation.csv'
DELIMITER ',' CSV HEADER;

-- Dataset Information
SELECT 'customers' AS table_name, COUNT(*) FROM customers
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation;

