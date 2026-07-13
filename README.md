# 📱 BookLap

BookLap adalah aplikasi mobile berbasis Flutter yang digunakan untuk melakukan pencatatan penyewaan lapangan olahraga secara sederhana. Aplikasi ini dibuat sebagai proyek akhir mata kuliah Mobile Programming Semester 4.

## ✨ Fitur

- Login
- Registrasi akun
- Menampilkan daftar booking
- Menambah booking
- Mengubah data booking
- Menghapus booking
- Menampilkan status booking
- Database lokal menggunakan SQLite

## 🛠️ Teknologi

- Flutter
- Dart
- SQLite (sqflite)
- Shared Preferences
- Android Studio
- Visual Studio Code

## 📂 Database

Aplikasi menggunakan database lokal SQLite dengan dua tabel.

### Tabel Users

| Kolom | Tipe |
|-------|------|
| id | INTEGER |
| username | TEXT |
| password | TEXT |

### Tabel Bookings

| Kolom | Tipe |
|-------|------|
| id | INTEGER |
| nama | TEXT |
| lapangan | TEXT |
| jam | TEXT |
| durasi | TEXT |
| status | TEXT |

## 📱 Tampilan Aplikasi

- Login
- Registrasi
- Dashboard Booking
- Tambah Booking
- Edit Booking

## 🚀 Cara Menjalankan

1. Clone repository ini.

```bash
git clone https://github.com/Kuduup/Booklap.git
```

2. Masuk ke folder project.

```bash
cd Booklap
```

3. Install dependency.

```bash
flutter pub get
```

4. Jalankan aplikasi.

```bash
flutter run
```

## 👨‍💻 Dibuat Oleh

**Suryadi**

Proyek Akhir Mata Kuliah **Mobile Programming** Semester 4.
