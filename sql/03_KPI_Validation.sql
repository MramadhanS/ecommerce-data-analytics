-- Analisis 1 : Revenue By Month 
WITH keseluruhan AS ( 
	SELECT 
		DATE_TRUNC('month', o.order_purchase_timestamp) AS bulan,
		SUM(oi.price) AS total_revenue,
		COUNT(DISTINCT o.order_id) AS jumlah_order
	FROM orders o
	JOIN order_items oi ON o.order_id = oi.order_id
	GROUP BY DATE_TRUNC('month',o.order_purchase_timestamp)
	ORDER BY bulan 
)
SELECT
	SUM(total_revenue) AS total_keseluruhan
FROM keseluruhan;


-- Analisis 2 : Revenue By Category
SELECT
	pf.category_english,
	SUM(oi.price) AS total_revenue,
	COUNT(oi.order_id) AS jumlah_item_terjual
FROM order_items oi
JOIN products_final pf ON oi.product_id = pf.product_id
GROUP BY pf.category_english
ORDER BY total_revenue DESC;

-- Analisis 3 : Distribusi Metode Pembayaran
SELECT
	payment_type,
	COUNT(*) AS jumlah_transaksi,
	SUM(payment_value) AS total_nilai,
	ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS presentase
FROM order_payments
GROUP BY payment_type
ORDER BY jumlah_transaksi DESC;
