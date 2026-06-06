# ✦ Honkai Star Retail

Aplikasi toko galaktik berbasis Flutter untuk membeli berbagai *galactic resources* dan *light cones* dari dunia Honkai Star Rail.

> UAP Final Project — Mobile Hybrid Solution (COSC6094)

---

## Tech Stack

| Layer | Teknologi |
|-------|-----------|
| Mobile | Flutter SDK 3.32.2 |
| Backend | Node.js 22.16.0 + Express.js |
| Database | MySQL via XAMPP |
| Auth | JWT-style Bearer Token + Google OAuth |
| Target | Android SDK API 35 |

---

## Struktur Folder

```
honkai-star-retail/
├── backend/
│   ├── config/db.js          # Koneksi MySQL
│   ├── middleware/auth.js    # Verifikasi bearer token
│   ├── routes/
│   │   ├── auth.js           # Login, Google OAuth, Logout
│   │   ├── resources.js      # CRUD resource
│   │   └── transactions.js   # Beli & riwayat transaksi
│   ├── .env                  # Konfigurasi environment
│   ├── index.js              # Entry point
│   └── package.json
│
├── frontend/
│   └── lib/
│       ├── constants.dart    # Tema, warna, base URL
│       ├── main.dart         # Entry point Flutter
│       ├── models/           # UserModel, ResourceModel, TransactionModel
│       ├── services/         # AuthService, ResourceService, TransactionService
│       └── pages/
│           ├── login_page.dart
│           ├── home_page.dart
│           ├── resource_list_page.dart
│           ├── resource_detail_page.dart
│           ├── transaction_history_page.dart
│           ├── profile_page.dart
│           └── admin/
│               ├── admin_resource_page.dart
│               └── admin_form_page.dart
│
└── docs/
    ├── honkai_star_retail.sql   # Schema + seed data
    └── DOKUMENTASI.md           # Dokumentasi lengkap
```

---

## Cara Menjalankan

### 1. Setup Database

- Pastikan **XAMPP** sudah berjalan (Apache + MySQL aktif)
- Buka **phpMyAdmin** → `http://localhost/phpmyadmin`
- Buat database baru bernama `honkai_star_retail`
- Import file `docs/honkai_star_retail.sql`

### 2. Jalankan Backend

```bash
cd backend
cp .env.example .env
npm install
node index.js
```

Server akan berjalan di `http://localhost:3000`

> Jika MySQL XAMPP kamu menggunakan password, sesuaikan `DB_PASSWORD` di file `.env`

### 3. Jalankan Flutter

```bash
cd frontend

# Sesuaikan baseUrl di lib/constants.dart:
# Emulator  → http://10.0.2.2:3000/api   (sudah default)
# Device    → http://<IP_KOMPUTER>:3000/api

flutter pub get
flutter run
```

> **Font Rajdhani** perlu didownload dari [Google Fonts](https://fonts.google.com/specimen/Rajdhani) dan disimpan ke `frontend/assets/fonts/`

> **Google Sign In** memerlukan `google-services.json` dari Firebase Console dan Google Client ID yang valid di `constants.dart`

---

## Akun Demo

| Role | Username | Password |
|------|----------|----------|
| Admin | `admin` | `password123` |
| User | `user1` | `password123` |
| User | `user2` | `password123` |

---

## API Endpoints

### Auth
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/auth/login` | Login username & password |
| POST | `/api/auth/google` | Login Google OAuth |
| POST | `/api/auth/logout` | Logout & hapus token |

### Resources
| Method | Endpoint | Auth | Role |
|--------|----------|------|------|
| GET | `/api/resources` | Bearer | Semua |
| GET | `/api/resources/:id` | Bearer | Semua |
| POST | `/api/resources` | Bearer | Admin |
| PUT | `/api/resources/:id` | Bearer | Admin |
| DELETE | `/api/resources/:id` | Bearer | Admin |

### Transactions
| Method | Endpoint | Auth | Role |
|--------|----------|------|------|
| GET | `/api/transactions` | Bearer | User |
| POST | `/api/transactions/buy` | Bearer | User |

---

## Fitur Utama

**Role Admin**
- Tambah resource baru
- Edit resource yang ada
- Hapus resource

**Role User**
- Lihat daftar resource dengan filter tipe
- Lihat detail resource
- Beli resource (bisa lebih dari 1 item)
- Lihat riwayat pembelian

**Autentikasi**
- Login dengan username/password dari database
- Login dengan Google OAuth
- Bearer token 30 karakter alphanumeric
- Token disimpan di database & SharedPreferences

---

## Halaman Aplikasi

| # | Halaman | Deskripsi |
|---|---------|-----------|
| 1 | Login | Form login + tombol Google |
| 2 | Home | Container BottomNavigationBar |
| 3 | Resource List | Daftar item + dropdown filter |
| 4 | Resource Detail | Detail + dialog beli |
| 5 | Transaction History | Riwayat transaksi user |
| 6 | Profile | Info akun + logout |
| 7 | Admin Manage | Kelola resource (admin) |
| 8 | Admin Form | Form tambah / edit resource |

---

## UI Design

Tema **Dark Space / Galactic** konsisten dengan nuansa Honkai Star Rail:

- **Background**: `#1A1A2E` (Dark Navy)
- **Card**: `#1E2A3A`
- **Accent**: `#4FC3F7` (Stellar Blue)
- **Price/Gold**: `#FFD700`
- **Font**: Rajdhani (Regular, SemiBold, Bold)

---

## Dependencies

### Backend
```
express, mysql2, nanoid, google-auth-library, cors, dotenv
```

### Flutter
```
http, google_sign_in, shared_preferences
```
