# Product Requirements Document (PRD)

## 1. Informasi Dokumen
- Nama Produk: Arsiva Gallery Art
- Versi Dokumen: 1.0
- Tanggal: 30 April 2026
- Status: Draft untuk implementasi MVP
- Pemilik Dokumen: Product Team Arsiva

## 2. Ringkasan Produk
Arsiva Gallery Art adalah aplikasi galeri seni digital untuk menampilkan karya seniman, membantu kolektor menemukan karya, dan memudahkan transaksi pembelian karya seni secara aman.

Fokus tahap awal (MVP) adalah:
- Menampilkan katalog karya seni berkualitas tinggi
- Memberikan profil seniman yang kredibel
- Menyediakan alur pembelian karya yang sederhana
- Menyediakan dashboard admin untuk kurasi dan moderasi konten

## 3. Latar Belakang Masalah
Permasalahan utama di pasar galeri seni digital:
- Sulitnya menemukan karya seni berdasarkan gaya, medium, dan harga
- Kurangnya transparansi informasi karya (keaslian, edisi, kondisi)
- Proses pembelian yang bertele-tele dan tidak konsisten
- Keterbatasan kanal promosi digital bagi seniman independen

Arsiva hadir untuk menyatukan discovery, kredibilitas karya, dan transaksi dalam satu platform.

## 4. Tujuan Produk
### Tujuan Bisnis
- Membangun marketplace seni digital dengan kualitas kurasi tinggi
- Meningkatkan conversion rate dari pengunjung ke pembeli
- Menjadi kanal pendapatan baru bagi seniman dan galeri partner

### Tujuan Pengguna
- Kolektor dapat menemukan karya yang sesuai preferensi dengan cepat
- Seniman dapat menampilkan portofolio dan menjual karya secara profesional
- Pengunjung umum dapat menikmati eksplorasi karya secara visual dan edukatif

## 5. Non-Tujuan (Out of Scope MVP)
- Lelang real-time (live auction)
- Integrasi NFT/on-chain
- Dukungan multi-bahasa penuh
- Fitur komunitas kompleks (forum, komentar panjang, social feed)

## 6. Persona Pengguna
### 1) Kolektor Pemula
- Usia 24-35, tertarik investasi seni
- Butuh penjelasan karya yang mudah dipahami
- Sensitif terhadap harga dan trust

### 2) Kolektor Berpengalaman
- Usia 30-50, rutin membeli karya
- Butuh filter detail, histori seniman, dan transparansi provenance

### 3) Seniman
- Usia 20-45, ingin menjual karya langsung
- Butuh profil profesional, upload karya mudah, insight performa

### 4) Admin Kurator
- Bertanggung jawab atas kualitas konten dan verifikasi karya
- Butuh alat moderasi cepat dan audit log perubahan

## 7. User Journey Utama (MVP)
### Journey A: Discovery ke Pembelian
1. Pengguna membuka beranda dan melihat koleksi pilihan
2. Pengguna melakukan pencarian atau filter (gaya, medium, harga)
3. Pengguna membuka detail karya
4. Pengguna menambahkan karya ke keranjang
5. Pengguna checkout, memilih metode pembayaran, lalu konfirmasi
6. Pengguna menerima invoice dan status pesanan

### Journey B: Seniman Menambah Karya
1. Seniman login
2. Seniman mengisi metadata karya (judul, medium, dimensi, tahun, harga)
3. Seniman upload foto karya resolusi tinggi
4. Admin menerima notifikasi review karya
5. Setelah disetujui, karya tampil di katalog publik

## 8. Ruang Lingkup Fitur MVP
### A. Aplikasi Pengguna (Web/Mobile Web)
- Registrasi, login, logout
- Katalog karya seni
- Pencarian dan filter
- Halaman detail karya
- Favorit/whishlist
- Keranjang dan checkout
- Riwayat pesanan

### B. Aplikasi Seniman
- Profil seniman
- Manajemen karya (CRUD)
- Status review karya
- Ringkasan performa dasar (view dan favorite)

### C. Admin Panel
- Verifikasi identitas seniman (manual)
- Moderasi konten karya
- Manajemen kategori (gaya, medium)
- Manajemen pesanan dan status pembayaran
- Laporan sederhana (jumlah user, karya aktif, transaksi)

## 9. Kebutuhan Fungsional
### 9.1 Akun dan Autentikasi
- Pengguna dapat mendaftar dengan email dan password
- Pengguna dapat login dan reset password
- Role: `collector`, `artist`, `admin`

### 9.2 Katalog dan Discovery
- Sistem menampilkan daftar karya dengan pagination
- Pengguna dapat filter berdasarkan:
- rentang harga
- medium (acrylic, oil, mixed media, dll)
- style (abstract, realism, contemporary, dll)
- ukuran karya
- status ketersediaan
- Pengguna dapat mengurutkan berdasarkan terbaru, harga, popularitas

### 9.3 Detail Karya
- Menampilkan informasi:
- foto karya (multi-image)
- judul, deskripsi, medium, dimensi, tahun
- harga, status stok
- profil singkat seniman
- Pengguna dapat tambah ke favorit dan keranjang

### 9.4 Checkout dan Pembayaran
- Pengguna dapat melakukan checkout 1 atau lebih karya
- Sistem menghasilkan invoice unik
- Metode pembayaran awal: transfer bank + payment gateway dasar
- Status transaksi: `pending`, `paid`, `failed`, `expired`, `refunded`

### 9.5 Manajemen Karya oleh Seniman
- Seniman dapat membuat, edit, nonaktifkan karya
- Karya baru berstatus `pending_review` sebelum tampil publik
- Admin dapat menyetujui (`approved`) atau menolak (`rejected`) dengan alasan

### 9.6 Admin dan Moderasi
- Admin dapat mengelola user, karya, kategori, transaksi
- Semua aksi moderasi penting tercatat di audit log

## 10. Kebutuhan Non-Fungsional
### 10.1 Performa
- Waktu muat halaman katalog <= 3 detik pada koneksi 4G normal
- API response P95 <= 800 ms untuk endpoint katalog

### 10.2 Keamanan
- Password di-hash (bcrypt/argon2)
- HTTPS wajib di production
- Proteksi dasar: rate limiting, CSRF protection, input validation
- Data pembayaran sensitif tidak disimpan mentah

### 10.3 Ketersediaan dan Reliabilitas
- Target uptime: 99.5% pada fase MVP
- Backup database harian

### 10.4 Skalabilitas
- Arsitektur mendukung penambahan fitur auction dan multi-language di fase berikutnya

## 11. Requirement Data (Entity Utama)
- User: id, name, email, role, status, created_at
- ArtistProfile: user_id, bio, location, portfolio_link, verified_status
- Artwork: id, artist_id, title, description, medium, style, dimension, year, price, stock_status, review_status
- ArtworkImage: id, artwork_id, image_url, order_index
- Favorite: user_id, artwork_id
- CartItem: user_id, artwork_id, qty
- Order: id, user_id, total_amount, payment_status, order_status
- OrderItem: order_id, artwork_id, price_snapshot
- AuditLog: actor_id, action, entity_type, entity_id, metadata, created_at

## 12. Metrik Keberhasilan
### North Star Metric
- Monthly Gross Merchandise Value (GMV)

### KPI MVP (3 bulan awal)
- 1,000 pengguna terdaftar
- 200 karya aktif
- Conversion rate katalog -> checkout >= 2.5%
- Payment success rate >= 90%
- Repeat purchase rate >= 15%

## 13. Analitik dan Event Tracking
Event minimum yang harus dilacak:
- `view_home`
- `search_artwork`
- `filter_artwork`
- `view_artwork_detail`
- `add_to_favorite`
- `add_to_cart`
- `start_checkout`
- `payment_success`
- `payment_failed`
- `artist_submit_artwork`
- `admin_approve_artwork`

## 14. Risiko dan Mitigasi
- Risiko: Konten karya tidak berkualitas
- Mitigasi: Kurasi admin + panduan upload standar foto

- Risiko: Penipuan/transaksi bermasalah
- Mitigasi: Verifikasi seniman, sistem hold status, audit log

- Risiko: Bounce tinggi karena UI berat
- Mitigasi: Optimasi image (lazy load, CDN, responsive image)

## 15. Rencana Rilis
### Milestone
1. Minggu 1-2: Discovery, wireframe, dan finalisasi scope teknis
2. Minggu 3-6: Pengembangan core user flow (katalog, detail, checkout)
3. Minggu 7-8: Admin panel dan moderasi
4. Minggu 9: QA, security check, bug fixing
5. Minggu 10: Soft launch dan monitoring

## 16. Kriteria Penerimaan MVP
- User dapat registrasi, login, dan logout tanpa error kritikal
- Katalog, pencarian, dan filter berfungsi sesuai requirement
- Seniman dapat submit karya dan menunggu review
- Admin dapat approve/reject karya
- Pengguna dapat checkout dan menerima status transaksi
- Dashboard admin menampilkan metrik dasar dan data transaksi

## 17. Pertanyaan Terbuka
- Payment gateway utama yang dipilih untuk go-live?
- Apakah perlu fitur negosiasi harga sejak MVP?
- SLA kurasi karya oleh admin (misal maksimal 2x24 jam)?
- Kebijakan refund dan pengiriman fisik karya akan seperti apa?
