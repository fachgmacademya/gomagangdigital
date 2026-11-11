<?php
/**
 * API Otentikasi Login Admin
 * Memeriksa kredensial login langsung ke tabel `admin` di MySQL phpMyAdmin
 */

header('Content-Type: application/json; charset=utf-8');
session_start();

require_once __DIR__ . '/koneksi.php';

// Pastikan koneksi database aktif
if (!$pdo) {
    echo json_encode([
        'success' => false,
        'message' => 'Gagal terhubung ke database MySQL. Pastikan MySQL di XAMPP/phpMyAdmin sudah aktif dan database db_magang_digital sudah dibuat.'
    ]);
    exit;
}

// Ambil input dari POST atau JSON payload
$input = json_decode(file_get_contents('php://input'), true);
$username = trim($input['username'] ?? $_POST['username'] ?? '');
$password = $input['password'] ?? $_POST['password'] ?? '';

if (empty($username) || empty($password)) {
    echo json_encode([
        'success' => false,
        'message' => 'Username dan password wajib diisi!'
    ]);
    exit;
}

try {
    // Cari admin berdasarkan username atau email di database
    $stmt = $pdo->prepare("SELECT * FROM admin WHERE username = :u OR email = :u LIMIT 1");
    $stmt->execute([':u' => $username]);
    $admin = $stmt->fetch();

    if ($admin) {
        $passwordValid = false;

        // 1. Verifikasi dengan Hash Bcrypt standar
        if (password_verify($password, $admin['password'])) {
            $passwordValid = true;
        } 
        // 2. Fallback: jika di phpMyAdmin user memasukkan MD5
        elseif (md5($password) === $admin['password']) {
            $passwordValid = true;
        } 
        // 3. Fallback: jika di phpMyAdmin user memasukkan teks polos (plain text)
        elseif ($password === $admin['password']) {
            $passwordValid = true;
        }

        if ($passwordValid) {
            // Set session login
            $_SESSION['admin_id'] = $admin['id'];
            $_SESSION['admin_username'] = $admin['username'];
            $_SESSION['admin_name'] = $admin['nama_lengkap'];
            $_SESSION['admin_role'] = $admin['role'];

            echo json_encode([
                'success' => true,
                'message' => 'Login berhasil!',
                'user' => [
                    'id' => $admin['id'],
                    'username' => $admin['username'],
                    'fullName' => $admin['nama_lengkap'],
                    'role' => $admin['role']
                ]
            ]);
            exit;
        }
    }

    // Jika user tidak ditemukan atau password salah
    echo json_encode([
        'success' => false,
        'message' => 'Username atau password yang Anda masukkan salah. Silakan coba lagi.'
    ]);

} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Terjadi kesalahan sistem: ' . $e->getMessage()
    ]);
}
?>
