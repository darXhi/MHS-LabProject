-- ============================================================
-- Honkai Star Retail - Database Schema
-- MySQL (XAMPP)
-- ============================================================

CREATE DATABASE IF NOT EXISTS honkai_star_retail;
USE honkai_star_retail;

-- Tabel users (untuk login dan role)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user') NOT NULL DEFAULT 'user',
    google_id VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel resources (item yang dijual)
CREATE TABLE IF NOT EXISTS resources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    type VARCHAR(100) NOT NULL,
    description TEXT,
    stock INT NOT NULL DEFAULT 0,
    image VARCHAR(255) DEFAULT NULL,
    price DECIMAL(15, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabel untuk menyimpan bearer token login
CREATE TABLE IF NOT EXISTS user_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    token VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tabel transactions (riwayat pembelian user)
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    resource_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    total_price DECIMAL(15, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (resource_id) REFERENCES resources(id)
);

-- ============================================================
-- Seed Data
-- ============================================================

-- Password untuk semua user adalah: password123
-- Hash bcrypt untuk 'password123'
INSERT INTO users (username, email, password, role) VALUES
('admin', 'admin@honkaistar.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'),
('user1', 'user1@gmail.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('user2', 'user2@gmail.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user');

-- Resource data (galactic resources and light cones)
INSERT INTO resources (name, type, description, stock, image, price) VALUES
('Stellar Jade', 'Galactic Resource', 'The primary currency used to obtain new characters and light cones through the Warp system. A precious resource across the galaxy.', 500, 'stellar_jade.png', 15000),
('Trailblaze Power', 'Galactic Resource', 'The energy that powers your trailblazing journey. Used to enter Calyxes, Cavern of Corrosion, and Simulated Universe.', 200, 'trailblaze_power.png', 5000),
('Credit', 'Galactic Resource', 'Standard currency of the Astral Express. Used for character upgrades, light cone leveling, and relic enhancement.', 1000, 'credit.png', 1000),
('Oneiric Shard', 'Galactic Resource', 'A special resource used exclusively in the Embers Exchange shop. Obtained from various in-game activities.', 150, 'oneiric_shard.png', 25000),
('Lost Crystal', 'Galactic Resource', 'Rare crystallized fragments from forgotten star systems. Used to craft advanced materials and equipment.', 100, 'lost_crystal.png', 35000),
('Memory of Chaos Pass', 'Galactic Resource', 'Grants access to the Memory of Chaos game mode where you can earn rich rewards based on your performance.', 50, 'moc_pass.png', 20000),
('Sparkle Light Cone', 'Light Cone', 'A 5-star Light Cone for The Harmony path. Amplifies the skill points and damage of teammates.', 30, 'sparkle_lc.png', 750000),
('Acheron Light Cone', 'Light Cone', 'A 5-star Light Cone designed for The Nihility path. Greatly increases the wearer damage output.', 25, 'acheron_lc.png', 750000),
('Robin Light Cone', 'Light Cone', 'A 5-star Light Cone for The Harmony path. Increases ATK for all allies and boosts follow-up attacks.', 20, 'robin_lc.png', 750000),
('Firefly Light Cone', 'Light Cone', 'A 5-star Light Cone for The Destruction path. Enhances break effect and increases the wearer SPD.', 15, 'firefly_lc.png', 750000),
('Planetary Rendezvous', 'Light Cone', 'A 4-star Light Cone for The Harmony path. After entering battle, increases DMG dealt by all allies.', 100, 'planetary_rv.png', 150000),
('Fermata', 'Light Cone', 'A 4-star Light Cone for The Nihility path. Increases Break Effect for the wearer significantly.', 80, 'fermata_lc.png', 150000);
