const express = require('express');
const router = express.Router();
const { nanoid } = require('nanoid');
const { OAuth2Client } = require('google-auth-library');
const db = require('../config/db');

const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);


function generateToken() {
  return nanoid(30);
}


router.post('/login', (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ message: 'Username dan password wajib diisi' });
  }

  const query = 'SELECT * FROM users WHERE username = ? OR email = ?';
  db.query(query, [username, username], (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Server error' });
    }

    if (results.length === 0) {
      return res.status(401).json({ message: 'Username atau password salah' });
    }

    const user = results[0];

    if (password !== user.password) {
      return res.status(401).json({ message: 'Username atau password salah' });
    }


    const token = generateToken();


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


    const checkQuery = 'SELECT * FROM users WHERE google_id = ? OR email = ?';
    db.query(checkQuery, [googleId, email], (err, results) => {
      if (err) {
        return res.status(500).json({ message: 'Server error' });
      }

      if (results.length > 0) {
        const user = results[0];


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

        const username = email.split('@')[0] + '_' + Math.floor(Math.random() * 1000);
        const dummyPassword = nanoid(20);

        const insertQuery = 'INSERT INTO users (username, email, password, role, google_id) VALUES (?, ?, ?, ?, ?)';
        db.query(insertQuery, [username, email, dummyPassword, 'user', googleId], (err3, insertResult) => {
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
