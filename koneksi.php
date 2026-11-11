<?php
$host = 'localhost';
$user = 'root';
$pass = ''; // Default XAMPP/Laragon biasanya kosong
$db = 'db_magang_digital';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);
} catch (PDOException $e) {
    // Jika koneksi gagal
    $pdo = null;
    $db_error = $e->getMessage();
}
?>