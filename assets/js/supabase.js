/**
 * Website Program Magang - Supabase Client & Data Service
 * Supports live Supabase PostgreSQL connection with graceful offline fallback.
 */

(function(window) {
  "use strict";

  // Supabase Configuration
  // Masukkan kredensial Supabase Anda di sini saat siap terhubung ke database cloud.
  // Jangan pernah menaruh service_role key di browser! Hanya gunakan anon/publishable key.
  const SUPABASE_CONFIG = {
    url: window.SUPABASE_URL || "https://your-project.supabase.co",
    anonKey: window.SUPABASE_ANON_KEY || "your-anon-key"
  };

  // Check if Supabase JS library is present and credentials are valid
  const isSupabaseConfigured = function() {
    return (
      typeof window.supabase !== "undefined" &&
      SUPABASE_CONFIG.url &&
      !SUPABASE_CONFIG.url.includes("your-project") &&
      SUPABASE_CONFIG.anonKey &&
      !SUPABASE_CONFIG.anonKey.includes("your-anon-key")
    );
  };

  let supabaseClient = null;
  if (isSupabaseConfigured()) {
    try {
      supabaseClient = window.supabase.createClient(SUPABASE_CONFIG.url, SUPABASE_CONFIG.anonKey);
      console.log("[MagangDataService] Supabase client initialized.");
    } catch (e) {
      console.warn("[MagangDataService] Failed to initialize Supabase client, fallback enabled:", e);
    }
  }

  // ---------------------------------------------------------------------------
  // Fallback Data Store (Fully aligned with PRD specifications)
  // ---------------------------------------------------------------------------
  const FALLBACK_DATA = {
    settings: {
      site_name: "Program Magang Pengembangan Website",
      tagline: "Pengembangan Website Berbasis Digital Marketing untuk SMK dan Mahasiswa",
      whatsapp_number: "6282225254434",
      whatsapp_display: "0822-2525-4434",
      whatsapp_default_message: "Halo, saya ingin bertanya tentang program magang.",
      seo_title: "Program Magang Pengembangan Website & Digital Marketing",
      seo_description: "Kenali program magang Pengembangan Website berbasis Digital Marketing untuk jurusan Informatika, BDP, DKV, RPL, dan TKJ."
    },
    majors: [
      {
        id: "1",
        name: "Informatika",
        abbreviation: "IF",
        slug: "informatika",
        short_description: "Fokus pengenalan konsep komputasi, logika pemrograman, dan alur kerja pemecahan masalah dalam pengembangan solusi digital.",
        competencies: ["Logika Pemrograman", "Dasar Web", "Pengolahan Data", "Pemecahan Masalah", "Alur Kerja Proyek"],
        icon: "bi-cpu",
        image_url: "assets/img/services/services-2.webp",
        whatsapp_message: "Halo, saya ingin bertanya tentang program magang jurusan Informatika."
      },
      {
        id: "2",
        name: "Bisnis Digital",
        abbreviation: "BDP",
        slug: "bisnis-digital",
        short_description: "Fokus pada proses bisnis daring, riset audiens sasaran, perencanaan konten, dasar SEO, dan evaluasi performa pemasaran digital.",
        competencies: ["Riset Audiens", "Perencanaan Konten", "Copywriting", "Dasar SEO", "Evaluasi Performa"],
        icon: "bi-graph-up-arrow",
        image_url: "assets/img/services/services-4.webp",
        whatsapp_message: "Halo, saya ingin bertanya tentang program magang jurusan Bisnis Digital."
      },
      {
        id: "3",
        name: "DKV / Multimedia",
        abbreviation: "DKV",
        slug: "dkv-multimedia",
        short_description: "Fokus pada komunikasi visual, prinsip tata letak antarmuka web, tipografi, pengolahan grafis, dan aset media visual digital.",
        competencies: ["Prinsip Desain", "Tata Letak UI", "Tipografi", "Aset Visual Web", "Optimasi Gambar"],
        icon: "bi-palette",
        image_url: "assets/img/services/services-5.webp",
        whatsapp_message: "Halo, saya ingin bertanya tentang program magang jurusan DKV / Multimedia."
      },
      {
        id: "4",
        name: "Rekayasa Perangkat Lunak",
        abbreviation: "RPL",
        slug: "rekayasa-perangkat-lunak",
        short_description: "Fokus pada rekayasa pembuatan dan pemeliharaan website: HTML5 semantik, CSS3, JavaScript, framework Bootstrap, dan manajemen kode.",
        competencies: ["HTML5 & CSS3", "Modern JavaScript", "Bootstrap 5", "Struktur Kode", "Pengujian Web"],
        icon: "bi-code-slash",
        image_url: "assets/img/services/services-8.webp",
        whatsapp_message: "Halo, saya ingin bertanya tentang program magang jurusan Rekayasa Perangkat Lunak (RPL)."
      },
      {
        id: "5",
        name: "Teknik Komputer & Jaringan",
        abbreviation: "TKJ",
        slug: "teknik-komputer-jaringan",
        short_description: "Fokus pada infrastruktur penunjang layanan web: setup local environment, pengelolaan nama domain, konfigurasi hosting, dan protokol keamanan.",
        competencies: ["Jaringan Dasar", "Local Web Server", "Domain & DNS", "Hosting Web", "Keamanan HTTPS"],
        icon: "bi-hdd-network",
        image_url: "assets/img/services/services-10.webp",
        whatsapp_message: "Halo, saya ingin bertanya tentang program magang jurusan Teknik Komputer dan Jaringan (TKJ)."
      }
    ],
    curriculum: [
      {
        step: "01",
        title: "Pengenalan Kebutuhan Website",
        desc: "Memahami tujuan pembuatan website, audiens sasaran, dan fungsi utama yang dibutuhkan pengguna."
      },
      {
        step: "02",
        title: "Perencanaan & Struktur Halaman",
        desc: "Menyusun peta situs (sitemap), arsitektur informasi, serta wireframe konten yang terstruktur rapi."
      },
      {
        step: "03",
        title: "Pengembangan Website",
        desc: "Praktik membangun antarmuka web responsif berbasis HTML5, CSS3, JavaScript modern, dan Bootstrap."
      },
      {
        step: "04",
        title: "Desain Antarmuka & Aset Visual",
        desc: "Merancang tata letak yang komunikatif, pemilihan warna kontras, serta produksi aset visual WebP/SVG."
      },
      {
        step: "05",
        title: "Pembuatan Konten Digital",
        desc: "Menulis copy informatif, persuasif, dan relevan dengan kebutuhan calon pengunjung website."
      },
      {
        step: "06",
        title: "Dasar SEO & Digital Marketing",
        desc: "Menerapkan struktur heading, metadata ramah mesin pencari, dan dasar strategi promosi digital."
      },
      {
        step: "07",
        title: "Publikasi & Evaluasi Hasil",
        desc: "Melakukan simulasi penayangan website ke server serta evaluasi bersama pembimbing magang."
      }
    ],
    workflow: [
      {
        step: "1",
        title: "Konsultasi Awal",
        desc: "Hubungi tim melalui WhatsApp untuk mendiskusikan minat, sekolah/kampus asal, dan jurusan."
      },
      {
        step: "2",
        title: "Penyesuaian Jurusan",
        desc: "Menentukan fokus kompetensi dan materi praktik yang sesuai dengan kurikulum peserta."
      },
      {
        step: "3",
        title: "Informasi Syarat & Jadwal",
        desc: "Menerima penjelasan resmi terkait periode magang, kuota tersedia, dan kelengkapan administrasi."
      },
      {
        step: "4",
        title: "Pelaksanaan Praktik",
        desc: "Menjalani pembelajaran praktik intensif, bimbingan berkala, dan pengerjaan tugas proyek terarah."
      },
      {
        step: "5",
        title: "Evaluasi & Dokumentasi",
        desc: "Meninjau hasil pencapaian belajar dan penyusunan laporan kegiatan sesuai prosedur pengelola."
      }
    ],
    gallery: [
      {
        title: "Sesi Diskusi & Perencanaan Web",
        category: "kegiatan",
        image: "assets/img/portfolio/portfolio-1.webp",
        caption: "Peserta magang mendiskusikan struktur halaman dan kebutuhan konten web"
      },
      {
        title: "Praktik Koding Antarmuka Responsif",
        category: "praktik",
        image: "assets/img/portfolio/portfolio-2.webp",
        caption: "Implementasi komponen Bootstrap dan HTML semantik"
      },
      {
        title: "Perancangan Aset Visual UI",
        category: "desain",
        image: "assets/img/portfolio/portfolio-3.webp",
        caption: "Pengolahan gambar dan tipografi untuk kebutuhan halaman web"
      },
      {
        title: "Riset Kata Kunci & Copywriting",
        category: "kegiatan",
        image: "assets/img/portfolio/portfolio-4.webp",
        caption: "Analisis pencarian audiens untuk penyusunan konten digital"
      },
      {
        title: "Setup Lingkungan Kerja Lokal",
        category: "praktik",
        image: "assets/img/portfolio/portfolio-7.webp",
        caption: "Konfigurasi local development server dan pengujian modul"
      },
      {
        title: "Evaluasi & Presentasi Proyek",
        category: "kegiatan",
        image: "assets/img/portfolio/portfolio-8.webp",
        caption: "Ulasan bersama pembimbing atas capaian praktik peserta"
      }
    ],
    blog: [
      {
        id: "1",
        title: "Mengapa Keterampilan Web dan Digital Marketing Sangat Dibutuhkan?",
        slug: "mengapa-keterampilan-web-dan-digital-marketing-dibutuhkan",
        category: "Program Magang",
        date: "10 Nov 2026",
        excerpt: "Kombinasi kemampuan membangun website fungsional dan memasarkannya secara digital membuka peluang nyata bagi siswa SMK dan mahasiswa.",
        image: "assets/img/about/about-7.webp"
      },
      {
        id: "2",
        title: "Perbedaan Fokus Magang Jurusan Informatika dan RPL",
        slug: "perbedaan-fokus-magang-informatika-dan-rpl",
        category: "Panduan Jurusan",
        date: "08 Nov 2026",
        excerpt: "Ketahui perbedaan penekanan antara konsep komputasi Informatika dan rekayasa kode praktis pada jurusan Rekayasa Perangkat Lunak.",
        image: "assets/img/about/about-square-5.webp"
      },
      {
        id: "3",
        title: "Peran Penting Siswa TKJ dalam Publikasi dan Keamanan Website",
        slug: "peran-penting-tkj-dalam-publikasi-dan-keamanan-website",
        category: "Infrastruktur Web",
        date: "05 Nov 2026",
        excerpt: "Website tidak dapat diakses publik tanpa infrastruktur server, konfigurasi DNS domain, dan protokol koneksi HTTPS yang stabil.",
        image: "assets/img/misc/misc-17.webp"
      }
    ],
    faqs: [
      {
        q: "Apa itu program magang Pengembangan Website berbasis Digital Marketing?",
        a: "Program magang ini adalah program pembelajaran praktik yang memadukan proses pembuatan website responsif dengan penerapan strategi digital marketing dasar sesuai dengan kompetensi jurusan peserta. Peserta mempraktikkan langsung alur kerja perencanaan website, penataan visual antarmuka, penulisan konten informatif, dan dasar optimasi mesin pencari."
      },
      {
        q: "Jurusan apa saja yang dapat mengikuti program magang ini?",
        a: "Program ini dirancang untuk lima bidang keahlian utama: Informatika, Bisnis Digital (BDP), Desain Komunikasi Visual (DKV/Multimedia), Rekayasa Perangkat Lunak (RPL), dan Teknik Komputer dan Jaringan (TKJ). Setiap jurusan mendapatkan materi praktik yang diselaraskan dengan latar belakang keahlian masing-masing."
      },
      {
        q: "Apa perbedaan fokus materi antara jurusan Informatika dan RPL?",
        a: "Jurusan Informatika menekankan pada pemahaman logika algoritma, alur komputasi, dan analisis pemecahan masalah digital secara umum. Sedangkan Rekayasa Perangkat Lunak (RPL) berfokus spesifik pada rekayasa teknis kode pembuatan website, penulisan HTML, CSS, JavaScript, framework Bootstrap, dan pengujian kualitas kode."
      },
      {
        q: "Apakah siswa TKJ juga dapat mengikuti program magang ini?",
        a: "Ya, siswa TKJ sangat relevan untuk mengikuti program ini karena website membutuhkan infrastruktur server, lingkungan pengembangan lokal, konfigurasi domain, DNS, dan pengamanan protokol HTTPS agar dapat diakses publik dengan stabil."
      },
      {
        q: "Apa saja tahapan atau aktivitas yang dilakukan peserta selama magang?",
        a: "Aktivitas peserta meliputi pengenalan kebutuhan proyek website, perancangan struktur konten, praktik pembuatan halaman antarmuka sesuai jurusan, pembuatan aset grafis dan copywriting, serta evaluasi hasil praktik bersama pembimbing program."
      },
      {
        q: "Bagaimana cara berkonsultasi mengenai jadwal dan persyaratan pendaftaran?",
        a: "Calon peserta, guru pembimbing, atau orang tua dapat langsung berkonsultasi melalui WhatsApp resmi di nomor 0822-2525-4434. Tim pengelola akan memberikan informasi terkini mengenai ketersediaan kuota, syarat berkas, dan periode pelaksanaan program."
      }
    ]
  };

  // ---------------------------------------------------------------------------
  // Data Service API
  // ---------------------------------------------------------------------------
  const MagangDataService = {
    // Generate standardized WhatsApp link
    getWhatsAppLink: function(customMessage) {
      const phone = FALLBACK_DATA.settings.whatsapp_number;
      const message = customMessage || FALLBACK_DATA.settings.whatsapp_default_message;
      return "https://wa.me/" + phone + "?text=" + encodeURIComponent(message);
    },

    // Get site settings
    getSettings: async function() {
      if (supabaseClient) {
        try {
          const { data, error } = await supabaseClient
            .from("site_settings")
            .select("*")
            .limit(1)
            .single();
          if (!error && data) return data;
        } catch (e) {
          console.warn("[MagangDataService] Error fetching settings from Supabase, using fallback:", e);
        }
      }
      return FALLBACK_DATA.settings;
    },

    // Get all published majors
    getMajors: async function() {
      if (supabaseClient) {
        try {
          const { data, error } = await supabaseClient
            .from("majors")
            .select("*")
            .eq("is_published", true)
            .order("sort_order", { ascending: true });
          if (!error && data && data.length > 0) return data;
        } catch (e) {
          console.warn("[MagangDataService] Error fetching majors from Supabase, using fallback:", e);
        }
      }
      return FALLBACK_DATA.majors;
    },

    // Get published gallery items
    getGallery: async function(category) {
      if (supabaseClient) {
        try {
          let query = supabaseClient
            .from("gallery")
            .select("*")
            .eq("is_published", true)
            .order("sort_order", { ascending: true });
          if (category && category !== "*") {
            query = query.eq("category", category);
          }
          const { data, error } = await query;
          if (!error && data && data.length > 0) return data;
        } catch (e) {
          console.warn("[MagangDataService] Error fetching gallery from Supabase, using fallback:", e);
        }
      }
      return FALLBACK_DATA.gallery;
    },

    // Get published blog posts
    getLatestPosts: async function(limit = 3) {
      if (supabaseClient) {
        try {
          const { data, error } = await supabaseClient
            .from("blog_posts")
            .select("*")
            .eq("status", "published")
            .order("published_at", { ascending: false })
            .limit(limit);
          if (!error && data && data.length > 0) return data;
        } catch (e) {
          console.warn("[MagangDataService] Error fetching blog posts from Supabase, using fallback:", e);
        }
      }
      return FALLBACK_DATA.blog.slice(0, limit);
    },

    // Get published FAQs
    getFaqs: async function(pageContext = "home") {
      if (supabaseClient) {
        try {
          const { data, error } = await supabaseClient
            .from("faqs")
            .select("*")
            .eq("is_published", true)
            .eq("page_context", pageContext)
            .order("sort_order", { ascending: true });
          if (!error && data && data.length > 0) return data;
        } catch (e) {
          console.warn("[MagangDataService] Error fetching FAQs from Supabase, using fallback:", e);
        }
      }
      return FALLBACK_DATA.faqs;
    },

    // Direct access to fallback data
    getFallbackData: function() {
      return FALLBACK_DATA;
    }
  };

  // Expose to window
  window.MagangDataService = MagangDataService;

})(window);

