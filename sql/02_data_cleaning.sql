-- review_deduplicated
CREATE VIEW review_deduplicated AS 
SELECT * 
FROM (
	SELECT *, 
		ROW_NUMBER() OVER (
			PARTITION BY order_id 
			ORDER BY review_answer_timestamp DESC
		) AS rn 
	FROM order_reviews
) sub 
WHERE rn = 1;

-- products_clean
CREATE VIEW products_final AS
SELECT
    p.product_id,
    p.product_category_name,
    COALESCE(ct.product_category_name_english, 'unknown') AS category_english,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM products_clean p
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name;

-- orders_with_delivery_info
CREATE VIEW orders_with_delivery_info AS
SELECT 
	*,
	CASE
		WHEN order_delivered_customer_date IS NULL THEN NULL
		ELSE order_delivered_customer_date::date - order_purchase_timestamp::date
	END AS delivery_days,
	CASE
		WHEN order_delivered_customer_date IS NULL THEN 'Not Delivered'
		WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Late'
		ELSE 'On Time'
	END AS is_late
FROM orders;

-- orders_flagged
CREATE VIEW orders_flagged AS
SELECT
    *,
    CASE
        WHEN order_delivered_carrier_date < order_approved_at THEN TRUE
        ELSE FALSE
    END AS flag_carrier_before_approved,
    CASE
        WHEN order_delivered_customer_date < order_delivered_carrier_date THEN TRUE
        ELSE FALSE
    END AS flag_customer_before_carrier
FROM orders_with_delivery_info;

-- order_items_flagged
CREATE VIEW order_items_flagged AS
SELECT
    *,
    CASE
        WHEN price > 5000 THEN TRUE
        ELSE FALSE
    END AS flag_price_outlier
FROM order_items;

-- customer_order_count
CREATE VIEW customer_order_count AS
SELECT
    customer_unique_id,
    COUNT(DISTINCT c.customer_id) AS jumlah_transaksi,
    CASE
        WHEN COUNT(DISTINCT c.customer_id) > 1 THEN 'Repeat Customer'
        ELSE 'Single Order'
    END AS customer_type
FROM customers c
GROUP BY customer_unique_id;

-- order_payments_flagged
CREATE VIEW order_payments_flagged AS
SELECT
    *,
    CASE
        WHEN payment_value = 0 THEN TRUE
        ELSE FALSE
    END AS flag_zero_value,
    CASE
        WHEN payment_installments = 0 THEN TRUE
        ELSE FALSE
    END AS flag_zero_installments,
    CASE
        WHEN payment_type = 'not_defined' THEN TRUE
        ELSE FALSE
    END AS flag_undefined_type
FROM order_payments;

-- geolocation_clean
CREATE VIEW geolocation_clean AS
SELECT *
FROM geolocation
WHERE geolocation_lat BETWEEN -34 AND 6
  AND geolocation_lng BETWEEN -74 AND -32;


-- verifikasi review_deduplicated
SELECT COUNT(*) AS total_baris FROM review_deduplicated;

-- verifikasi products_clean
SELECT COUNT(*) AS jumlah_unknown 
FROM products_clean 
WHERE product_category_name = 'unknown';

SELECT COUNT(*) AS masih_null
FROM products_clean 
WHERE product_name_lenght IS NULL;

-- verifikasi orders_with_delivery_info
SELECT is_late, COUNT(*) AS jumlah
FROM orders_with_delivery_info
GROUP BY is_late;

-- verifikasi products_final
SELECT DISTINCT product_category_name, category_english
FROM products_final
LIMIT 10;

SELECT COUNT(*) AS cek_unknown_english
FROM products_final
WHERE category_english = 'unknown';

-- verifikasi orders_flagged
SELECT 
    SUM(CASE WHEN flag_carrier_before_approved THEN 1 ELSE 0 END) AS total_carrier_before_approved,
    SUM(CASE WHEN flag_customer_before_carrier THEN 1 ELSE 0 END) AS total_customer_before_carrier
FROM orders_flagged;

-- verifikasi order_items_flagged
SELECT 
    flag_price_outlier, 
    COUNT(*) AS jumlah,
    MIN(price) AS harga_min,
    MAX(price) AS harga_max
FROM order_items_flagged
GROUP BY flag_price_outlier;

-- verifikasi customer_order_count
SELECT customer_type, COUNT(*) AS jumlah_customer
FROM customer_order_count
GROUP BY customer_type;

-- verifikasi order_payments_flagged
SELECT 
    SUM(CASE WHEN flag_zero_value THEN 1 ELSE 0 END) AS total_zero_value,
    SUM(CASE WHEN flag_zero_installments THEN 1 ELSE 0 END) AS total_zero_installments,
    SUM(CASE WHEN flag_undefined_type THEN 1 ELSE 0 END) AS total_undefined_type
FROM order_payments_flagged;

-- verifikasi geolocation
SELECT COUNT(*) AS total_setelah_filter FROM geolocation_clean;