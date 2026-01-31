# Platform E-learning Belajarmas

Aplikasi web e-learning yang modern dan responsif, dibangun menggunakan HTML murni, JavaScript (ES Modules), dan Tailwind CSS, serta didukung oleh Supabase untuk layanan backend.
aplikasi ini dibuat untuk memenuhi tugas Mata Kuliah Pemrograman Berbasis Web PJJ-SI Universitas Siber Asia oleh Supardi Akhiyat.

## Teknologi yang Digunakan

*   **Frontend**:
    *   **HTML5**: Markup yang semantik dan aksesibel.
    *   **CSS3**: Dikonfigurasi dengan [Tailwind CSS](https://tailwindcss.com/) (v4).
    *   **JavaScript**: Vanilla ES Modules (Tanpa bundler untuk logika).
    *   **Ikon**: [FontAwesome](https://fontawesome.com/).
    *   **Font**: Google Fonts (Inter, Outfit).

*   **Backend & Layanan**:
    *   **[Supabase](https://supabase.com/)**:
        *   **Autentikasi**: Masuk dan pendaftaran menggunakan Email/Kata Sandi.
        *   **Database**: PostgreSQL untuk menyimpan pengguna, pelajaran, progres, dan tugas.
        *   **Penyimpanan (Storage)**: Bucket untuk thumbnail pelajaran dan konten video.
    *   **Video**: Pemutar Video HTML5.
    *   **Audio**: Pemutar Audio HTML5.

## Memulai

Ikuti instruksi ini untuk mengatur dan menjalankan proyek secara lokal.

### Prasyarat

*   **Node.js** (v18 atau lebih baru) & **npm**: Diperlukan untuk mengompilasi Tailwind CSS dan menjalankan server lokal.
*   Proyek **Supabase** .

### Instalasi

1.  **Clone repositori**
    ```bash
    git clone https://github.com/username-anda/elearning.git
    cd elearning
    ```

2.  **Instal Dependensi**
    Proyek ini menggunakan `npm` untuk mengelola Tailwind CSS CLI.
    ```bash
    npm install
    ```

### Konfigurasi

1.  **Pengaturan Supabase**
    Proyek ini saat ini dikonfigurasi dengan instance Supabase demo/pengembangan di `assets/js/supabaseClient.js`.

    Untuk menggunakan proyek Supabase:
    *   Buat proyek di [supabase.com](https://supabase.com).
    *   Jalankan skrip SQL yang disediakan (di editor SQL) untuk mengatur skema database:
        *   `db_schema.sql` (Pembuatan Skema)
        *   `policies.sql` (Kebijakan Keamanan Tingkat Baris / RLS)
    *   Perbarui `assets/js/supabaseClient.js` dengan URL proyek dan Kunci Anon Anda:
        ```javascript
        const SUPABASE_URL = 'URL_SUPABASE_ANDA';
        const SUPABASE_KEY = 'KUNCI_ANON_SUPABASE_ANDA';
        ```

### Menjalankan Aplikasi

1.  **Build CSS**
    Kompilasi gaya Tailwind CSS. Jalankan perintah ini setiap kali membuat perubahan pada kelas HTML.
    ```bash
    npm run build:css
    ```
    *Untuk memantau perubahan secara terus-menerus selama pengembangan:*
    ```bash
    npx @tailwindcss/cli -i ./assets/css/input.css -o ./assets/css/style.css --watch
    ```

2.  **Jalankan Server Lokal**
    Perintah ini menjalankan aplikasi menggunakan `npx serve`.
    ```bash
    npm start
    ```
    Buka browser dan navigasikan ke `http://localhost:3000` (atau port yang ditampilkan di terminal).

## Struktur Proyek

```
elearning/
├── assets/
│   ├── css/
│   │   ├── input.css       # Titik masuk Tailwind
│   │   └── style.css       # Output yang dikompilasi
│   ├── js/
│   │   ├── auth.js         # Logika autentikasi
│   │   ├── components.js   # Komponen UI
│   │   └── supabaseClient.js # Konfigurasi Supabase
│   └── images/
├── index.html              # Halaman beranda
├── login.html              # Halaman masuk
├── register.html           # Halaman pendaftaran
├── student-dashboard.html  # Tampilan utama siswa
├── teacher-dashboard.html  # Tampilan utama guru
├── manage-lessons.html     # Manajemen pelajaran (Guru)
├── assignments.html        # Tampilan tugas
└── ...
```

## Fitur

*   **Akses Berbasis Peran**: Dasbor terpisah untuk Siswa dan Guru.
*   **Manajemen Pelajaran**: Guru dapat membuat, mengedit, dan menghapus pelajaran.
*   **Pelacakan Progres**: Siswa dapat melacak status penyelesaian kursus mereka.
*   **Tugas**: Sistem untuk mendistribusikan dan melihat latihan.
*   **Desain Responsif**: Sepenuhnya dioptimalkan untuk seluler, tablet, dan desktop.
*   **Dukungan Multi-bahasa**: Antarmuka sepenuhnya diterjemahkan ke dalam Bahasa Indonesia.
