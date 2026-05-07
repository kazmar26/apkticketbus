// FILE: backend/middleware/auth.js

const jwt = require('jsonwebtoken');
const pool = require('../config/database');

const authenticateToken = async (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({
            success: false,
            message: 'Token d authentification requis'
        });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        
        const [users] = await pool.query(
            'SELECT * FROM utilisateurs WHERE id = ? AND est_actif = TRUE',
            [decoded.id]
        );
        
        if (users.length === 0) {
            return res.status(401).json({
                success: false,
                message: 'Utilisateur non trouve ou inactif'
            });
        }

        req.user = users[0];
        next();
    } catch (error) {
        return res.status(403).json({
            success: false,
            message: 'Token invalide ou expire'
        });
    }
};

const authorizeAdmin = (req, res, next) => {
    if (req.user.role !== 'admin' && req.user.role !== 'gestionnaire') {
        return res.status(403).json({
            success: false,
            message: 'Acces non autorise. Droits administrateur requis.'
        });
    }
    next();
};

const generateToken = (user) => {
    return jwt.sign(
        { id: user.id, username: user.username, role: user.role },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRE }
    );
};

module.exports = {
    authenticateToken,
    authorizeAdmin,
    generateToken
};