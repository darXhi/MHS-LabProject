const express = require('express');
const router = express.Router();
const db = require('../config/db');
const { verifyToken, verifyAdmin } = require('../middleware/auth');


router.get('/', verifyToken, (req, res) => {
  const query = 'SELECT * FROM resources ORDER BY created_at DESC';
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Gagal mengambil data resource' });
    }
    return res.json({
      message: 'Berhasil',
      data: results,
    });
  });
});


router.get('/:id', verifyToken, (req, res) => {
  const { id } = req.params;
  const query = 'SELECT * FROM resources WHERE id = ?';
  db.query(query, [id], (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Server error' });
    }
    if (results.length === 0) {
      return res.status(404).json({ message: 'Resource tidak ditemukan' });
    }
    return res.json({
      message: 'Berhasil',
      data: results[0],
    });
  });
});


router.post('/', verifyAdmin, (req, res) => {
  const { name, type, description, stock, image, price } = req.body;

  if (!name || !type || !price) {
    return res.status(400).json({ message: 'Name, type, dan price wajib diisi' });
  }

  if (isNaN(price) || parseFloat(price) < 0) {
    return res.status(400).json({ message: 'Price harus angka dan tidak boleh negatif' });
  }

  if (isNaN(stock) || parseInt(stock) < 0) {
    return res.status(400).json({ message: 'Stock harus angka dan tidak boleh negatif' });
  }

  const query = 'INSERT INTO resources (name, type, description, stock, image, price) VALUES (?, ?, ?, ?, ?, ?)';
  db.query(query, [name, type, description || '', parseInt(stock) || 0, image || '', parseFloat(price)], (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Gagal menambahkan resource' });
    }
    return res.status(201).json({
      message: 'Resource berhasil ditambahkan',
      id: result.insertId,
    });
  });
});


router.put('/:id', verifyAdmin, (req, res) => {
  const { id } = req.params;
  const { name, type, description, stock, image, price } = req.body;

  if (!name || !type || !price) {
    return res.status(400).json({ message: 'Name, type, dan price wajib diisi' });
  }

  if (isNaN(price) || parseFloat(price) < 0) {
    return res.status(400).json({ message: 'Price tidak boleh negatif' });
  }

  if (isNaN(stock) || parseInt(stock) < 0) {
    return res.status(400).json({ message: 'Stock tidak boleh negatif' });
  }

  const query = 'UPDATE resources SET name = ?, type = ?, description = ?, stock = ?, image = ?, price = ? WHERE id = ?';
  db.query(query, [name, type, description || '', parseInt(stock), image || '', parseFloat(price), id], (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Gagal mengupdate resource' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Resource tidak ditemukan' });
    }
    return res.json({ message: 'Resource berhasil diupdate' });
  });
});


router.delete('/:id', verifyAdmin, (req, res) => {
  const { id } = req.params;
  const query = 'DELETE FROM resources WHERE id = ?';
  db.query(query, [id], (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Gagal menghapus resource' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Resource tidak ditemukan' });
    }
    return res.json({ message: 'Resource berhasil dihapus' });
  });
});

module.exports = router;
