const db = require('../config/db');


function verifyToken(req, res, next) {
  const authHeader = req.headers['authorization'];

  if (!authHeader) {
    return res.status(401).json({ message: 'Token tidak ditemukan' });
  }

  const token = authHeader.split(' ')[1]; 

  if (!token) {
    return res.status(401).json({ message: 'Format token salah' });
  }


  const query = 'SELECT u.id, u.username, u.email, u.role FROM users u JOIN user_tokens t ON u.id = t.user_id WHERE t.token = ?';
  db.query(query, [token], (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Server error' });
    }
    if (results.length === 0) {
      return res.status(401).json({ message: 'Token tidak valid atau sudah expired' });
    }

    req.user = results[0];
    next();
  });
}


function verifyAdmin(req, res, next) {
  verifyToken(req, res, () => {
    if (req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Akses ditolak. Hanya admin yang bisa melakukan ini.' });
    }
    next();
  });
}

module.exports = { verifyToken, verifyAdmin };
