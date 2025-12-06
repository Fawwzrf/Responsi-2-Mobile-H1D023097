# Responsi 2 Mobile Programming - Inventaris Komputer

Aplikasi *mobile* berbasis **Flutter** untuk manajemen inventaris barang (Komputer & Aksesoris), yang terintegrasi dengan backend **REST API CodeIgniter 4**. Aplikasi ini dibuat untuk memenuhi tugas Responsi 2 Mata Kuliah Mobile Programming.

## 👤 Identitas Praktikan
* **Nama:** Fawwaz Aufa Al Ghautsa Rafi
* **NIM:** H1D023097
* **Shift Baru:** Shift E
* **Shift Asal:** Shift I
* **Tema:** Grey (Abu-abu) - Clean Minimalist

## 📱 Fitur Utama
Aplikasi ini memiliki fitur lengkap CRUD dengan antarmuka yang modern:

1.  **Autentikasi Pengguna:**
    * **Login & Registrasi:** Menggunakan token based authentication sederhana.
    * **UI Modern:** Desain *floating card* dengan *gradient background*.
2.  **Manajemen Inventaris (CRUD):**
    * **Create:** Menambah data barang (Nama, Harga, Jumlah, Tanggal Masuk).
    * **Read:** Menampilkan daftar barang dengan indikator stok dan format mata uang Rupiah.
    * **Update:** Mengubah data barang yang sudah ada.
    * **Delete:** Menghapus data barang dengan konfirmasi dialog.
3.  **Fitur Tambahan (Enhancements):**
    * **Pencarian (Search):** Mencari barang secara *real-time* di halaman utama.
    * **Date Picker:** Input tanggal masuk menggunakan kalender interaktif.
    * **Format Rupiah:** Harga otomatis diformat ke mata uang IDR (Contoh: Rp 15.000.000).
    * **Action Bar Custom:** Menampilkan nama praktikan ("Fawwaz") di header aplikasi.

---

## 🛠️ Teknologi yang Digunakan
* **Frontend:** Flutter SDK (Dart)
* **Backend:** CodeIgniter 4 (PHP)
* **Database:** MySQL
* **Tools:** VS Code, Laragon / XAMPP, Postman.

---

## ⚙️ Cara Instalasi & Menjalankan

### 1. Setup Backend (CodeIgniter 4)
1.  Pastikan ekstensi `intl` pada PHP sudah aktif (Wajib untuk CI4).
2.  Buat database di MySQL dengan nama `responsi_fawwaz`.
3.  Jalankan *query* SQL berikut untuk membuat tabel:
    ```sql
    CREATE TABLE member (
        id INT(11) AUTO_INCREMENT PRIMARY KEY,
        nama VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        password VARCHAR(255) NOT NULL
    );

    CREATE TABLE member_token (
        id INT(11) AUTO_INCREMENT PRIMARY KEY,
        member_id INT(11) NOT NULL,
        auth_key VARCHAR(255) NOT NULL,
        FOREIGN KEY (member_id) REFERENCES member(id)
    );

    CREATE TABLE barang (
        id INT(11) AUTO_INCREMENT PRIMARY KEY,
        nama_barang VARCHAR(255) NOT NULL,
        harga INT(11) NOT NULL,
        jumlah INT(11) NOT NULL,
        tanggal_masuk DATE NOT NULL
    );
    ```
4.  Konfigurasi file `.env` pada folder CI4:
    ```env
    database.default.hostname = localhost
    database.default.database = responsi_fawwaz
    database.default.username = root
    database.default.password = 
    database.default.DBDriver = MySQLi
    ```
5.  Jalankan server agar bisa diakses oleh device/emulator:
    ```bash
    php spark serve --host 0.0.0.0
    ```

### 2. Setup Frontend (Flutter)
1.  Buka folder project Flutter di VS Code.
2.  Jalankan perintah untuk mengunduh library:
    ```bash
    flutter pub get
    ```
3.  **PENTING:** Buka file `lib/helpers/api_url.dart` dan sesuaikan IP Address:
    * Jika menggunakan **Emulator Android Studio**: Gunakan `http://10.0.2.2:8080`
    * Jika menggunakan **HP Fisik**: Gunakan IP Laptop (Cek `ipconfig`), contoh: `http://192.168.1.10:8080`
4.  Jalankan aplikasi:
    ```bash
    flutter run
    ```

---

## 📡 Spesifikasi API
Berikut adalah endpoint yang dibuat di CodeIgniter 4:

| Method | Endpoint | Deskripsi | Parameter Body |
| :--- | :--- | :--- | :--- |
| **POST** | `/registrasi` | Mendaftarkan akun baru | `nama`, `email`, `password` |
| **POST** | `/login` | Masuk aplikasi | `email`, `password` |
| **GET** | `/barang` | Mengambil semua data barang | - |
| **POST** | `/barang` | Menambah barang baru | `nama_barang`, `harga`, `jumlah`, `tanggal_masuk` |
| **GET** | `/barang/{id}` | Melihat detail barang | - |
| **PUT** | `/barang/{id}` | Mengupdate data barang | `nama_barang`, `harga`, `jumlah`, `tanggal_masuk` |
| **DELETE** | `/barang/{id}` | Menghapus barang | - |

---

## 📂 Penjelasan Struktur Kode

1.  **`lib/helpers/api_url.dart`**: Menyimpan konfigurasi Base URL agar IP Address mudah diganti di satu tempat saja tanpa mengubah banyak file.
2.  **`lib/helpers/currency_format.dart`**: *Utility class* untuk mengubah format `integer` menjadi format mata uang Rupiah (IDR).
3.  **`lib/model/barang.dart`**: Representasi objek data Barang untuk *mapping* dari format JSON API ke format Dart Object.
4.  **`lib/ui/login_page.dart` & `registrasi_page.dart`**: Menangani otentikasi user dengan desain UI *Gradient* dan validasi input.
5.  **`lib/ui/barang_page.dart`**: Halaman utama yang memuat `ListView`, fitur pencarian (*Search*), dan tombol navigasi.
6.  **`lib/ui/barang_form.dart`**: Form *reusable* untuk Tambah dan Edit data. Menggunakan `DatePicker` untuk input tanggal.
7.  **`lib/ui/barang_detail.dart`**: Menampilkan detail lengkap barang dengan tampilan *Dashboard Card*.

---

## 🎥 Demo Aplikasi
Berikut adalah link video demo penggunaan aplikasi:


https://github.com/user-attachments/assets/569fd032-4a68-4377-9302-d1a0bafaa02d



---

*Dibuat untuk memenuhi tugas praktikum Mobile Programming.*

