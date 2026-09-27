-- Analisis 4 : Revenue by Region
SELECT
    c.customer_state,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS jumlah_order,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- Analisis 5 : Top 10 Produk
SELECT
    oi.product_id,
    pf.category_english,
    SUM(oi.price) AS total_revenue,
    COUNT(*) AS jumlah_terjual
FROM order_items oi
JOIN products_final pf ON oi.product_id = pf.product_id
GROUP BY oi.product_id, pf.category_english
ORDER BY total_revenue DESC
LIMIT 10;

-- Analisis 6 : Average Review Score by Category
SELECT
    pf.category_english,
    ROUND(AVG(rd.review_score), 2) AS avg_review_score,
    COUNT(DISTINCT rd.order_id) AS jumlah_review
FROM order_items oi
JOIN products_final pf ON oi.product_id = pf.product_id
JOIN review_deduplicated rd ON oi.order_id = rd.order_id
GROUP BY pf.category_english
ORDER BY avg_review_score DESC;

-- Analisis 7 : Delivery Performance & Late Rate
SELECT
    is_late,
    COUNT(*) AS jumlah_order,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS persentase,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM orders_with_delivery_info
GROUP BY is_late;

-- Analisis 8 : Month over Month Growth
WITH revenue_bulanan AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS bulan,
        SUM(oi.price) AS total_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
)
SELECT
    bulan,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY bulan) AS revenue_bulan_lalu,
    ROUND(
        100.0 * (total_revenue - LAG(total_revenue) OVER (ORDER BY bulan))
        / LAG(total_revenue) OVER (ORDER BY bulan), 2
    ) AS growth_percent
FROM revenue_bulanan
ORDER BY bulan;

-- Analisis 9 : Top 3 Product By Category
WITH product_ranking AS (
    SELECT
        pf.category_english,
        oi.product_id,
        SUM(oi.price) AS total_revenue,
        RANK() OVER (
            PARTITION BY pf.category_english
            ORDER BY SUM(oi.price) DESC
        ) AS rank_in_category
    FROM order_items oi
    JOIN products_final pf ON oi.product_id = pf.product_id
    GROUP BY pf.category_english, oi.product_id
)
SELECT *
FROM product_ranking
WHERE rank_in_category <= 3
ORDER BY category_english, rank_in_category;

-- Analisis 10 : Repeat Customer vs Single Order — Spending Comparison
WITH customer_spending AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spending
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    coc.customer_type,
    COUNT(*) AS jumlah_customer,
    ROUND(AVG(cs.total_spending), 2) AS avg_spending
FROM customer_order_count coc
JOIN customer_spending cs ON coc.customer_unique_id = cs.customer_unique_id
GROUP BY coc.customer_type;

-- Analisis 11 : Review Score vs Delivery Performance
SELECT
    owd.is_late,
    COUNT(*) AS jumlah_order,
    ROUND(AVG(rd.review_score), 2) AS avg_review_score
FROM orders_with_delivery_info owd
JOIN review_deduplicated rd ON owd.order_id = rd.order_id
GROUP BY owd.is_late
ORDER BY avg_review_score DESC;

-- Ad hoc Analysis : Price Outlier Investigation
SELECT
    pf.category_english,
    COUNT(*) AS jumlah_item_outlier,
    ROUND(AVG(oi.price), 2) AS avg_harga_outlier,
    MAX(oi.price) AS harga_tertinggi,
    ROUND(SUM(oi.price), 2) AS total_revenue_dari_outlier
FROM order_items_flagged oi
JOIN products_final pf ON oi.product_id = pf.product_id
WHERE oi.flag_price_outlier = TRUE
GROUP BY pf.category_english
ORDER BY total_revenue_dari_outlier DESC;