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

untuk dataset geolocation tidak digunakan dalam project ini karena ingin fokus ke insight insight operational, sales, perilaku customer. Dataset dataset yang ada tetap memuat asal kota dan provinsi, sehingga tetap bisa digunakan untuk analisis tanpa menggabungkan dataset geolocation