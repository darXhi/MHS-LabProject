const express = require('express');
const router = express.Router();
const db = require('../config/db');
const { verifyToken } = require('../middleware/auth');

// GET /api/transactions - ambil riwayat transaksi user yang login
router.get('/', verifyToken, (req, res) => {
  const userId = req.user.id;
  const query = `
    SELECT t.id, t.quantity, t.total_price, t.created_at,
           r.name AS resource_name, r.type AS resource_type, r.image AS resource_image
    FROM transactions t
    JOIN resources r ON t.resource_id = r.id
    WHERE t.user_id = ?
    ORDER BY t.created_at DESC
  `;
  db.query(query, [userId], (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Gagal mengambil data transaksi' });
    }
    return res.json({
      message: 'Berhasil',
      data: results,
    });
  });
});

// POST /api/transactions/buy - beli resource
router.post('/buy', verifyToken, (req, res) => {
  const { resource_id, quantity } = req.body;
  const userId = req.user.id;

  if (!resource_id || !quantity) {
    return res.status(400).json({ message: 'resource_id dan quantity wajib diisi' });
  }

  if (isNaN(quantity) || parseInt(quantity) <= 0) {
    return res.status(400).json({ message: 'Quantity harus lebih dari 0' });
  }

  const qty = parseInt(quantity);

  // Cek resource dan stok
  db.query('SELECT * FROM resources WHERE id = ?', [resource_id], (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Server error' });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: 'Resource tidak ditemukan' });
    }

    const resource = results[0];

    if (resource.stock < qty) {
      return res.status(400).json({ message: `Stok tidak cukup. Stok tersedia: ${resource.stock}` });
    }

    const totalPrice = resource.price * qty;

    // Kurangi stok
    db.query('UPDATE resources SET stock = stock - ? WHERE id = ?', [qty, resource_id], (err2) => {
      if (err2) {
        return res.status(500).json({ message: 'Gagal mengupdate stok' });
      }

      // Simpan transaksi
      const insertQuery = 'INSERT INTO transactions (user_id, resource_id, quantity, total_price) VALUES (?, ?, ?, ?)';
      db.query(insertQuery, [userId, resource_id, qty, totalPrice], (err3, result) => {
        if (err3) {
          return res.status(500).json({ message: 'Gagal menyimpan transaksi' });
        }

        return res.status(201).json({
          message: 'Pembelian berhasil!',
          transaction: {
            id: result.insertId,
            resource_name: resource.name,
            quantity: qty,
            total_price: totalPrice,
          },
        });
      });
    });
  });
});

module.exports = router;
