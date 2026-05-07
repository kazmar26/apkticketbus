// FILE: backend/routes/admin.js

const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const pool = require('../config/database');
const { authenticateToken, authorizeAdmin, generateToken } = require('../middleware/auth');
const { body } = require('express-validator');

router.post('/login',
    [
        body('username').notEmpty(),
        body('password').notEmpty()
    ],
    async (req, res, next) => {
        try {
            const { username, password } = req.body;
            
            const [users] = await pool.query(
                'SELECT * FROM utilisateurs WHERE username = ? AND est_actif = TRUE',
                [username]
            );
            
            if (users.length === 0) {
                return res.status(401).json({
                    success: false,
                    message: 'Identifiants invalides'
                });
            }
            
            const user = users[0];
            const isValidPassword = await bcrypt.compare(password, user.password_hash);
            
            if (!isValidPassword) {
                return res.status(401).json({
                    success: false,
                    message: 'Identifiants invalides'
                });
            }
            
            await pool.query(
                'UPDATE utilisateurs SET last_login = NOW() WHERE id = ?',
                [user.id]
            );
            
            const token = generateToken(user);
            
            res.status(200).json({
                success: true,
                token: token,
                user: {
                    id: user.id,
                    username: user.username,
                    nom_complet: user.nom_complet,
                    role: user.role
                }
            });
        } catch (error) {
            next(error);
        }
    }
);

router.get('/verify', authenticateToken, (req, res) => {
    res.status(200).json({
        success: true,
        user: {
            id: req.user.id,
            username: req.user.username,
            nom_complet: req.user.nom_complet,
            role: req.user.role
        }
    });
});

module.exports = router;