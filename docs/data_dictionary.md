Table: olist_customers_dataset

| customer_id | VARCHAR(32) | ID Transaksi (Primary Key) |
| customer_unique_id | VARCHAR(32) | ID Customer |
| customer_zip_code_prefix | VARCHAR(5) | Kode Pos |
| customer_city | VARCHAR(50) | Nama Kota |
| customer_state | CHAR(2) | Provinsi dalam Bentuk Kode |

Table: olist_geolocation_dataset

| geolocation_zip_code_prefix | VARCHAR(5) | Kode Pos |
| geolocation_lat | DECIMAL(10, 8) | Garis Lintang |
| geolocation_lng | DECIMAL(11, 8) | Garis Bujur |
| geolocation_city | VARCHAR(50) | Nama Kota |
| geolocation_state | CHAR(2) | Provinsi dalam Bentuk Kode |

Table: olist_order_items_dataset

| order_id | VARCHAR(32) | ID Order (Primary Key & Foreign Key) |
| order_item_id | INT | Nomor Urut Item dalam satu Order (Primary Key) |
| product_id | VARCHAR(32) | ID Produk (Foreign Key) |
| seller_id | VARCHAR(32) | ID Seller (Foreign Key) |
| shipping_limit_date | TIMESTAMP | Batas Tanggal Pengiriman |
| price | DECIMAL(10, 2) | Harga Produk |
| freight_value | DECIMAL(10, 2) | Ongkir |

Table: olist_order_payments_dataset

| order_id | VARCHAR(32) | ID Order (Primary Key & Foreign Key) |
| payment_sequential | INT | Urutan Metode Pembayaran (Primary Key) |
| payment_type | VARCHAR(20) | Metode Pembayaran |
| payment_installments | INT | Jumlah Cicilan |
| payment_value | DECIMAL(10, 2) | Nominal Uang |

Table: olist_order_reviews_dataset

| review_id | VARCHAR(32) | ID Ulasan |
| order_id | VARCHAR(32) | ID Pesanan (Foreign Key) |
| review_score | SMALLINT | Rating / Skor Kepuasan (Skala 1 - 5) |
| review_comment_title | TEXT | Judul Komentar Ulasan |
| review_comment_message | TEXT | Isi Pesan Ulasan Pelanggan |
| review_creation_date | TIMESTAMP  | Tanggal Survei Ulasan Dikirim |
| review_answer_timestamp | TIMESTAMP | Waktu Pelanggan Mengisi Ulasan |

Table: olist_order_dataset

| order_id | VARCHAR(32) | ID Unik Pesanan (Primary Key) |
| customer_id | VARCHAR(32) | ID Unik Transaksi Pelanggan (Foreign Key) |
| order_status | VARCHAR(15) | Status Pesanan |
| order_purchase_timestamp | DATETIME | Waktu Pembelian Dibuat |
| order_approved_at | DATETIME | Waktu Pembayaran Disetujui |
| order_delivered_carrier_date | DATETIME | Waktu Barang Diserahkan ke Kurir |
| order_delivered_customer_date | DATETIME | Waktu Barang Diterima Pelanggan |
| order_estimated_delivery_date | DATETIME | Estimasi Tanggal Sampai |

Table: olist_products_dataset

| product_id | VARCHAR(32) | ID Unik Produk (Primary Key) |
| product_category_name | VARCHAR(50) | Nama Kategori Produk (Bahasa Portugis) (Foreign Key) |
| product_name_lenght | INT | Panjang Karakter Nama Produk |
| product_description_lenght | INT | Panjang Karakter Deskripsi Produk |
| product_photos_qty | INT | Jumlah Foto Produk |
| product_weight_g | DECIMAL(10, 2) | Berat Produk (Gram) |
| product_length_cm | DECIMAL(10, 2) | Dimensi Panjang Produk (cm) |
| product_height_cm | DECIMAL(10, 2) | Dimensi Tinggi Produk (cm) |
| product_width_cm | DECIMAL(10, 2) | Dimensi Lebar Produk (cm) |

Table: olist_sellers_dataset

| seller_id | VARCHAR(32) | ID Unik Penjual/Toko (Primary Key) |
| seller_zip_code_prefix | VARCHAR(5) | Awalan Kode Pos Toko Penjual (Foreign Key) |
| seller_city | VARCHAR(50) | Nama Kota Toko Penjual |
| seller_state | CHAR(2) | Kode Provinsi Toko Penjual (2 Huruf) |

Table: product_category_name_translation

| product_category_name | VARCHAR(50) | Nama Kategori Produk dalam Bahasa Portugis |
| product_category_name_english | VARCHAR(50) | Nama Kategori Produk dalam Bahasa Inggris |