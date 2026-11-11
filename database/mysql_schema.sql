-- =============================================================================
-- Skrip Database MySQL (Local Environment)
-- Proyek: Website Program Magang (Pengembangan Website berbasis Digital Marketing)
-- Kompatibel dengan: MySQL 5.7+, MySQL 8.0+, MariaDB 10.3+ (XAMPP / Laragon)
-- =============================================================================

CREATE DATABASE IF NOT EXISTS `db_magang_digital` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `db_magang_digital`;

-- -----------------------------------------------------------------------------
-- 1. Tabel: site_settings
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `site_settings`;
CREATE TABLE `site_settings` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `site_name` VARCHAR(255) NOT NULL,
  `tagline` VARCHAR(255) NOT NULL,
  `logo_url` VARCHAR(255) DEFAULT 'assets/img/logo-program-magang.webp',
  `favicon_url` VARCHAR(255) DEFAULT 'assets/img/favicon-program-magang.webp',
  `whatsapp_number` VARCHAR(30) NOT NULL DEFAULT '6282225254434',
  `whatsapp_default_message` TEXT,
  `email` VARCHAR(100) DEFAULT 'info@magangdigital.id',
  `phone` VARCHAR(30) DEFAULT '0822-2525-4434',
  `address` TEXT,
  `city` VARCHAR(100) DEFAULT 'Yogyakarta',
  `country` VARCHAR(50) DEFAULT 'Indonesia',
  `seo_title` VARCHAR(255) NOT NULL,
  `seo_description` TEXT NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `site_settings` (`site_name`, `tagline`, `whatsapp_number`, `whatsapp_default_message`, `seo_title`, `seo_description`) 
VALUES (
  'Program Magang Pengembangan Website & Digital Marketing',
  'Belajar Praktik Pembuatan Website Responsif dan Penerapan Digital Marketing',
  '6282225254434',
  'Halo, saya ingin bertanya tentang program magang.',
  'Program Magang Pengembangan Website & Digital Marketing',
  'Program magang berbasis praktik untuk siswa SMK dan mahasiswa. Fokus pengembangan website dan digital marketing untuk 5 jurusan keahlian.'
);

-- -----------------------------------------------------------------------------
-- 2. Tabel: majors (Pilihan 5 Jurusan)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `majors`;
CREATE TABLE `majors` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `abbreviation` VARCHAR(50) NOT NULL,
  `slug` VARCHAR(100) NOT NULL UNIQUE,
  `short_description` TEXT NOT NULL,
  `description` LONGTEXT NOT NULL,
  `competencies` TEXT,
  `activities` TEXT,
  `icon_class` VARCHAR(50) DEFAULT 'bi-laptop',
  `sort_order` INT NOT NULL DEFAULT 0,
  `is_published` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `majors` (`name`, `abbreviation`, `slug`, `short_description`, `description`, `icon_class`, `sort_order`) VALUES
(
  'Informatika',
  'IF',
  'informatika',
  'Fokus pengenalan konsep komputasi, logika pemrograman, alur kerja website modern, pengolahan data sederhana, dan pemecahan masalah algoritma digital.',
  'Membekali siswa dan mahasiswa dengan pemahaman logika komputasi, alur kerja website modern, pengolahan data terstruktur JSON-LD, serta dasar algoritma optimasi mesin pencari Google.',
  'bi-cpu',
  1
),
(
  'Bisnis Digital',
  'BDP',
  'bisnis-digital',
  'Fokus pada proses bisnis daring, riset kebutuhan audiens sasaran, perencanaan kalender konten, dasar SEO, copywriting, dan evaluasi performa pemasaran web.',
  'Membekali peserta dengan kemampuan riset kata kunci, penulisan copywriting landing page persuasif berbasis formula AIDA, strategi SEO on-page, dan perancangan funnel pesan WhatsApp bisnis.',
  'bi-graph-up-arrow',
  2
),
(
  'Desain Komunikasi Visual',
  'DKV / Multimedia',
  'dkv-multimedia',
  'Fokus pada komunikasi visual, prinsip tata letak antarmuka, harmoni tipografi, pengolahan gambar digital, aset grafis website, dan format media WebP.',
  'Peserta mempelajari tata letak UI responsif, pemilihan palet warna berstandar kontras WCAG AA, produksi aset vektor SVG, serta kompresi gambar modern format WebP.',
  'bi-palette',
  3
),
(
  'Rekayasa Perangkat Lunak',
  'RPL',
  'rekayasa-perangkat-lunak',
  'Fokus pada rekayasa teknis kode pembuatan website, penulisan HTML5 semantik, CSS3 modern, JavaScript interaktif, framework Bootstrap 5, dan clean code.',
  'Membekali peserta dengan keahlian koding antarmuka website responsif dari nol menggunakan HTML5 semantik, grid Bootstrap 5, manipulasi DOM JavaScript, dan pengujian kualitas kode.',
  'bi-code-slash',
  4
),
(
  'Teknik Komputer dan Jaringan',
  'TKJ',
  'teknik-komputer-jaringan',
  'Fokus pada lingkungan server web lokal, konfigurasi domain, DNS record, keamanan website dasar, protokol SSL/HTTPS, dan alur publikasi.',
  'Peserta mempraktikkan konfigurasi web server lokal (Apache/Node), pemetaan domain DNS record, instalasi sertifikat SSL/HTTPS, serta monitoring kestabilan akses jaringan.',
  'bi-hdd-network',
  5
);

-- -----------------------------------------------------------------------------
-- 3. Tabel: programs (7 Modul Kurikulum Praktik)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `programs`;
CREATE TABLE `programs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `module_number` INT NOT NULL,
  `title` VARCHAR(150) NOT NULL,
  `slug` VARCHAR(150) NOT NULL UNIQUE,
  `phase` VARCHAR(100) NOT NULL,
  `summary` TEXT NOT NULL,
  `description` LONGTEXT NOT NULL,
  `sort_order` INT NOT NULL DEFAULT 0,
  `is_published` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `programs` (`module_number`, `title`, `slug`, `phase`, `summary`, `description`, `sort_order`) VALUES
(1, 'Perencanaan & Struktur Website', 'perencanaan-dan-struktur-website', 'Tahap Perencanaan', 'Memahami kebutuhan proyek, sitemap, wireframe, dan hierarki navigasi halaman web.', 'Analisis kebutuhan profil dan layanan bisnis, penyusunan tata letak sitemap, serta sketsa wireframe awal.', 1),
(2, 'Dasar Kode & Layout Responsif', 'dasar-kode-dan-layout-responsif', 'Tahap Front-End', 'Penulisan HTML5 semantik, CSS3 modern, flexbox, grid, dan framework Bootstrap 5.', 'Koding struktur semantik HTML5, grid sistem Bootstrap 5 mobile-first, dan kustomisasi variabel CSS.', 2),
(3, 'Visual Antarmuka & Aset Grafis', 'visual-antarmuka-dan-aset-grafis', 'Tahap UI / Visual', 'Penerapan UI design, tipografi, warna berstandar kontras, dan format WebP/SVG.', 'Penataan visual hierarchy, pengolahan gambar format WebP, dan penerapan ikonografi vektor SVG tajam.', 3),
(4, 'Penulisan Konten Web (Copywriting)', 'penulisan-konten-web-copywriting', 'Tahap Konten', 'Menyusun headline memikat, deskripsi manfaat produk/jasa, dan tombol CTA WhatsApp.', 'Formula copywriting landing page AIDA, penulisan pesan promosi terukur, dan template chat WhatsApp.', 4),
(5, 'Dasar Optimasi Mesin Pencari (SEO)', 'dasar-optimasi-mesin-pencari-seo', 'Tahap Pemasaran', 'Penerapan SEO on-page: meta tag, structured data JSON-LD, sitemap, dan heading.', 'Optimasi title tag, meta description, heading H1-H3, Open Graph, dan Schema.org JSON-LD.', 5),
(6, 'Integrasi & Publikasi Sederhana', 'integrasi-dan-publikasi-sederhana', 'Tahap Infrastruktur', 'Setup web server lokal, konfigurasi domain, DNS, dan pengamanan protokol HTTPS.', 'Pengujian situs di environment lokal, dasar domain DNS record, dan sertifikat gembok aman SSL/HTTPS.', 6),
(7, 'Praktik Proyek Nyata & Portofolio', 'praktik-proyek-nyata-dan-portofolio', 'Tahap Evaluasi & Portofolio', 'Penyelesaian proyek website mandiri dan kolaboratif sebagai bukti portofolio resmi.', 'Penggabungan seluruh kompetensi untuk menghasilkan live website yang siap dipamerkan ke dunia kerja.', 7);

-- -----------------------------------------------------------------------------
-- 4. Tabel: testimonials (Testimoni Peserta Magang)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `testimonials`;
CREATE TABLE `testimonials` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `student_name` VARCHAR(100) NOT NULL,
  `school_major` VARCHAR(150) NOT NULL,
  `quote` TEXT NOT NULL,
  `sort_order` INT NOT NULL DEFAULT 0,
  `is_published` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `testimonials` (`student_name`, `school_major`, `quote`, `sort_order`) VALUES
(
  'Rizky Pratama',
  'SMK Jurusan RPL',
  'Selama magang di sini, saya belajar langsung cara membangun website responsif dengan Bootstrap 5 dan JavaScript dari nol. Bimbingan dari mentor sangat intensif dan membuat saya jauh lebih percaya diri dalam coding.',
  1
),
(
  'Siti Nurhaliza',
  'SMK Bisnis Digital',
  'Materi riset audiens dan copywriting-nya aplikatif sekali. Saya diajarkan bagaimana menulis copy landing page yang memikat dan menerapkan dasar SEO agar halaman web dapat terindeks dengan baik di Google.',
  2
),
(
  'Bagas Aditya',
  'SMK Jurusan TKJ',
  'Pengalaman yang sangat berharga bagi siswa TKJ. Saya mempraktikkan langsung setup local web server, konfigurasi domain, DNS, dan pengamanan protokol HTTPS. Benar-benar sesuai dengan standar dunia kerja!',
  3
);

-- -----------------------------------------------------------------------------
-- 5. Tabel: faqs (Pertanyaan Umum)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `faqs`;
CREATE TABLE `faqs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `question` VARCHAR(255) NOT NULL,
  `answer` LONGTEXT NOT NULL,
  `category` VARCHAR(50) DEFAULT 'Umum',
  `sort_order` INT NOT NULL DEFAULT 0,
  `is_published` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `faqs` (`question`, `answer`, `sort_order`) VALUES
(
  'Apa itu program magang Pengembangan Website berbasis Digital Marketing?',
  'Program magang ini adalah program pembelajaran praktik yang memadukan proses pembuatan website responsif dengan penerapan strategi digital marketing dasar sesuai dengan kompetensi jurusan peserta. Peserta mempraktikkan langsung alur kerja perencanaan website, penataan visual antarmuka, penulisan konten informatif, dan dasar optimasi mesin pencari.',
  1
),
(
  'Jurusan apa saja yang dapat mengikuti program magang ini?',
  'Program ini dirancang untuk lima bidang keahlian utama: Informatika, Bisnis Digital (BDP), Desain Komunikasi Visual (DKV/Multimedia), Rekayasa Perangkat Lunak (RPL), dan Teknik Komputer dan Jaringan (TKJ). Setiap jurusan mendapatkan materi praktik yang diselaraskan dengan latar belakang keahlian masing-masing.',
  2
),
(
  'Apa perbedaan fokus materi antara jurusan Informatika dan RPL?',
  'Jurusan Informatika menekankan pada pemahaman logika algoritma, alur komputasi, dan analisis pemecahan masalah digital secara umum. Sedangkan Rekayasa Perangkat Lunak (RPL) berfokus spesifik pada rekayasa teknis kode pembuatan website, penulisan HTML, CSS, JavaScript, framework Bootstrap, dan pengujian kualitas kode.',
  3
),
(
  'Apakah siswa TKJ juga dapat mengikuti program magang ini?',
  'Ya, siswa TKJ sangat relevan untuk mengikuti program ini karena website membutuhkan infrastruktur server, lingkungan pengembangan lokal, konfigurasi domain, DNS, dan pengamanan protokol HTTPS agar dapat diakses publik dengan stabil.',
  4
),
(
  'Apa saja tahapan atau aktivitas yang dilakukan peserta selama magang?',
  'Aktivitas peserta meliputi pengenalan kebutuhan proyek website, perancangan struktur konten, praktik pembuatan halaman antarmuka sesuai jurusan, pembuatan aset grafis dan copywriting, serta evaluasi hasil praktik bersama pembimbing program.',
  5
),
(
  'Bagaimana cara berkonsultasi mengenai jadwal dan persyaratan pendaftaran?',
  'Calon peserta, guru pembimbing, atau orang tua dapat langsung berkonsultasi melalui WhatsApp resmi di nomor 0822-2525-4434. Tim pengelola akan memberikan informasi terkini mengenai ketersediaan kuota, syarat berkas, dan periode pelaksanaan program.',
  6
);

-- -----------------------------------------------------------------------------
-- 6. Tabel: articles (Blog & Edukasi)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `articles`;
CREATE TABLE `articles` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `title` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(255) NOT NULL UNIQUE,
  `category` VARCHAR(100) NOT NULL,
  `excerpt` TEXT NOT NULL,
  `content` LONGTEXT,
  `featured_image` VARCHAR(255) DEFAULT 'assets/img/about/about-7.webp',
  `author_name` VARCHAR(100) DEFAULT 'Tim Pembimbing Magang',
  `published_date` DATE DEFAULT (CURRENT_DATE),
  `is_published` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `articles` (`title`, `slug`, `category`, `excerpt`, `featured_image`, `published_date`) VALUES
(
  'Mengapa Keterampilan Web & Digital Marketing Sangat Dibutuhkan?',
  'mengapa-keterampilan-web-dan-digital-marketing-dibutuhkan',
  'Program Magang',
  'Kombinasi kemampuan membangun website yang fungsional dan memasarkannya secara digital membuka peluang karier nyata bagi siswa SMK dan mahasiswa di era internet modern.',
  'assets/img/about/about-7.webp',
  '2026-11-10'
),
(
  'Perbedaan Fokus Magang Jurusan Informatika dan RPL',
  'perbedaan-fokus-magang-informatika-dan-rpl',
  'Panduan Jurusan',
  'Ketahui perbedaan penekanan antara konsep komputasi Informatika dan rekayasa kode praktis pada jurusan Rekayasa Perangkat Lunak agar tidak salah memilih tempat magang.',
  'assets/img/about/about-square-5.webp',
  '2026-11-08'
),
(
  'Peran Penting Siswa TKJ dalam Publikasi & Keamanan Web',
  'peran-penting-tkj-dalam-publikasi-dan-keamanan-website',
  'Infrastruktur',
  'Website tidak dapat diakses publik tanpa infrastruktur server, konfigurasi domain DNS, dan pengamanan koneksi HTTPS yang stabil oleh anak jaringan.',
  'assets/img/misc/misc-17.webp',
  '2026-11-05'
);

