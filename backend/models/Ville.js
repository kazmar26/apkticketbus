// FILE: backend/models/Ville.js

const pool = require('../config/database');

class Ville {
    static async findAll() {
        const [rows] = await pool.query(
            'SELECT * FROM villes ORDER BY nom ASC'
        );
        return rows;
    }

    static async findById(id) {
        const [rows] = await pool.query(
            'SELECT * FROM villes WHERE id = ?',
            [id]
        );
        return rows[0];
    }

    static async findByNom(nom) {
        const [rows] = await pool.query(
            'SELECT * FROM villes WHERE nom = ?',
            [nom]
        );
        return rows[0];
    }

    static async create(villeData) {
        const { nom, code } = villeData;
        const [result] = await pool.query(
            'INSERT INTO villes (nom, code) VALUES (?, ?)',
            [nom, code]
        );
        return this.findById(result.insertId);
    }

    static async update(id, villeData) {
        const { nom, code } = villeData;
        await pool.query(
            'UPDATE villes SET nom = ?, code = ? WHERE id = ?',
            [nom, code, id]
        );
        return this.findById(id);
    }

    static async delete(id) {
        const [result] = await pool.query(
            'DELETE FROM villes WHERE id = ?',
            [id]
        );
        return result.affectedRows > 0;
    }
}

module.exports = Ville;