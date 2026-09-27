# 📊 E-Commerce Sales & Customer Analytics
### End-to-End Data Analytics Project | SQL · Excel · Power BI · GitHub

> Analisis performa penjualan, perilaku customer, dan efisiensi operasional pada platform e-commerce berbasis data transaksi nyata, untuk menghasilkan rekomendasi bisnis yang actionable.

**Tools/Skills:** SQL (PostgreSQL) • Data Cleaning • Data Modeling • Star Schema • DAX • Power BI • Microsoft Excel • Power Query • Pivot Table • Data Validation • Window Function • Business Intelligence • Dashboard Design • Data Storytelling

---

## 📌 1. Ringkasan Project

Project ini adalah simulasi kerja seorang **Data Analyst** di sebuah perusahaan e-commerce yang sedang berkembang. Menggunakan dataset transaksi nyata dari platform e-commerce Brazil (Olist), project ini mencakup seluruh siklus kerja data analyst secara end-to-end:

```
Data Mentah (CSV) → Data Quality Check (Excel) → Database (PostgreSQL/SQL)
→ Data Cleaning & Business Analysis (SQL) → Validasi Silang (Excel)
→ Data Modeling & Dashboard (Power BI) → Insight & Rekomendasi Bisnis
```

Yang membuat project ini berbeda dari sekadar "bikin dashboard": setiap keputusan teknis (kenapa pakai tipe data tertentu, kenapa suatu data dibersihkan dengan cara tertentu, kenapa hasil dari 2 tools bisa berbeda) **didokumentasikan alasannya**, bukan cuma hasil akhirnya.

---

## 🎯 2. Business Problem & Objective

**Skenario Bisnis:**
Sebuah perusahaan e-commerce yang sedang berkembang ingin memahami performa penjualan, perilaku customer, dan efisiensi operasional untuk menemukan peluang pertumbuhan revenue dan peningkatan customer experience.

**Role:** Data Analyst
**Stakeholders:** Head of Sales, Operations Manager, Business Manager

**Objective:** Menganalisis data transaksi untuk menjawab 10 pertanyaan bisnis inti di 3 area (Sales, Customer, Operations), lalu menerjemahkan hasilnya menjadi rekomendasi yang bisa langsung dieksekusi.

---

## 🗂️ 3. Dataset

**Sumber:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)

Dataset ini berisi ±100.000 transaksi e-commerce nyata di Brazil dari 2016–2018, tersebar di 9 tabel:

| Tabel | Isi | Jumlah Baris |
|---|---|---|
| orders | Data pesanan (status, tanggal purchase & delivery) | 99.441 |
| order_items | Detail item per pesanan (harga, ongkir) | 112.650 |
| customers | Data pelanggan | 99.441 |
| products | Data produk & kategori | 32.951 |
| sellers | Data penjual | 3.095 |
| order_payments | Metode & nilai pembayaran | 103.886 |
| order_reviews | Review & rating pelanggan | 99.224 |
| geolocation | Data koordinat lokasi | 1.000.163 |
| category_translation | Terjemahan nama kategori (PT → EN) | 71 |

**Kenapa dataset ini dipilih:** ukurannya cukup besar untuk mensimulasikan kondisi data nyata (bukan dataset "bersih" buatan), punya struktur relasional multi-tabel yang butuh JOIN, dan punya masalah data quality yang realistis — cocok untuk mensimulasikan pekerjaan data analyst sehari-hari.

---

## 🛠️ 4. Tools & Tech Stack

| Tools | Fungsi di Project Ini |
|---|---|
| **Microsoft Excel** (Power Query, Pivot Table, Data Model) | Data quality check awal, eksplorasi data, validasi silang hasil SQL |
| **PostgreSQL** | Database utama, tempat data dibersihkan dan dianalisis |
| **SQL** (JOIN, CTE, Window Function, VIEW) | Data cleaning, transformasi, business analysis |
| **Power BI** (Power Query, DAX, Data Model) | Data modeling (star schema), dashboard interaktif |
| **Git & GitHub** | Version control & dokumentasi project |

---

## ❓ 5. Business Questions

**Sales**
1. Bagaimana tren revenue dari waktu ke waktu?
2. Kategori apa yang memberikan revenue terbesar?
3. Produk mana yang paling berkontribusi terhadap revenue?
4. Bagaimana performa revenue antarwilayah?

**Customer**
5. Berapa rata-rata order per customer?
6. Bagaimana customer satisfaction berdasarkan review?
7. Apakah customer dengan order lebih banyak memiliki spending lebih tinggi?

**Operations**
8. Berapa rata-rata waktu pengiriman?
9. Berapa persentase order yang terlambat?
10. Apakah keterlambatan pengiriman berkaitan dengan rating yang lebih rendah?

---

## 🔄 6. Alur Kerja Project (Workflow)

### Tahap 1 — Data Quality Check (Excel)
Setiap dari 9 tabel dicek satu per satu menggunakan Excel (Power Query + formula) untuk menemukan: data duplikat, missing value, format tanggal tidak valid, nilai negatif/di luar rentang wajar, dan konsistensi antar tabel (referential integrity). Semua temuan dicatat lengkap dengan rencana penanganannya — bukan sekadar "ketemu masalah", tapi juga "bagaimana cara menanganinya".

### Tahap 2 — Load ke Database (SQL/PostgreSQL)
Seluruh data mentah dimuat ke database PostgreSQL menggunakan `CREATE TABLE` (dengan tipe data yang disesuaikan hasil temuan Tahap 1) dan perintah `COPY`. Primary Key ditentukan berdasarkan hasil pengecekan duplicate — bukan asumsi, tapi bukti dari data itu sendiri.

### Tahap 3 — Data Cleaning (SQL)
Dibuat **9 SQL VIEW** untuk menangani seluruh temuan data quality secara reusable (bisa dipakai berulang tanpa mengubah data mentah):
- Menghapus duplikasi review (551 order dengan lebih dari 1 review, diambil yang terbaru menggunakan `ROW_NUMBER()`)
- Menangani 610 produk dengan kategori kosong (`COALESCE` → `'unknown'`)
- Menerjemahkan kategori produk ke Bahasa Inggris (`LEFT JOIN`)
- Menghitung waktu pengiriman & status keterlambatan (`CASE WHEN`)
- Menandai (flag) anomali & outlier tanpa menghapus data asli

### Tahap 4 — Business Analysis (SQL)
11 analisis SQL bertingkat, dari yang sederhana (`GROUP BY`) sampai yang menggunakan **window function** (`RANK()`, `LAG()`, `PARTITION BY`) untuk menjawab 10 business question, termasuk analisis pertumbuhan bulanan (month-over-month growth) dan ranking produk per kategori.

### Tahap 5 — Validasi Silang (Excel vs SQL)
Angka hasil SQL dibandingkan dengan hasil Pivot Table Excel untuk memastikan konsistensi. Proses ini berhasil menemukan dan mendokumentasikan **bug locale mismatch** di Excel (nilai mata uang terbaca 100x lebih besar akibat kesalahan pembacaan desimal saat import CSV) — dikonfirmasi dan diperbaiki menggunakan hasil SQL sebagai *source of truth*.

### Tahap 6 — Data Modeling & Dashboard (Power BI)
Data dari SQL VIEW yang sudah bersih dimodelkan menjadi **Star Schema** (1 Fact Table + beberapa Dimension Table, termasuk tabel kalender `DimDate`), lalu dibangun **DAX Measures** dan **dashboard interaktif 3 halaman**.

---

## 🔍 7. Temuan Data Quality (Ringkasan)

| Masalah | Jumlah | Penanganan |
|---|---|---|
| Duplicate review (1 order >1 review) | 551 order | Ambil review terbaru via `ROW_NUMBER()` |
| Kategori produk kosong | 610 produk | Diberi label `'unknown'`, bukan dihapus |
| Order "delivered" tapi tanggal kirim kosong | 8 order | Diberi status khusus "Not Delivered" |
| Order tanpa data item (kemungkinan dibatalkan) | 775 order | Dikecualikan dari analisis revenue |
| Koordinat geolocation di luar wilayah Brazil | 31 baris | Difilter |
| Anomali urutan tanggal proses pengiriman | 1.382 order | Diberi flag, tidak dihapus |
| Bug locale currency di Excel (inflasi 100x) | Seluruh nilai uang | Dikonfirmasi & dikoreksi via SQL |

---

## 💻 8. SQL Analysis Highlights

Contoh teknik SQL yang digunakan di project ini:

```sql
-- Window Function: Growth Revenue Month-over-Month
WITH monthly_revenue AS (
    SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS bulan,
           SUM(oi.price) AS total_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY 1
)
SELECT bulan, total_revenue,
       LAG(total_revenue) OVER (ORDER BY bulan) AS revenue_bulan_lalu,
       ROUND(100.0 * (total_revenue - LAG(total_revenue) OVER (ORDER BY bulan))
             / LAG(total_revenue) OVER (ORDER BY bulan), 2) AS growth_percent
FROM monthly_revenue
ORDER BY bulan;
```

```sql
-- Window Function: Top 3 Produk per Kategori
SELECT category_english, product_id, total_revenue,
       RANK() OVER (PARTITION BY category_english ORDER BY total_revenue DESC) AS rank_in_category
FROM product_ranking
WHERE rank_in_category <= 3;
```

Teknik lain yang digunakan: multi-table `JOIN`, `LEFT JOIN` untuk mencegah kehilangan data, `CTE (WITH)`, `CASE WHEN`, `COALESCE`, agregasi bertingkat, dan pembuatan `VIEW` untuk data pipeline yang reusable.

---

## 📈 9. Dashboard Power BI

Dashboard dibangun menggunakan **Star Schema** (Fact Table: `order_items` + `orders`, Dimension Table: `customers`, `products`, `sellers`, `DimDate`) dan terdiri dari 3 halaman:

**Halaman 1 — Executive Overview**
KPI utama (Total Revenue, Total Orders, AOV, Total Customers, Avg Review Score, Late Delivery Rate), tren revenue bulanan, revenue by category & region, top 10 produk.

**Halaman 2 — Sales & Product Analysis**
Detail revenue per kategori, analisis quantity vs revenue (scatter plot), top & bottom 10 produk, growth rate bulanan, AOV per kategori.

**Halaman 3 — Customer & Operations**
Repeat vs single-order customer, delivery performance per wilayah, dan visualisasi kunci: **hubungan antara keterlambatan pengiriman dan review score**.

*(Screenshot dashboard ada di folder `/screenshots`)*

---

## 💡 10. Key Findings, Insight & Recommendation

### 🚨 Temuan Paling Penting
**Keterlambatan pengiriman berdampak besar terhadap kepuasan customer.** Order yang tepat waktu punya rata-rata review score **4,29**, sementara yang terlambat hanya **2,57** — selisih 1,72 poin dari skala 5. Ini membuktikan performa pengiriman adalah faktor utama kepuasan pelanggan, melebihi faktor lain seperti harga produk.
→ **Rekomendasi:** Prioritaskan perbaikan sistem logistik dan tracking pengiriman, terutama di wilayah dengan late rate tertinggi (AL, MA).

### 💰 Peluang Revenue dari Repeat Customer
Hanya **3% customer** yang belanja lebih dari sekali, namun mereka membelanjakan hampir **2x lipat** (R$260 vs R$138) dibanding pembeli sekali beli.
→ **Rekomendasi:** Bangun program retensi sederhana (follow-up email, voucher pembelian ke-2) — potensi dampaknya besar meski targetnya kecil.

### ⚠️ Risiko Konsentrasi Bisnis
2 kategori teratas menyumbang **18% revenue**, dan 1 provinsi (São Paulo) menyumbang **38% revenue** dari total.
→ **Rekomendasi:** Mulai diversifikasi kategori dan ekspansi wilayah menengah untuk mengurangi risiko ketergantungan.

### 📦 Ketimpangan Layanan Antar Wilayah
Late delivery rate dan waktu pengiriman sangat bervariasi antar provinsi — sebagian wilayah terpencil (RR, AP, AM) punya waktu kirim jauh lebih lama dari rata-rata nasional.
→ **Rekomendasi:** Evaluasi ulang estimasi waktu kirim untuk wilayah terpencil, dan audit khusus untuk provinsi dengan late rate tertinggi.

*(Analisis lengkap Finding → Insight → Recommendation untuk seluruh 10 temuan tersedia di file presentasi `/docs/insights_and_recommendations.pdf`)*

---

## ⚠️ 11. Project Limitations

- Dataset bersifat historis (2016–2018), tidak real-time
- Tidak tersedia data cost/margin, sehingga profitabilitas dihitung berdasarkan revenue, bukan profit sebenarnya
- Sebagian data (misal 610 produk tanpa kategori) diberi label "unknown" alih-alih dihapus, agar tidak kehilangan data transaksi yang valid
- Threshold outlier harga (R$5.000) ditentukan berdasarkan observasi data, bukan uji statistik formal

---

## 📁 12. Struktur Repository

```
ecommerce-data-analytics/
│
├── data/
│   └── README.md                  → sumber data (link Kaggle)
│
├── excel/
│   └── ecommerce_data_quality_analysis.xlsx
│
├── sql/
│   ├── 01_data_exploration.sql    → CREATE TABLE & import data
│   ├── 02_data_cleaning.sql       → 9 VIEW untuk data cleaning
│   ├── 03_kpi_analysis.sql        → analisis dasar (KPI)
│   └── 04_business_analysis.sql   → analisis lanjutan (window function)
│
├── powerbi/
│   └── ecommerce_dashboard.pbix
│
├── docs/
│   ├── business_case.md
│   ├── business_questions.md
│   ├── data_dictionary.md
│   └── insights_and_recommendations.pdf
│
├── screenshots/
│   ├── executive_overview.png
│   ├── sales_product_analysis.png
│   └── customer_operations.png
│
└── README.md
```

---

## 🚀 13. Cara Menjalankan Ulang Project Ini

1. Download dataset dari [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
2. Buat database PostgreSQL baru, jalankan `sql/01_data_exploration.sql`
3. Jalankan `sql/02_data_cleaning.sql` untuk membangun VIEW
4. Jalankan `sql/03_kpi_analysis.sql` dan `sql/04_business_analysis.sql` untuk melihat hasil analisis
5. Buka `powerbi/ecommerce_dashboard.pbix`, sambungkan ke database PostgreSQL lokal (via Npgsql driver), refresh data

---

## 🧠 14. Skills yang Didemonstrasikan

`Data Analysis` `Data Cleaning` `Data Quality Assurance` `SQL` `PostgreSQL` `JOIN` `CTE` `Window Function` `Data Validation` `Data Modeling` `Star Schema` `Power BI` `DAX` `Excel` `Power Query` `Pivot Table` `Dashboard Design` `Business Intelligence` `Data Storytelling` `Root Cause Analysis` `Cross-tool Data Reconciliation` `KPI Development`

---

## 👤 Author

**Ram**
Fresh Graduate — Teknik Informatika, Universitas Sriwijaya
Data Analyst | Palembang, Indonesia

📧 [ramadhansyaputra115@gmail.com] · 🔗 [www.linkedin.com/in/mramadhans] · 💻 [[GitHub](https://github.com/MramadhanS)]

---

*Project ini dibuat sebagai bagian dari portofolio data analyst, dengan fokus utama pada proses berpikir dan validasi data — bukan sekadar menghasilkan dashboard, tapi memastikan setiap angka di dalamnya bisa dipertanggungjawabkan.*
