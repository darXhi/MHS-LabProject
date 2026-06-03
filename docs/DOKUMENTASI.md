# Dokumentasi Proyek: Honkai Star Retail
## UAP - Mobile Hybrid Solution (COSC6094)

---

## 1. Deskripsi Aplikasi

**Honkai Star Retail** adalah aplikasi toko galaktik berbasis Flutter yang memungkinkan pengguna membeli berbagai *galactic resources* dan *light cones* dari dunia Honkai Star Rail. Terdapat dua peran pengguna:

- **Admin**: dapat menambah, mengubah, dan menghapus resource.
- **User**: dapat melihat dan membeli resource.

---

## 2. Studi Kasus yang Dipilih

**Honkai Star Retail** — Project #1

---

## 3. Struktur Folder Project

```
honkai-star-retail/
├── backend/
│   ├── config/
│   │   └── db.js               # Koneksi database MySQL
│   ├── middleware/
│   │   └── auth.js             # Middleware verifikasi bearer token
│   ├── routes/
│   │   ├── auth.js             # Login, Google OAuth, Logout
│   │   ├── resources.js        # CRUD resource
│   │   └── transactions.js     # Beli item & riwayat transaksi
│   ├── .env                    # Konfigurasi environment
│   ├── index.js                # Entry point backend
│   └── package.json
│
├── frontend/
│   ├── lib/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── resource_model.dart
│   │   │   └── transaction_model.dart
│   │   ├── services/
│   │   │   ├── auth_service.dart
│   │   │   ├── resource_service.dart
│   │   │   └── transaction_service.dart
│   │   ├── pages/
│   │   │   ├── login_page.dart
│   │   │   ├── home_page.dart
│   │   │   ├── resource_list_page.dart
│   │   │   ├── resource_detail_page.dart
│   │   │   ├── transaction_history_page.dart
│   │   │   ├── profile_page.dart
│   │   │   └── admin/
│   │   │       ├── admin_resource_page.dart
│   │   │       └── admin_form_page.dart
│   │   ├── constants.dart      # Warna, tema, base URL
│   │   └── main.dart           # Entry point Flutter
│   ├── assets/
│   │   ├── images/             # Asset gambar resource
│   │   └── fonts/              # Font Rajdhani
│   └── pubspec.yaml
│
└── docs/
    ├── honkai_star_retail.sql  # SQL schema dan seed data
    └── DOKUMENTASI.md          # File ini
```

---

## 4. Struktur Database

### Tabel `users`
| Kolom | Tipe | Keterangan |
|-------|------|-----------|
| id | INT AUTO_INCREMENT | Primary key |
| username | VARCHAR(100) | Unik |
| email | VARCHAR(150) | Unik |
| password | VARCHAR(255) | Hashed bcrypt |
| role | ENUM('admin','user') | Role pengguna |
| google_id | VARCHAR(255) | ID dari Google OAuth |
| created_at | TIMESTAMP | Waktu dibuat |

### Tabel `resources`
| Kolom | Tipe | Keterangan |
|-------|------|-----------|
| id | INT AUTO_INCREMENT | Primary key |
| name | VARCHAR(150) | Nama resource |
| type | VARCHAR(100) | Tipe (Galactic Resource / Light Cone) |
| description | TEXT | Deskripsi |
| stock | INT | Jumlah stok |
| image | VARCHAR(255) | Nama file gambar |
| price | DECIMAL(15,2) | Harga |
| created_at | TIMESTAMP | Waktu dibuat |
| updated_at | TIMESTAMP | Waktu diupdate |

### Tabel `user_tokens`
| Kolom | Tipe | Keterangan |
|-------|------|-----------|
| id | INT AUTO_INCREMENT | Primary key |
| user_id | INT | FK ke users.id |
| token | VARCHAR(100) | Bearer token (min 20 char) |
| created_at | TIMESTAMP | Waktu dibuat |

### Tabel `transactions`
| Kolom | Tipe | Keterangan |
|-------|------|-----------|
| id | INT AUTO_INCREMENT | Primary key |
| user_id | INT | FK ke users.id |
| resource_id | INT | FK ke resources.id |
| quantity | INT | Jumlah yang dibeli |
| total_price | DECIMAL(15,2) | Total harga |
| created_at | TIMESTAMP | Waktu transaksi |

---

## 5. Daftar Endpoint API

### Auth

| Method | Endpoint | Deskripsi | Auth |
|--------|----------|-----------|------|
| POST | /api/auth/login | Login dengan username/password | ❌ |
| POST | /api/auth/google | Login dengan Google OAuth | ❌ |
| POST | /api/auth/logout | Logout & hapus token | Bearer |

### Resources

| Method | Endpoint | Deskripsi | Auth |
|--------|----------|-----------|------|
| GET | /api/resources | Ambil semua resource | Bearer (User/Admin) |
| GET | /api/resources/:id | Ambil detail satu resource | Bearer (User/Admin) |
| POST | /api/resources | Tambah resource baru | Bearer (Admin only) |
| PUT | /api/resources/:id | Update resource | Bearer (Admin only) |
| DELETE | /api/resources/:id | Hapus resource | Bearer (Admin only) |

### Transactions

| Method | Endpoint | Deskripsi | Auth |
|--------|----------|-----------|------|
| GET | /api/transactions | Riwayat transaksi user | Bearer |
| POST | /api/transactions/buy | Beli resource | Bearer |

---

## 6. Halaman Flutter (Pages)

| No | Halaman | Deskripsi |
|----|---------|-----------|
| 1 | `LoginPage` | Halaman login (username/password & Google OAuth) |
| 2 | `HomePage` | Container dengan BottomNavigationBar |
| 3 | `ResourceListPage` | Daftar resource dengan filter dropdown |
| 4 | `ResourceDetailPage` | Detail resource + tombol beli (user) |
| 5 | `TransactionHistoryPage` | Riwayat pembelian user |
| 6 | `ProfilePage` | Info profil & logout |
| 7 | `AdminResourcePage` | Daftar resource untuk admin (edit/delete) |
| 8 | `AdminFormPage` | Form tambah / edit resource |

---

## 7. UI Components yang Digunakan (≥5 jenis)

| No | Komponen | Digunakan Di |
|----|----------|-------------|
| 1 | `TextField` / `TextFormField` | Login, AdminFormPage |
| 2 | `ElevatedButton` / `OutlinedButton` | Login, Detail, Profile |
| 3 | `Card` | ResourceList, TransactionHistory, AdminResource |
| 4 | `ListView.builder` | ResourceList, TransactionHistory, AdminResource |
| 5 | `DropdownButton` / `DropdownButtonFormField` | Filter type, AdminFormPage |
| 6 | `Dialog` / `AlertDialog` | Buy Dialog, Confirm Delete, Logout confirm |
| 7 | `BottomNavigationBar` | HomePage |
| 8 | `AppBar` | Semua halaman |
| 9 | `SnackBar` | Feedback aksi (beli, hapus, error) |
| 10 | `CircularProgressIndicator` | Loading state |

---

## 8. Validasi Data (≥3 jenis)

| No | Validasi | Lokasi | Pesan Error |
|----|----------|--------|-------------|
| 1 | Field tidak boleh kosong | LoginPage, AdminFormPage | "...tidak boleh kosong" |
| 2 | Password minimal 6 karakter | LoginPage | "Password minimal 6 karakter" |
| 3 | Stok harus angka & tidak negatif | AdminFormPage | "Stok harus berupa angka" / "Stok tidak boleh negatif" |
| 4 | Harga tidak boleh negatif | AdminFormPage | "Harga tidak boleh negatif" |
| 5 | Quantity beli harus > 0 & tidak melebihi stok | BuyDialog | "Jumlah harus lebih dari 0" / "Stok tidak cukup" |
| 6 | Nama minimal 3 karakter | AdminFormPage | "Nama minimal 3 karakter" |

---

## 9. Fitur Autentikasi

### Login DB
- User memasukkan username/email dan password
- Backend mengecek ke tabel `users` menggunakan bcrypt compare
- Jika berhasil, generate token 30 karakter alphanumeric menggunakan `nanoid`
- Token disimpan di tabel `user_tokens`
- Token dikembalikan ke Flutter dan disimpan di `SharedPreferences`

### Login Google OAuth
- Flutter menggunakan package `google_sign_in`
- Mendapat `idToken` dari Google
- Dikirim ke backend endpoint `/api/auth/google`
- Backend verifikasi menggunakan `google-auth-library`
- Jika user belum ada di DB, otomatis dibuat akun baru
- Token di-generate dan dikembalikan

### Bearer Token
- Format: `Authorization: Bearer <token>`
- Panjang token: 30 karakter alphanumeric (contoh: `n8x7wfqtsrvxnvsm8dczhk1a4b2c3`)
- Semua endpoint `/api/resources` dan `/api/transactions` membutuhkan token
- Middleware `verifyToken` mengecek token ke tabel `user_tokens`

---

## 10. UI Design & Tema

Tema **Dark Space / Galactic** konsisten dengan dunia Honkai Star Rail:

| Properti | Nilai | Keterangan |
|----------|-------|-----------|
| Background Color | `#1A1A2E` (Dark Navy) | Warna dasar aplikasi |
| Card/Surface Color | `#1E2A3A` | Warna card dan komponen |
| Accent Color | `#4FC3F7` (Stellar Blue) | Warna utama & highlight |
| Gold Color | `#FFD700` | Harga, badge admin |
| Font Family | `Rajdhani` | Font konsisten seluruh app |
| Font Size Headings | 22-32px Bold | Judul halaman |
| Font Size Body | 13-16px | Konten umum |

---

## 11. Cara Menjalankan Project

### Prasyarat
- XAMPP (MySQL aktif)
- Node.js 22.16.0
- Flutter SDK 3.32.2
- Android Studio / Android SDK API 35
- Emulator Android atau device fisik

### Setup Backend

```bash
# 1. Import database
# Buka phpMyAdmin → Import → pilih docs/honkai_star_retail.sql

# 2. Install dependencies
cd backend
npm install

# 3. Buat file .env (sudah tersedia, sesuaikan jika perlu)
# Isi DB_PASSWORD jika MySQL XAMPP kamu punya password

# 4. Jalankan server
node index.js
# Server berjalan di http://localhost:3000
```

### Setup Frontend Flutter

```bash
# 1. Masuk folder frontend
cd frontend

# 2. Sesuaikan baseUrl di lib/constants.dart
# Jika pakai emulator: http://10.0.2.2:3000/api  (sudah default)
# Jika pakai device fisik: http://<IP_KOMPUTER>:3000/api

# 3. Install dependencies
flutter pub get

# 4. Download font Rajdhani dari Google Fonts dan simpan di:
#    assets/fonts/Rajdhani-Regular.ttf
#    assets/fonts/Rajdhani-Bold.ttf
#    assets/fonts/Rajdhani-SemiBold.ttf

# 5. Tambahkan google-services.json untuk Google Sign In
#    (sesuaikan dengan project Firebase kamu)

# 6. Jalankan aplikasi
flutter run
```

### Akun Demo

| Role | Username | Password |
|------|----------|----------|
| Admin | admin | password123 |
| User | user1 | password123 |
| User | user2 | password123 |

---

## 12. Package / Dependency yang Digunakan

### Backend (Node.js)

| Package | Versi | Fungsi |
|---------|-------|--------|
| express | ^4.18.2 | Web framework |
| mysql2 | ^3.9.7 | Koneksi MySQL |
| bcrypt | ^5.1.1 | Hash & verifikasi password |
| nanoid | ^3.3.7 | Generate token alphanumeric |
| google-auth-library | ^9.10.0 | Verifikasi Google ID Token |
| cors | ^2.8.5 | Cross-Origin Resource Sharing |
| dotenv | ^16.4.5 | Environment variables |
| nodemon | ^3.1.0 | Auto-restart saat development |

### Frontend (Flutter)

| Package | Versi | Fungsi |
|---------|-------|--------|
| http | ^1.2.1 | HTTP request ke backend |
| google_sign_in | ^6.2.1 | Login dengan Google |
| shared_preferences | ^2.2.3 | Simpan token & data user lokal |

---

## 13. Referensi Asset

| Asset | Sumber |
|-------|--------|
| Font Rajdhani | https://fonts.google.com/specimen/Rajdhani |
| Gambar resource | Placeholder (icon Flutter bawaan) — dapat diganti dengan gambar dari Honkai Star Rail Wiki |
| Icons | Material Icons (bawaan Flutter) |

---

## 14. Catatan Implementasi Penting

1. **Google Sign In**: Memerlukan konfigurasi `google-services.json` dari Firebase Console dan Google OAuth Client ID yang valid. Tanpa konfigurasi ini, fitur Google login tidak akan berfungsi.

2. **Image Resource**: Saat ini menggunakan icon placeholder. Untuk menambahkan gambar asli, simpan file gambar ke `assets/images/` dan sesuaikan nama file dengan field `image` di database.

3. **Base URL**: Pastikan `baseUrl` di `constants.dart` sesuai dengan environment (emulator/device fisik).

4. **XAMPP MySQL**: Pastikan Apache dan MySQL di XAMPP sudah aktif sebelum menjalankan backend.
