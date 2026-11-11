<?php
/**
 * REST API Backend untuk Dashboard Admin
 * Menghubungkan Dashboard Admin secara Realtime dengan Database MySQL phpMyAdmin (db_magang_digital)
 */

header('Content-Type: application/json; charset=utf-8');
require_once __DIR__ . '/koneksi.php';

if (!$pdo) {
    echo json_encode([
        'success' => false,
        'message' => 'Koneksi database MySQL gagal: ' . ($db_error ?? 'Periksa server MySQL di XAMPP/phpMyAdmin')
    ]);
    exit;
}

$action = $_GET['action'] ?? '';
$input = json_decode(file_get_contents('php://input'), true) ?? $_POST;

try {
    switch ($action) {
        // -------------------------------------------------------------
        // 1. GET ALL DATA (TESTIMONI, PORTOFOLIO, GALERI, ARTIKEL)
        // -------------------------------------------------------------
        case 'get_all':
            $testimoni = $pdo->query("SELECT * FROM `testimoni` ORDER BY `urutan` ASC, `id` ASC")->fetchAll();
            $portofolio = $pdo->query("SELECT * FROM `portofolio` ORDER BY `urutan` ASC, `id` ASC")->fetchAll();
            $galeri = $pdo->query("SELECT * FROM `galeri` ORDER BY `urutan` ASC, `id` ASC")->fetchAll();
            $artikel = $pdo->query("SELECT * FROM `artikel` ORDER BY `id` ASC")->fetchAll();

            echo json_encode([
                'success' => true,
                'data' => [
                    'testimoni' => $testimoni,
                    'portofolio' => $portofolio,
                    'galeri' => $galeri,
                    'artikel' => $artikel
                ]
            ]);
            break;

        // -------------------------------------------------------------
        // 2. CRUD TESTIMONI
        // -------------------------------------------------------------
        case 'save_testimoni':
            $id = $input['id'] ?? null;
            $nama = trim($input['nama'] ?? '');
            $asal = trim($input['asal_sekolah_kampus'] ?? '');
            $jurusan = trim($input['jurusan'] ?? '');
            $isi = trim($input['isi_testimoni'] ?? '');

            if ($id) {
                $stmt = $pdo->prepare("UPDATE `testimoni` SET `nama` = ?, `asal_sekolah_kampus` = ?, `jurusan` = ?, `isi_testimoni` = ? WHERE `id` = ?");
                $stmt->execute([$nama, $asal, $jurusan, $isi, $id]);
            } else {
                $maxUrutan = (int)$pdo->query("SELECT MAX(`urutan`) FROM `testimoni`")->fetchColumn();
                $stmt = $pdo->prepare("INSERT INTO `testimoni` (`nama`, `asal_sekolah_kampus`, `jurusan`, `isi_testimoni`, `urutan`, `is_aktif`) VALUES (?, ?, ?, ?, ?, 1)");
                $stmt->execute([$nama, $asal, $jurusan, $isi, $maxUrutan + 1]);
            }
            echo json_encode(['success' => true, 'message' => 'Data testimoni berhasil disimpan ke database MySQL!']);
            break;

        case 'delete_testimoni':
            $id = $input['id'] ?? null;
            if ($id) {
                $stmt = $pdo->prepare("DELETE FROM `testimoni` WHERE `id` = ?");
                $stmt->execute([$id]);
            }
            echo json_encode(['success' => true, 'message' => 'Testimoni berhasil dihapus dari database MySQL!']);
            break;

        // -------------------------------------------------------------
        // 3. CRUD PORTOFOLIO
        // -------------------------------------------------------------
        case 'save_portofolio':
            $id = $input['id'] ?? null;
            $judul = trim($input['judul_portofolio'] ?? '');
            $slug = strtolower(trim(preg_replace('/[^A-Za-z0-9-]+/', '-', $judul)));
            $kategori = trim($input['kategori'] ?? 'Website Perusahaan');
            $tim = trim($input['tim_jurusan_sekolah_kampus'] ?? '');
            $gambar = trim($input['gambar'] ?? 'assets/img/Portofolio/portofolio-1.webp');
            $deskripsi = trim($input['deskripsi'] ?? '');
            $is_online = !empty($input['is_online']) ? 1 : 0;
            $link_hasil = $input['link_hasil'] ?? null;

            if ($id) {
                $stmt = $pdo->prepare("UPDATE `portofolio` SET `judul_portofolio` = ?, `slug` = ?, `kategori` = ?, `tim_jurusan_sekolah_kampus` = ?, `gambar` = ?, `alt_gambar` = ?, `deskripsi` = ?, `is_online` = ?, `link_hasil` = ? WHERE `id` = ?");
                $stmt->execute([$judul, $slug, $kategori, $tim, $gambar, $judul, $deskripsi, $is_online, $link_hasil, $id]);
            } else {
                $maxUrutan = (int)$pdo->query("SELECT MAX(`urutan`) FROM `portofolio`")->fetchColumn();
                $stmt = $pdo->prepare("INSERT INTO `portofolio` (`judul_portofolio`, `slug`, `kategori`, `tim_jurusan_sekolah_kampus`, `gambar`, `alt_gambar`, `deskripsi`, `is_online`, `link_hasil`, `status_label`, `urutan`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Selesai', ?)");
                $stmt->execute([$judul, $slug, $kategori, $tim, $gambar, $judul, $deskripsi, $is_online, $link_hasil, $maxUrutan + 1]);
            }
            echo json_encode(['success' => true, 'message' => 'Portofolio berhasil disimpan ke database MySQL!']);
            break;

        case 'delete_portofolio':
            $id = $input['id'] ?? null;
            if ($id) {
                $stmt = $pdo->prepare("DELETE FROM `portofolio` WHERE `id` = ?");
                $stmt->execute([$id]);
            }
            echo json_encode(['success' => true, 'message' => 'Portofolio berhasil dihapus dari database MySQL!']);
            break;

        // -------------------------------------------------------------
        // 4. CRUD GALERI
        // -------------------------------------------------------------
        case 'save_galeri':
            $id = $input['id'] ?? null;
            $nama = trim($input['nama'] ?? '');
            $kategori = trim($input['kategori'] ?? 'Bimbingan & Mentoring');
            $gambar = trim($input['gambar'] ?? 'assets/img/Galeri/galeri-1.webp');
            $deskripsi = trim($input['deskripsi'] ?? '');
            $deskripsi_singkat = trim($input['deskripsi_singkat'] ?? '');

            if ($id) {
                $stmt = $pdo->prepare("UPDATE `galeri` SET `nama` = ?, `kategori` = ?, `gambar` = ?, `alt_gambar` = ?, `deskripsi` = ?, `deskripsi_singkat` = ? WHERE `id` = ?");
                $stmt->execute([$nama, $kategori, $gambar, $nama, $deskripsi, $deskripsi_singkat, $id]);
            } else {
                $maxUrutan = (int)$pdo->query("SELECT MAX(`urutan`) FROM `galeri`")->fetchColumn();
                $stmt = $pdo->prepare("INSERT INTO `galeri` (`nama`, `kategori`, `gambar`, `alt_gambar`, `deskripsi`, `deskripsi_singkat`, `urutan`) VALUES (?, ?, ?, ?, ?, ?, ?)");
                $stmt->execute([$nama, $kategori, $gambar, $nama, $deskripsi, $deskripsi_singkat, $maxUrutan + 1]);
            }
            echo json_encode(['success' => true, 'message' => 'Galeri berhasil disimpan ke database MySQL!']);
            break;

        case 'delete_galeri':
            $id = $input['id'] ?? null;
            if ($id) {
                $stmt = $pdo->prepare("DELETE FROM `galeri` WHERE `id` = ?");
                $stmt->execute([$id]);
            }
            echo json_encode(['success' => true, 'message' => 'Galeri berhasil dihapus dari database MySQL!']);
            break;

        // -------------------------------------------------------------
        // 5. CRUD ARTIKEL
        // -------------------------------------------------------------
        case 'save_artikel':
            $id = $input['id'] ?? null;
            $judul = trim($input['judul_artikel'] ?? '');
            $slug = strtolower(trim(preg_replace('/[^A-Za-z0-9-]+/', '-', $judul)));
            $label = trim($input['label_artikel'] ?? 'Program Magang');
            $g1 = trim($input['gambar_pertama'] ?? 'assets/img/blog/artikel-1-utama.webp');
            $alt1 = trim($input['alt_gambar_pertama'] ?? $judul);
            $cap1 = trim($input['caption_gambar_pertama'] ?? '');
            $g2 = trim($input['gambar_kedua'] ?? 'assets/img/blog/artikel-1-pendukung.webp');
            $alt2 = trim($input['alt_gambar_kedua'] ?? $judul);
            $cap2 = trim($input['caption_gambar_kedua'] ?? '');
            $ringkasan = trim($input['ringkasan'] ?? '');
            $isi = trim($input['isi_artikel'] ?? '');
            $penulis = trim($input['nama_penulis'] ?? 'Fachry Rendy P');
            $profil = trim($input['profil_penulis'] ?? null);

            if ($id) {
                $stmt = $pdo->prepare("UPDATE `artikel` SET `judul_artikel` = ?, `slug` = ?, `label_artikel` = ?, `gambar_pertama` = ?, `alt_gambar_pertama` = ?, `caption_gambar_pertama` = ?, `gambar_kedua` = ?, `alt_gambar_kedua` = ?, `caption_gambar_kedua` = ?, `ringkasan` = ?, `isi_artikel` = ?, `nama_penulis` = ?, `profil_penulis` = ? WHERE `id` = ?");
                $stmt->execute([$judul, $slug, $label, $g1, $alt1, $cap1, $g2, $alt2, $cap2, $ringkasan, $isi, $penulis, $profil, $id]);
            } else {
                $tgl = date('Y-m-d');
                $stmt = $pdo->prepare("INSERT INTO `artikel` (`judul_artikel`, `slug`, `label_artikel`, `gambar_pertama`, `alt_gambar_pertama`, `caption_gambar_pertama`, `gambar_kedua`, `alt_gambar_kedua`, `caption_gambar_kedua`, `ringkasan`, `isi_artikel`, `nama_penulis`, `profil_penulis`, `tanggal_publish`, `views`, `status`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 150, 'published')");
                $stmt->execute([$judul, $slug, $label, $g1, $alt1, $cap1, $g2, $alt2, $cap2, $ringkasan, $isi, $penulis, $profil, $tgl]);
            }
            echo json_encode(['success' => true, 'message' => 'Artikel berhasil disimpan ke database MySQL!']);
            break;

        case 'delete_artikel':
            $id = $input['id'] ?? null;
            if ($id) {
                $stmt = $pdo->prepare("DELETE FROM `artikel` WHERE `id` = ?");
                $stmt->execute([$id]);
            }
            echo json_encode(['success' => true, 'message' => 'Artikel berhasil dihapus dari database MySQL!']);
            break;

        default:
            echo json_encode(['success' => false, 'message' => 'Action tidak dikenali.']);
            break;
    }

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Terjadi kesalahan query MySQL: ' . $e->getMessage()
    ]);
}
?>
