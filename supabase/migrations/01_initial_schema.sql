-- =============================================================================
-- Migration: 01_initial_schema.sql
-- Project: Website Program Magang (Pengembangan Website berbasis Digital Marketing)
-- Database: PostgreSQL (Supabase)
-- =============================================================================

-- Enable UUID extension if not enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- -----------------------------------------------------------------------------
-- 1. Table: site_settings
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.site_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    site_name TEXT NOT NULL,
    tagline TEXT NOT NULL,
    logo_url TEXT,
    favicon_url TEXT,
    whatsapp_number TEXT NOT NULL DEFAULT '6282225254434',
    whatsapp_default_message TEXT NOT NULL DEFAULT 'Halo, saya ingin bertanya tentang program magang.',
    email TEXT,
    address TEXT,
    city TEXT,
    province TEXT,
    country TEXT DEFAULT 'Indonesia',
    seo_title TEXT NOT NULL,
    seo_description TEXT NOT NULL,
    og_image_url TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- 2. Table: pages
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.pages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    content JSONB,
    excerpt TEXT,
    featured_image TEXT,
    meta_title TEXT,
    meta_description TEXT,
    canonical_url TEXT,
    is_published BOOLEAN NOT NULL DEFAULT true,
    published_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- 3. Table: majors
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.majors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    abbreviation TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    short_description TEXT NOT NULL,
    description TEXT NOT NULL,
    competencies JSONB NOT NULL DEFAULT '[]'::jsonb,
    activities JSONB NOT NULL DEFAULT '[]'::jsonb,
    image_url TEXT,
    image_alt TEXT,
    meta_title TEXT,
    meta_description TEXT,
    sort_order INT NOT NULL DEFAULT 0,
    is_published BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- 4. Table: programs
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.programs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    summary TEXT NOT NULL,
    description TEXT NOT NULL,
    learning_outcomes JSONB NOT NULL DEFAULT '[]'::jsonb,
    activities JSONB NOT NULL DEFAULT '[]'::jsonb,
    image_url TEXT,
    image_alt TEXT,
    meta_title TEXT,
    meta_description TEXT,
    sort_order INT NOT NULL DEFAULT 0,
    is_published BOOLEAN NOT NULL DEFAULT true,
    published_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- 5. Table: program_majors (Junction)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.program_majors (
    program_id UUID NOT NULL REFERENCES public.programs(id) ON DELETE CASCADE,
    major_id UUID NOT NULL REFERENCES public.majors(id) ON DELETE CASCADE,
    PRIMARY KEY (program_id, major_id)
);

-- -----------------------------------------------------------------------------
-- 6. Table: gallery
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.gallery (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    caption TEXT,
    image_url TEXT NOT NULL,
    thumbnail_url TEXT,
    image_alt TEXT NOT NULL,
    category TEXT DEFAULT 'kegiatan',
    event_date DATE,
    sort_order INT NOT NULL DEFAULT 0,
    is_published BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- 7. Table: blog_categories
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.blog_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    description TEXT
);

-- -----------------------------------------------------------------------------
-- 8. Table: blog_posts
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.blog_posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    excerpt TEXT NOT NULL,
    content TEXT NOT NULL,
    featured_image TEXT,
    featured_image_alt TEXT,
    author_name TEXT NOT NULL DEFAULT 'Tim Magang',
    category_id UUID REFERENCES public.blog_categories(id) ON DELETE SET NULL,
    tags TEXT[] DEFAULT ARRAY[]::TEXT[],
    meta_title TEXT,
    meta_description TEXT,
    canonical_url TEXT,
    focus_keyword TEXT,
    status TEXT NOT NULL DEFAULT 'published' CHECK (status IN ('draft', 'published', 'archived')),
    published_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- 9. Table: faqs
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.faqs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    page_context TEXT NOT NULL DEFAULT 'home',
    major_id UUID REFERENCES public.majors(id) ON DELETE SET NULL,
    sort_order INT NOT NULL DEFAULT 0,
    is_published BOOLEAN NOT NULL DEFAULT true
);

-- -----------------------------------------------------------------------------
-- 10. Table: testimonials (optional, only with permission)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.testimonials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    institution TEXT,
    quote TEXT NOT NULL,
    avatar_url TEXT,
    is_published BOOLEAN NOT NULL DEFAULT true,
    sort_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- Indexes for High Performance Querying
-- -----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_majors_published_order ON public.majors(is_published, sort_order);
CREATE INDEX IF NOT EXISTS idx_programs_published_order ON public.programs(is_published, sort_order);
CREATE INDEX IF NOT EXISTS idx_gallery_published_order ON public.gallery(is_published, sort_order);
CREATE INDEX IF NOT EXISTS idx_blog_posts_status_published ON public.blog_posts(status, published_at DESC);
CREATE INDEX IF NOT EXISTS idx_faqs_published_order ON public.faqs(is_published, page_context, sort_order);

-- -----------------------------------------------------------------------------
-- Row Level Security (RLS)
-- Read-only anonymous access for published records
-- -----------------------------------------------------------------------------
ALTER TABLE public.site_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.majors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.programs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.program_majors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.gallery ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.blog_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.blog_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.faqs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.testimonials ENABLE ROW LEVEL SECURITY;

-- Anonymous public read policies
CREATE POLICY "Public can view site settings" ON public.site_settings FOR SELECT USING (true);
CREATE POLICY "Public can view published pages" ON public.pages FOR SELECT USING (is_published = true);
CREATE POLICY "Public can view published majors" ON public.majors FOR SELECT USING (is_published = true);
CREATE POLICY "Public can view published programs" ON public.programs FOR SELECT USING (is_published = true);
CREATE POLICY "Public can view program majors relations" ON public.program_majors FOR SELECT USING (true);
CREATE POLICY "Public can view published gallery" ON public.gallery FOR SELECT USING (is_published = true);
CREATE POLICY "Public can view blog categories" ON public.blog_categories FOR SELECT USING (true);
CREATE POLICY "Public can view published blog posts" ON public.blog_posts FOR SELECT USING (status = 'published');
CREATE POLICY "Public can view published faqs" ON public.faqs FOR SELECT USING (is_published = true);
CREATE POLICY "Public can view published testimonials" ON public.testimonials FOR SELECT USING (is_published = true);

-- -----------------------------------------------------------------------------
-- Seed Data
-- -----------------------------------------------------------------------------

-- Site Settings
INSERT INTO public.site_settings (
    site_name, tagline, whatsapp_number, whatsapp_default_message,
    seo_title, seo_description
) VALUES (
    'Program Magang Pengembangan Website',
    'Pengembangan Website Berbasis Digital Marketing untuk SMK dan Mahasiswa',
    '6282225254434',
    'Halo, saya ingin bertanya tentang program magang.',
    'Program Magang Pengembangan Website & Digital Marketing',
    'Kenali program magang Pengembangan Website berbasis Digital Marketing untuk jurusan Informatika, Bisnis Digital (BDP), DKV/Multimedia, RPL, dan TKJ.'
) ON CONFLICT DO NOTHING;

-- 5 Majors
INSERT INTO public.majors (name, abbreviation, slug, short_description, description, competencies, activities, image_url, image_alt, sort_order) VALUES
(
    'Informatika',
    'IF',
    'informatika',
    'Fokus pengenalan konsep komputasi, logika pemrograman, dan alur kerja pemecahan masalah dalam pengembangan solusi digital.',
    'Program magang jurusan Informatika menekankan pada pemahaman komputasi holistik, logika algoritma, alur kerja sistem digital, dan dasar pengembangan web untuk menyelesaikan kebutuhan proyek nyata.',
    '["Logika Pemrograman", "Dasar Pengembangan Web", "Pengolahan Data Sederhana", "Pemecahan Masalah Komputasi", "Alur Kerja Proyek Digital"]'::jsonb,
    '["Menganalisis alur kebutuhan sistem web", "Menerapkan logika algoritma pada modul halaman web", "Mempelajari integrasi data dan struktur konten", "Menguji fungsionalitas dan alur navigasi web"]'::jsonb,
    'assets/img/services/services-2.webp',
    'Peserta magang Informatika mempelajari logika web',
    1
),
(
    'Bisnis Digital',
    'BDP',
    'bisnis-digital',
    'Fokus pada proses bisnis daring, riset audiens, strategi konten, dasar SEO, dan evaluasi performa pemasaran digital.',
    'Program magang Bisnis Digital (BDP) mengasah kemampuan riset audiens sasaran, perancangan kalender editorial konten, optimasi mesin pencari dasar, copywriting persuasif, dan pemanfaatan website sebagai kanal pemasaran digital utama.',
    '["Riset Audiens & Pasar", "Perencanaan Konten & Copywriting", "Dasar SEO On-Page", "Pengelolaan Kanal Digital", "Evaluasi Performa Web"]'::jsonb,
    '["Melakukan riset kata kunci dan tren pencarian audiens", "Menyusun artikel dan landing page copy berbasis SEO", "Menganalisis performa halaman web dan interaksi pengunjung", "Merencanakan distribusi konten melalui kanal digital"]'::jsonb,
    'assets/img/services/services-4.webp',
    'Aktivitas peserta magang Bisnis Digital meriset konten web',
    2
),
(
    'Desain Komunikasi Visual',
    'DKV',
    'dkv-multimedia',
    'Fokus pada komunikasi visual, prinsip tata letak antarmuka, tipografi, pengolahan grafis, dan aset media visual website.',
    'Program magang DKV dan Multimedia berfokus pada produksi aset visual berkualitas tinggi untuk kebutuhan website dan media pendukung, memahami konsistensi identitas merek, perancangan layout UI yang komunikatif, serta optimalisasi format gambar digital.',
    '["Prinsip Desain & Tata Letak", "Tipografi & Harmoni Warna", "Pengolahan Aset Grafis", "Desain Antarmuka Web (UI)", "Optimasi Format Media Web"]'::jsonb,
    '["Membuat wireframe dan mockup visual halaman website", "Mengolah gambar dan ilustrasi beresolusi web (WebP/SVG)", "Menjaga konsistensi panduan visual (brand guidelines)", "Menyiapkan aset visual interaktif untuk presentasi web"]'::jsonb,
    'assets/img/services/services-5.webp',
    'Peserta magang DKV mendesain aset visual website',
    3
),
(
    'Rekayasa Perangkat Lunak',
    'RPL',
    'rekayasa-perangkat-lunak',
    'Fokus pada rekayasa pembuatan dan pemeliharaan perangkat lunak website: HTML5, CSS3, JavaScript, Bootstrap, dan struktur kode.',
    'Program magang Rekayasa Perangkat Lunak (RPL) menitikberatkan pada proses teknis konstruksi halaman web responsif, standardisasi kode semantik, manipulasi DOM, implementasi komponen antarmuka Bootstrap, pengelolaan versi kode, dan pengujian integrasi.',
    '["HTML5 Semantik & CSS3", "Modern JavaScript & DOM", "Bootstrap 5 Framework", "Manajemen Struktur Kode", "Pengujian & Validasi Web"]'::jsonb,
    '["Mengubah desain antarmuka menjadi kode HTML dan CSS responsif", "Mengintegrasikan komponen interaktif dengan Bootstrap dan JS", "Menata arsitektur file kode modular dan clean code", "Menguji kompabilitas tampilan lintas ukuran layar"]'::jsonb,
    'assets/img/services/services-8.webp',
    'Peserta magang RPL mengoding komponen website',
    4
),
(
    'Teknik Komputer dan Jaringan',
    'TKJ',
    'teknik-komputer-jaringan',
    'Fokus pada infrastruktur penunjang layanan web: konfigurasi jaringan lokal, environment kerja, domain, hosting, dan publikasi server.',
    'Program magang Teknik Komputer dan Jaringan (TKJ) membekali peserta dengan pemahaman fondasi infrastruktur yang mendukung website dapat diakses publik, meliputi setup local development server, manajemen DNS domain, konfigurasi hosting, dan keamanan dasar web.',
    '["Dasar Jaringan Komputer", "Setup Local Web Server", "Pengenalan Domain & DNS", "Konfigurasi Hosting Web", "Keamanan Dasar Server Web"]'::jsonb,
    '["Menyiapkan lingkungan kerja lokal (local development environment)", "Mempelajari konfigurasi nama domain dan DNS record", "Mengunggah dan mengonfigurasi website pada hosting", "Memonitor status koneksi dan protokol keamanan SSL/HTTPS"]'::jsonb,
    'assets/img/services/services-10.webp',
    'Peserta magang TKJ mengonfigurasi server dan domain website',
    5
)
ON CONFLICT (slug) DO NOTHING;

-- Blog Categories
INSERT INTO public.blog_categories (name, slug, description) VALUES
('Program Magang', 'program-magang', 'Informasi seputar persiapan, aktivitas, dan wawasan program magang.'),
('Pengembangan Website', 'pengembangan-website', 'Panduan teknis pembuatan website modern dan responsif.'),
('Digital Marketing', 'digital-marketing', 'Strategi pemasaran digital, SEO, dan konten untuk meningkatkan eksposur web.')
ON CONFLICT (slug) DO NOTHING;

-- Initial Blog Posts
INSERT INTO public.blog_posts (
    title, slug, excerpt, content, author_name, tags, meta_title, meta_description, status, published_at
) VALUES
(
    'Mengapa Keterampilan Pengembangan Website dan Digital Marketing Sangat Dibutuhkan?',
    'mengapa-keterampilan-web-dan-digital-marketing-dibutuhkan',
    'Kombinasi kemampuan membangun website yang fungsional dan memasarkannya secara digital membuka peluang karier nyata bagi siswa SMK dan mahasiswa.',
    '<p>Di era transformasi digital saat ini, memiliki website saja tidak lagi cukup jika tidak diimbangi dengan strategi pemasaran digital yang tepat. Sebaliknya, strategi promosi digital memerlukan wadah kredibel berupa website yang cepat, informatif, dan mudah diakses oleh audiens sasaran.</p><p>Program magang berbasis praktik memadukan kedua kompetensi fundamental ini agar peserta tidak hanya memahami cara menyusun kode dan layout, melainkan juga mengerti bagaimana halaman web yang dibangun dapat ditemukan oleh calon pengguna melalui mesin pencari serta memberikan informasi yang bermanfaat.</p>',
    'Tim Magang',
    ARRAY['Pengembangan Website', 'Digital Marketing', 'Kompetensi Siswa'],
    'Mengapa Keterampilan Web dan Digital Marketing Sangat Dibutuhkan?',
    'Ulasan pentingnya kolaborasi antara pembuatan website dan strategi digital marketing bagi peserta magang masa kini.',
    'published',
    NOW() - INTERVAL '2 days'
),
(
    'Perbedaan Fokus Magang Jurusan Informatika dan Rekayasa Perangkat Lunak',
    'perbedaan-fokus-magang-informatika-dan-rpl',
    'Ketahui perbedaan penekanan antara konsep komputasi Informatika dan rekayasa kode praktis pada jurusan RPL.',
    '<p>Banyak calon peserta magang yang sering bertanya mengenai perbedaan antara jurusan Informatika dan Rekayasa Perangkat Lunak (RPL). Meskipun keduanya berada dalam rumpun teknologi informasi, fokus pembelajaran praktis memiliki penekanan yang berbeda secara signifikan.</p><p>Informatika menitikberatkan pada pemahaman menyeluruh tentang logika komputasi, alur algoritma, dan pemecahan masalah digital. Sementara itu, Rekayasa Perangkat Lunak (RPL) lebih berfokus pada implementasi teknis pembuatan kode, arsitektur software web, standardisasi kode HTML/CSS/JS, serta pengujian kualitas halaman antarmuka.</p>',
    'Tim Magang',
    ARRAY['Informatika', 'RPL', 'Panduan Jurusan'],
    'Perbedaan Fokus Magang Informatika dan RPL',
    'Pahami perbedaan fokus materi magang antara jurusan Informatika dan Rekayasa Perangkat Lunak (RPL) agar sesuai minat peserta.',
    'published',
    NOW() - INTERVAL '5 days'
),
(
    'Peran Penting Siswa TKJ dalam Publikasi dan Keamanan Website',
    'peran-penting-tkj-dalam-publikasi-dan-keamanan-website',
    'Website tidak akan dapat diakses publik tanpa infrastruktur server, konfigurasi domain DNS, dan pengamanan koneksi yang andal.',
    '<p>Bagi siswa jurusan Teknik Komputer dan Jaringan (TKJ), program magang pengembangan website memberikan wawasan langsung mengenai bagaimana jaringan dan server bekerja di dunia nyata untuk melayani pengunjung website.</p><p>Mulai dari konfigurasi local server, pengelolaan DNS domain, hingga pengaturan sertifikat SSL/HTTPS, siswa TKJ memegang peranan krusial dalam memastikan bahwa website yang telah dikembangkan dapat diakses secara stabil, cepat, dan aman.</p>',
    'Tim Magang',
    ARRAY['TKJ', 'Server Web', 'Domain Hosting'],
    'Peran Penting Siswa TKJ dalam Publikasi Website',
    'Bagaimana kompetensi jaringan dan server TKJ diterapkan secara langsung pada publikasi website modern.',
    'published',
    NOW() - INTERVAL '8 days'
)
ON CONFLICT (slug) DO NOTHING;

-- FAQs (AEO-optimized: direct answer in first sentence)
INSERT INTO public.faqs (question, answer, page_context, sort_order) VALUES
(
    'Apa itu program magang Pengembangan Website berbasis Digital Marketing?',
    'Program magang ini adalah program pembelajaran praktik yang memadukan proses pembuatan website responsif dengan penerapan strategi digital marketing dasar sesuai dengan kompetensi jurusan peserta. Peserta mempraktikkan langsung alur kerja perencanaan website, penataan visual antarmuka, penulisan konten informatif, dan dasar optimasi mesin pencari.',
    'home',
    1
),
(
    'Jurusan apa saja yang dapat mengikuti program magang ini?',
    'Program ini dirancang untuk lima bidang keahlian utama: Informatika, Bisnis Digital (BDP), Desain Komunikasi Visual (DKV/Multimedia), Rekayasa Perangkat Lunak (RPL), dan Teknik Komputer dan Jaringan (TKJ). Setiap jurusan mendapatkan fokus penugasan dan modul praktik yang diselaraskan dengan kurikulum masing-masing.',
    'home',
    2
),
(
    'Apa perbedaan fokus materi antara jurusan Informatika dan RPL?',
    'Jurusan Informatika menekankan pada pemahaman logika algoritma, alur komputasi, dan analisis pemecahan masalah digital secara umum. Sedangkan Rekayasa Perangkat Lunak (RPL) berfokus spesifik pada rekayasa teknis kode pembuatan website, penulisan HTML, CSS, JavaScript, framework Bootstrap, dan pengujian kualitas kode.',
    'home',
    3
),
(
    'Apakah siswa TKJ juga dapat mengikuti program magang ini?',
    'Ya, siswa TKJ sangat relevan untuk mengikuti program ini karena website membutuhkan infrastruktur server, lingkungan pengembangan lokal, konfigurasi domain, DNS, dan pengamanan protokol HTTPS agar dapat diakses publik dengan stabil.',
    'home',
    4
),
(
    'Apa saja tahapan atau aktivitas yang dilakukan peserta selama magang?',
    'Aktivitas peserta meliputi pengenalan kebutuhan proyek website, perancangan struktur konten, praktik pembuatan halaman antarmuka sesuai jurusan, pembuatan aset grafis dan copywriting, serta evaluasi hasil praktik bersama pembimbing program.',
    'home',
    5
),
(
    'Bagaimana cara berkonsultasi mengenai jadwal dan persyaratan pendaftaran?',
    'Calon peserta, guru pembimbing, atau orang tua dapat langsung berkonsultasi melalui WhatsApp resmi di nomor 0822-2525-4434. Tim pengelola akan memberikan informasi terkini mengenai ketersediaan kuota, syarat berkas, dan periode pelaksanaan program.',
    'home',
    6
)
ON CONFLICT DO NOTHING;

