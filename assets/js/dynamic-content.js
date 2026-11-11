/**
 * Dynamic Content Sync Engine
 * Menghubungkan Website Utama (index, portfolio, galeri, blog)
 * dengan Data yang Ditambah atau Diedit dari Dashboard Admin secara Realtime.
 */

(function () {
  'use strict';

  // Helper untuk escape HTML agar aman
  function escapeHtml(text) {
    if (!text) return '';
    return String(text)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  // Ambil data dari LocalStorage
  function getData(key) {
    try {
      const stored = localStorage.getItem('magang_' + key);
      return stored ? JSON.parse(stored) : null;
    } catch (e) {
      return null;
    }
  }

  // =========================================================================
  // 1. RENDER TESTIMONI (Halaman index.html)
  // Menampilkan data terbaru dari dashboard (nambah kolom geser kanan-kiri)
  // =========================================================================
  function syncTestimoni() {
    const container = document.querySelector('.testimonial-scroll-container');
    if (!container) return;

    const data = getData('testimoni');
    if (!data || !Array.isArray(data) || data.length === 0) return;

    // Render ulang kartu testimoni dengan data terbaru dari dashboard
    container.innerHTML = data.map((item, index) => `
      <div class="testimonial-col" data-aos="fade-up" data-aos-delay="${(index + 1) * 100}">
        <div class="testimonial-card">
          <div class="quote-icon"><i class="bi bi-quote"></i></div>
          <p class="testimonial-quote">
            "${escapeHtml(item.isi_testimoni)}"
          </p>
          <div class="testimonial-profile">
            <div class="profile-info">
              <h4>${escapeHtml(item.nama)}</h4>
              <span>${escapeHtml(item.asal_sekolah_kampus)} - ${escapeHtml(item.jurusan)}</span>
            </div>
          </div>
        </div>
      </div>
    `).join('');
  }

  // =========================================================================
  // 2. RENDER PORTOFOLIO (Halaman index.html & portfolio.html)
  // =========================================================================
  function syncPortofolio() {
    const data = getData('portofolio');
    if (!data || !Array.isArray(data) || data.length === 0) return;

    // 2.A: Di index.html (Section Portofolio: 3 item pertama)
    const indexContainer = document.querySelector('#portfolio .row.mobile-horizontal-scroll');
    if (indexContainer) {
      indexContainer.innerHTML = data.slice(0, 3).map((item, index) => `
        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="${(index + 1) * 100}">
          <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden">
            <a href="${item.gambar}" class="glightbox" data-gallery="portfolio-gallery"
              data-title="${escapeHtml(item.judul_portofolio)}"
              data-description="${escapeHtml(item.deskripsi)}">
              <img src="${item.gambar}" class="card-img-top" alt="${escapeHtml(item.alt_gambar || item.judul_portofolio)}"
                style="height: 240px; object-fit: cover;" onerror="this.src='assets/img/Portofolio/portofolio-1.webp'">
            </a>
            <div class="card-body p-4">
              <span class="badge bg-light text-dark border mb-2">${escapeHtml(item.kategori)}</span>
              <h5 class="fw-bold mb-2 text-dark">${escapeHtml(item.judul_portofolio)}</h5>
              <p class="small text-muted mb-3">${escapeHtml(item.deskripsi)}</p>
              <div class="d-flex justify-content-between align-items-center border-top pt-3 small text-muted">
                <span><i class="bi bi-person me-1"></i> ${escapeHtml(item.tim_jurusan_sekolah_kampus)}</span>
                <span class="text-success fw-semibold"><i class="bi bi-check-circle me-1"></i>${escapeHtml(item.status_label || 'Selesai')}</span>
              </div>
            </div>
          </div>
        </div>
      `).join('');
    }

    // 2.B: Di portfolio.html (Grid Seluruh Portofolio)
    const portfolioGrid = document.querySelector('.isotope-container');
    if (portfolioGrid && window.location.pathname.includes('portfolio')) {
      portfolioGrid.innerHTML = data.map((item, index) => `
        <div class="col-lg-4 col-md-6 isotope-item">
          <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden">
            <a href="${item.gambar}" class="glightbox" data-gallery="portfolio-gallery"
              data-title="${escapeHtml(item.judul_portofolio)}"
              data-description="${escapeHtml(item.deskripsi)}">
              <img src="${item.gambar}" class="card-img-top" alt="${escapeHtml(item.alt_gambar || item.judul_portofolio)}"
                style="height: 240px; object-fit: cover;" onerror="this.src='assets/img/Portofolio/portofolio-1.webp'">
            </a>
            <div class="card-body p-4">
              <span class="badge bg-light text-dark border mb-2">${escapeHtml(item.kategori)}</span>
              <h5 class="fw-bold mb-2 text-dark">${escapeHtml(item.judul_portofolio)}</h5>
              <p class="small text-muted mb-3">${escapeHtml(item.deskripsi)}</p>
              <div class="d-flex justify-content-between align-items-center border-top pt-3 small text-muted">
                <span><i class="bi bi-person me-1"></i> ${escapeHtml(item.tim_jurusan_sekolah_kampus)}</span>
                <span class="text-success fw-semibold"><i class="bi bi-check-circle me-1"></i>${escapeHtml(item.status_label || 'Selesai')}</span>
              </div>
            </div>
          </div>
        </div>
      `).join('');
    }
  }

  // =========================================================================
  // 3. RENDER GALERI (Halaman index.html & galeri.html)
  // =========================================================================
  function syncGaleri() {
    const data = getData('galeri');
    if (!data || !Array.isArray(data) || data.length === 0) return;

    // 3.A: Di index.html (Section Galeri Overlay)
    const indexGaleri = document.querySelector('#galeri .row.mobile-horizontal-scroll') || document.querySelector('#gallery .row.mobile-horizontal-scroll');
    if (indexGaleri) {
      indexGaleri.innerHTML = data.slice(0, 6).map((item, index) => `
        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="${(index + 1) * 100}">
          <div class="gallery-card">
            <a href="${item.gambar}" class="glightbox" data-gallery="magang-gallery"
              data-title="${escapeHtml(item.nama)}"
              data-description="${escapeHtml(item.deskripsi)}">
              <img src="${item.gambar}" alt="${escapeHtml(item.alt_gambar || item.nama)}" class="img-fluid" loading="lazy" onerror="this.src='assets/img/Galeri/galeri-1.webp'">
              <div class="gallery-info">
                <h5>${escapeHtml(item.nama)}</h5>
                <p>${escapeHtml(item.deskripsi_singkat || item.deskripsi)}</p>
              </div>
            </a>
          </div>
        </div>
      `).join('');
    }

    // 3.B: Di galeri.html (Grid Standard Card)
    const galeriGrid = document.querySelector('.gallery-container') || document.querySelector('#galeri-grid');
    if (galeriGrid && window.location.pathname.includes('galeri')) {
      galeriGrid.innerHTML = data.map((item, index) => `
        <div class="col-lg-4 col-md-6 isotope-item">
          <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden">
            <a href="${item.gambar}" class="glightbox" data-gallery="magang-gallery"
              data-title="${escapeHtml(item.nama)}"
              data-description="${escapeHtml(item.deskripsi)}">
              <img src="${item.gambar}" class="card-img-top" alt="${escapeHtml(item.alt_gambar || item.nama)}"
                style="height: 240px; object-fit: cover;" onerror="this.src='assets/img/Galeri/galeri-1.webp'">
            </a>
            <div class="card-body p-3">
              <span class="badge bg-light text-dark border mb-2">${escapeHtml(item.kategori)}</span>
              <h6 class="fw-bold mb-1 text-dark">${escapeHtml(item.nama)}</h6>
              <p class="small text-muted mb-0">${escapeHtml(item.deskripsi)}</p>
            </div>
          </div>
        </div>
      `).join('');
    }
  }

  // =========================================================================
  // 4. RENDER ARTIKEL (Halaman index.html & blog.html)
  // =========================================================================
  function syncArtikel() {
    const data = getData('artikel');
    if (!data || !Array.isArray(data) || data.length === 0) return;

    // Di index.html & blog.html (kartu artikel blog)
    const blogContainers = document.querySelectorAll('#blog .row.gy-4, .blog-posts .row.gy-4, #blog-grid');
    blogContainers.forEach(container => {
      container.innerHTML = data.map((item, index) => `
        <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="${(index + 1) * 100}">
          <article class="blog-card h-100">
            <div class="blog-thumb">
              <a href="blog/${escapeHtml(item.slug || 'mengapa-keterampilan-web-dan-digital-marketing-dibutuhkan')}.html">
                <img src="${item.gambar_pertama}" alt="${escapeHtml(item.alt_gambar_pertama || item.judul_artikel)}"
                  class="img-fluid" loading="lazy" width="400" height="250" onerror="this.src='assets/img/blog/artikel-1-utama.webp'">
              </a>
            </div>
            <div class="blog-content">
              <div class="blog-meta">
                <span><i class="bi bi-calendar3"></i> ${escapeHtml(item.tanggal_publish)}</span>
                <span><i class="bi bi-person"></i> ${escapeHtml(item.nama_penulis || 'Fachry Rendy P')}</span>
              </div>
              <h3>
                <a href="blog/${escapeHtml(item.slug || 'mengapa-keterampilan-web-dan-digital-marketing-dibutuhkan')}.html">
                  ${escapeHtml(item.judul_artikel)}
                </a>
              </h3>
              <p>
                ${escapeHtml(item.ringkasan)}
              </p>
              <div>
                <a href="blog/${escapeHtml(item.slug || 'mengapa-keterampilan-web-dan-digital-marketing-dibutuhkan')}.html" class="blog-link">
                  <span>Baca Selengkapnya</span>
                  <i class="bi bi-arrow-right"></i>
                </a>
              </div>
            </div>
          </article>
        </div>
      `).join('');
    });
  }

  // Eksekusi saat DOM siap
  window.addEventListener('DOMContentLoaded', () => {
    syncTestimoni();
    syncPortofolio();
    syncGaleri();
    syncArtikel();

    // Re-inisialisasi GLightbox jika ada elemen gambar baru
    if (typeof GLightbox !== 'undefined') {
      GLightbox({ selector: '.glightbox' });
    }
  });

})();

