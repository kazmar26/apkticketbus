// FILE: backend/controllers/villeController.js

const pool = require('../config/database');

exports.getAllVilles = async (req, res, next) => {
    try {
        const [villes] = await pool.query(
            'SELECT * FROM villes ORDER BY nom ASC'
        );
        
        res.status(200).json({
            success: true,
            count: villes.length,
            data: villes
        });
    } catch (error) {
        next(error);
    }
};

exports.getVilleById = async (req, res, next) => {
    try {
        const [villes] = await pool.query(
            'SELECT * FROM villes WHERE id = ?',
            [req.params.id]
        );
        
        if (villes.length === 0) {
            return res.status(404).json({
                success: false,
                message: 'Ville non trouvee'
            });
        }

        res.status(200).json({
            success: true,
            data: villes[0]
        });
    } catch (error) {
        next(error);
    }
};

exports.createVille = async (req, res, next) => {
    try {
        const { nom, code } = req.body;
        
        const [result] = await pool.query(
            'INSERT INTO villes (nom, code) VALUES (?, ?)',
            [nom, code]
        );
        
        const [newVille] = await pool.query(
            'SELECT * FROM villes WHERE id = ?',
            [result.insertId]
        );
        
        res.status(201).json({
            success: true,
            message: 'Ville cree avec succes',
            data: newVille[0]
        });
    } catch (error) {
        next(error);
    }
};

exports.updateVille = async (req, res, next) => {
    try {
        const { nom, code } = req.body;
        
        await pool.query(
            'UPDATE villes SET nom = ?, code = ? WHERE id = ?',
            [nom, code, req.params.id]
        );
        
        const [updatedVille] = await pool.query(
            'SELECT * FROM villes WHERE id = ?',
            [req.params.id]
        );
        
        res.status(200).json({
            success: true,
            message: 'Ville mise a jour avec succes',
            data: updatedVille[0]
        });
    } catch (error) {
        next(error);
    }
};

exports.deleteVille = async (req, res, next) => {
    try {
        await pool.query(
            'DELETE FROM villes WHERE id = ?',
            [req.params.id]
        );
        
        res.status(200).json({
            success: true,
            message: 'Ville supprimee avec succes'
        });
    } catch (error) {
        next(error);
    }
};