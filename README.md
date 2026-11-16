# MyPortfolio Mobile

Aplikasi mobile Flutter untuk portofolio pribadi saya. Aplikasi ini adalah klien mobile dari website portofolio Django saya ([Fathir-athaa/myportofolio](https://github.com/Fathir-athaa/myportofolio)) dan dikerjakan untuk mata kuliah Pemrograman Berbasis Platform (PBP), Semester Gasal 2026/2027.

## Identitas

| NPM | Nama | Kelas |
|---|---|---|
| 2506656734 | Fathir Atha Rizki Tasril | PBP A |

## Fitur

- **Kartu profil (InfoCard):** tiga kartu di bagian atas halaman yang menampilkan NPM, nama, dan kelas.
- **Menu aksi (ItemCard):** tiga tombol berikon, masing-masing dengan warna latar berbeda:
  - **Lihat Experience** (biru)
  - **Tambah Experience** (hijau)
  - **Logout** (merah)
- **SnackBar:** saat tombol ditekan, muncul pesan "Kamu telah menekan tombol [Nama Tombol]!".

## Struktur Proyek

```
myportofolio_mobile/
├── android/                # Proyek pembungkus native Android (Gradle, Manifest)
├── ios/                    # Proyek pembungkus native iOS (Xcode)
├── lib/                    # Kode utama aplikasi (Dart)
│   ├── main.dart           # Titik masuk aplikasi: MyApp, MaterialApp, dan tema warna
│   └── menu.dart           # Halaman utama (MyHomePage), InfoCard, ItemHomepage, ItemCard
├── linux/                  # Proyek pembungkus native Linux
├── macos/                  # Proyek pembungkus native macOS
├── test/
│   └── widget_test.dart    # Widget test bawaan dari flutter create
├── web/                    # Berkas web (index.html, ikon, manifest) untuk flutter run -d chrome
├── windows/                # Proyek pembungkus native Windows
├── analysis_options.yaml   # Aturan lint yang dipakai flutter analyze (flutter_lints)
├── pubspec.yaml            # Info proyek, versi SDK, dan dependency
├── pubspec.lock            # Versi pasti dependency yang terpasang
└── README.md               # Dokumentasi proyek
```

## Cara Menjalankan

Prasyarat: Flutter SDK 3.47.9 (Dart 3.13.7) dan Google Chrome.

```bash
git clone https://github.com/Fathir-athaa/myportofolio_mobile.git
cd myportofolio_mobile
flutter pub get
flutter run -d chrome
```

Untuk memeriksa kualitas kode:

```bash
flutter analyze
```

## Progres Mingguan

| Minggu | Tugas | Progres |
|---|---|---|
| Tutorial 08 | Basic Flutter | Setup Flutter SDK, membuat proyek, memisahkan `menu.dart` dari `main.dart`, mengubah `MyHomePage` menjadi StatelessWidget, membuat InfoCard, ItemCard, dan SnackBar. |
| Tugas 7 | Basic Flutter (individu) | Menambahkan atribut `color` pada model `ItemHomepage` supaya tiap tombol punya warna latar berbeda, menulis README dan jawaban pertanyaan reflektif. |

## AI Disclosure

**Tools yang digunakan:** Claude AI

**Bagian yang dibantu AI:**
- Draf README ini dan draf jawaban pertanyaan reflektif, yang kemudian saya baca dan sesuaikan.

**Verifikasi dan perbaikan manual:**
- Menjalankan `flutter analyze` sampai hasilnya `No issues found!`.
- Instalasi Flutter SDK di Windows: ekstrak SDK ke `C:\src\flutter`, menambahkan PATH, dan membaca hasil `flutter doctor`.
- Kode `lib/main.dart` dan `lib/menu.dart` (InfoCard, ItemCard, SnackBar), termasuk penambahan atribut `color` pada `ItemHomepage` untuk Tugas 7.


## Pertanyaan Reflektif

### Tugas 7

1. **Widget tree dan hubungan parent-child**

   Di Flutter, seluruh tampilan disusun dari widget, dan widget-widget itu tersusun bertingkat membentuk pohon yang disebut *widget tree*. Setiap widget bisa punya satu anak (`child`) atau banyak anak (`children`). Di aplikasi ini, susunannya kurang lebih `MyApp → MaterialApp → MyHomePage → Scaffold → Padding → Column → Row → InfoCard`, dan cabang lainnya `Column → Center → Column → GridView → ItemCard`.

   Hubungan parent-child bekerja dengan prinsip *constraints go down, sizes go up, parent sets position*:
   - Parent memberi batasan ukuran (constraints) kepada child. Contohnya, `Padding` mengurangi ruang yang tersedia untuk `Column` sebesar 16 piksel di setiap sisi.
   - Child menentukan ukurannya sendiri di dalam batasan itu, lalu melaporkannya ke parent.
   - Parent menentukan posisi child. Contohnya, `Row` dengan `MainAxisAlignment.spaceEvenly` membagi jarak tiga InfoCard secara merata.

   Data juga mengalir dari atas ke bawah. `MyHomePage` mengirim `npm`, `nama`, dan `kelas` ke `InfoCard` lewat konstruktor, dan `ItemCard` menerima objek `ItemHomepage`. Widget di bawah juga bisa membaca data dari ancestor-nya lewat `BuildContext`, misalnya `Theme.of(context)`. Kalau sebuah parent di-rebuild, seluruh subtree di bawahnya ikut dibangun ulang.

2. **Widget yang digunakan dan fungsinya**

   | Widget | Fungsi di proyek ini |
   |---|---|
   | `MyApp` | Root widget buatan sendiri (StatelessWidget) yang mengembalikan `MaterialApp`. |
   | `MaterialApp` | Menyediakan fondasi Material Design: judul aplikasi, tema warna (`ThemeData` + `ColorScheme.fromSeed`), dan halaman awal (`home`). |
   | `MyHomePage` | Halaman utama (StatelessWidget) yang menyusun seluruh isi halaman. |
   | `Scaffold` | Kerangka halaman Material yang menyediakan slot `appBar` dan `body`, sekaligus tempat SnackBar ditampilkan. |
   | `AppBar` | Bar di bagian atas halaman yang menampilkan judul "MyPortfolio". |
   | `Text` | Menampilkan teks: judul, label dan isi InfoCard, pesan sambutan, nama tombol, dan isi SnackBar. |
   | `Padding` | Memberi jarak di sekitar child, misalnya padding 16 piksel di body dan jarak antara ikon dan teks pada ItemCard. |
   | `Column` | Menyusun child secara vertikal, misalnya isi body dan isi InfoCard. |
   | `Row` | Menyusun tiga InfoCard secara horizontal. |
   | `SizedBox` | Memberi jarak kosong dengan ukuran tetap, misalnya jarak 16 piksel di bawah InfoCard. |
   | `Center` | Menempatkan child di tengah, misalnya bagian sambutan dan isi ItemCard. |
   | `GridView.count` | Menampilkan tombol menu dalam kisi 3 kolom. `shrinkWrap: true` membuat tingginya menyesuaikan isi. |
   | `InfoCard` | Widget buatan sendiri untuk kartu profil (NPM, Name, Class). |
   | `Card` | Kartu Material dengan bayangan (elevation) yang menjadi dasar InfoCard. |
   | `Container` | Mengatur lebar InfoCard (lebar layar dibagi 3,5) dan padding isi kartu. |
   | `ItemCard` | Widget buatan sendiri untuk tombol menu, dibangun dari model `ItemHomepage`. |
   | `Material` | Memberi warna latar (`item.color`) dan sudut membulat pada ItemCard, serta menjadi permukaan untuk efek ripple. |
   | `InkWell` | Membuat kartu bisa ditekan (`onTap`) dan menampilkan efek ripple. |
   | `Icon` | Menampilkan ikon tombol (work, add_circle, logout). |
   | `ScaffoldMessenger` | Mengelola SnackBar: `hideCurrentSnackBar()` menutup SnackBar lama, `showSnackBar()` menampilkan yang baru. |
   | `SnackBar` | Pesan singkat di bawah layar: "Kamu telah menekan tombol [Nama Tombol]!". |
   | `MediaQuery` | Dibaca lewat `MediaQuery.of(context)` untuk mendapatkan lebar layar saat menghitung lebar InfoCard. |
   | `Theme` | Dibaca lewat `Theme.of(context)` untuk mengambil warna primary pada AppBar. |

   `ItemHomepage` bukan widget, melainkan model data biasa yang menyimpan nama, ikon, dan warna setiap tombol.

3. **Fungsi `MaterialApp` dan alasan dipakai sebagai root**

   `MaterialApp` adalah widget pembungkus yang menyiapkan semua yang dibutuhkan aplikasi bergaya Material Design:
   - **Tema:** `theme` menentukan warna dan gaya global. Di aplikasi ini temanya `ColorScheme.fromSeed(seedColor: Colors.indigo)`.
   - **Navigasi:** menyediakan `Navigator` dan pengaturan rute, dengan halaman awal di `home`.
   - **Layanan lain:** menyediakan `MediaQuery`, `ScaffoldMessenger`, lokalisasi, arah teks, dan `title` aplikasi.

   `MaterialApp` dipakai sebagai root karena widget Material di bawahnya bergantung pada layanan tersebut. `Scaffold` dan `AppBar` membutuhkan tema dan arah teks, `Theme.of(context)` membaca tema dari `MaterialApp`, dan `ScaffoldMessenger.of(context)` untuk SnackBar juga disediakan olehnya. Dengan menaruhnya di paling atas, seluruh widget tree bisa mengakses layanan itu lewat `BuildContext`.

4. **StatelessWidget vs StatefulWidget**

   - **StatelessWidget** tidak menyimpan state yang bisa berubah. Tampilannya hanya ditentukan oleh data yang diterima lewat konstruktor, dan baru berubah kalau parent-nya membuat ulang widget itu dengan data baru. Strukturnya cukup satu kelas dengan method `build`.
   - **StatefulWidget** dipasangkan dengan objek `State` yang menyimpan data yang bisa berubah selama aplikasi berjalan. Saat `setState()` dipanggil, Flutter menjalankan `build` lagi supaya tampilan sesuai data terbaru. Contohnya `_counter` di aplikasi counter bawaan `flutter create`.

   **Kapan memakai yang mana:**
   - Pilih **StatelessWidget** kalau tampilannya statis atau hanya bergantung pada input. Di proyek ini, `MyHomePage`, `InfoCard`, dan `ItemCard` cukup stateless karena NPM, nama, kelas, dan daftar tombol tidak berubah. SnackBar juga tidak membutuhkan state, karena dikelola oleh `ScaffoldMessenger`.
   - Pilih **StatefulWidget** kalau widget perlu mengingat dan mengubah data sendiri, misalnya penghitung, input form, checkbox, data hasil request API, animasi, atau timer. Juga kalau butuh siklus hidup seperti `initState()` dan `dispose()`.

   StatelessWidget lebih sederhana dan ringan, jadi sebaiknya dipakai sebagai pilihan awal. StatefulWidget dipakai hanya jika memang ada state lokal yang berubah.

5. **BuildContext**

   `BuildContext` adalah penanda posisi sebuah widget di dalam widget tree. Secara teknis, ini adalah *element* milik widget tersebut. Setiap method `build(BuildContext context)` menerima context miliknya sendiri.

   Context penting karena dipakai untuk mencari data dan layanan dari ancestor di atasnya. Di proyek ini, context dipakai di tiga tempat:
   - `Theme.of(context).colorScheme.primary` untuk mengambil warna tema pada AppBar.
   - `MediaQuery.of(context).size.width` untuk menghitung lebar InfoCard sesuai lebar layar.
   - `ScaffoldMessenger.of(context)` di `onTap` ItemCard untuk menampilkan SnackBar.

   Karena pencarian dimulai dari posisi context, context yang dipakai harus berada di bawah widget yang dicari. Contohnya, `ScaffoldMessenger.of(context)` hanya berhasil jika context-nya berada di bawah `MaterialApp`. Itulah sebabnya ItemCard bisa menampilkan SnackBar.

6. **Hot reload vs hot restart**

   - **Hot reload** (tekan `r`) menyuntikkan kode Dart yang berubah ke aplikasi yang sedang berjalan, lalu membangun ulang widget tree. **State tetap dipertahankan**, jadi cocok untuk perubahan tampilan seperti warna, teks, atau padding.
   - **Hot restart** (tekan `R`) mengompilasi ulang dan menjalankan aplikasi dari awal, mulai dari `main()`. **Semua state di-reset**, tapi prosesnya tetap lebih cepat daripada menjalankan ulang `flutter run`.
   - **Full restart** (hentikan dengan `q`, lalu `flutter run` lagi) membangun ulang aplikasi sepenuhnya, termasuk bagian native.

   Hot reload tidak cukup dan perlu **hot restart** kalau:
   - mengubah kode yang hanya dijalankan sekali saat start, seperti `main()`, `initState()`, atau nilai awal variabel global dan static;
   - mengubah jenis atau struktur kelas, misalnya StatefulWidget menjadi StatelessWidget seperti yang saya lakukan di Tutorial 08, atau mengubah enum dan tipe generic;
   - ingin mengembalikan aplikasi ke state awal.

   Perlu **full restart** kalau:
   - menambah atau mengubah dependency di `pubspec.yaml`, atau menambah aset baru;
   - mengubah kode native (folder `android/`, `ios/`, `web/`) atau konfigurasi build.
