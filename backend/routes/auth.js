const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const { nanoid } = require('nanoid');
const { OAuth2Client } = require('google-auth-library');
const db = require('../config/db');

const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

// Generate token alphanumeric minimal 20 karakter
function generateToken() {
  return nanoid(30); // 30 karakter alphanumeric
}

// POST /api/auth/login - login dengan username/password dari DB
router.post('/login', (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ message: 'Username dan password wajib diisi' });
  }

  const query = 'SELECT * FROM users WHERE username = ? OR email = ?';
  db.query(query, [username, username], async (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Server error' });
    }

    if (results.length === 0) {
      return res.status(401).json({ message: 'Username atau password salah' });
    }

    const user = results[0];

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Username atau password salah' });
    }

    // Generate token baru
    const token = generateToken();

    // Simpan token ke tabel user_tokens
    const saveToken = 'INSERT INTO user_tokens (user_id, token) VALUES (?, ?) ON DUPLICATE KEY UPDATE token = ?';
    db.query(saveToken, [user.id, token, token], (err2) => {
      if (err2) {
        return res.status(500).json({ message: 'Gagal generate token' });
      }

      return res.json({
        message: 'Login berhasil',
        token: token,
        user: {
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
        },
      });
    });
  });
});

// POST /api/auth/google - login dengan Google OAuth
router.post('/google', async (req, res) => {
  const { idToken } = req.body;

  if (!idToken) {
    return res.status(400).json({ message: 'Google ID token tidak ditemukan' });
  }

  try {
    const ticket = await googleClient.verifyIdToken({
      idToken: idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    const googleId = payload['sub'];
    const email = payload['email'];
    const name = payload['name'];

    // Cek apakah user dengan google_id ini sudah ada
    const checkQuery = 'SELECT * FROM users WHERE google_id = ? OR email = ?';
    db.query(checkQuery, [googleId, email], (err, results) => {
      if (err) {
        return res.status(500).json({ message: 'Server error' });
      }

      let user = null;

      if (results.length > 0) {
        user = results[0];

        // Update google_id kalau belum ada
        if (!user.google_id) {
          db.query('UPDATE users SET google_id = ? WHERE id = ?', [googleId, user.id]);
        }

        const token = generateToken();
        const saveToken = 'INSERT INTO user_tokens (user_id, token) VALUES (?, ?) ON DUPLICATE KEY UPDATE token = ?';
        db.query(saveToken, [user.id, token, token], (err2) => {
          if (err2) {
            return res.status(500).json({ message: 'Gagal generate token' });
          }

          return res.json({
            message: 'Login dengan Google berhasil',
            token: token,
            user: {
              id: user.id,
              username: user.username,
              email: user.email,
              role: user.role,
            },
          });
        });
      } else {
        // Buat user baru dari Google
        const username = email.split('@')[0] + '_' + Math.floor(Math.random() * 1000);
        const dummyPassword = nanoid(20);
        const hashedPassword = bcrypt.hashSync(dummyPassword, 10);

        const insertQuery = 'INSERT INTO users (username, email, password, role, google_id) VALUES (?, ?, ?, ?, ?)';
        db.query(insertQuery, [username, email, hashedPassword, 'user', googleId], (err3, insertResult) => {
          if (err3) {
            return res.status(500).json({ message: 'Gagal membuat akun baru' });
          }

          const newUserId = insertResult.insertId;
          const token = generateToken();

          const saveToken = 'INSERT INTO user_tokens (user_id, token) VALUES (?, ?)';
          db.query(saveToken, [newUserId, token], (err4) => {
            if (err4) {
              return res.status(500).json({ message: 'Gagal generate token' });
            }

            return res.json({
              message: 'Registrasi via Google berhasil',
              token: token,
              user: {
                id: newUserId,
                username: username,
                email: email,
                role: 'user',
              },
            });
          });
        });
      }
    });
  } catch (error) {
    return res.status(401).json({ message: 'Google token tidak valid: ' + error.message });
  }
});

// POST /api/auth/logout
router.post('/logout', (req, res) => {
  const authHeader = req.headers['authorization'];
  if (!authHeader) {
    return res.status(400).json({ message: 'Token tidak ditemukan' });
  }

  const token = authHeader.split(' ')[1];
  db.query('DELETE FROM user_tokens WHERE token = ?', [token], (err) => {
    if (err) {
      return res.status(500).json({ message: 'Gagal logout' });
    }
    return res.json({ message: 'Logout berhasil' });
  });
});

module.exports = router;
