// FILE: backend/models/Trajet.js

const pool = require('../config/database');

class Trajet {
    static async findAll(filters = {}) {
        let query = `
            SELECT 
                t.*,
                vd.nom as ville_depart_nom,
                va.nom as ville_arrivee_nom
            FROM trajets t
            JOIN villes vd ON t.ville_depart = vd.nom
            JOIN villes va ON t.ville_arrivee = va.nom
            WHERE t.est_actif = TRUE
        `;
        const params = [];

        if (filters.ville_depart) {
            query += ` AND t.ville_depart = ?`;
            params.push(filters.ville_depart);
        }

        if (filters.ville_arrivee) {
            query += ` AND t.ville_arrivee = ?`;
            params.push(filters.ville_arrivee);
        }

        if (filters.date) {
            query += ` AND t.date_trajet = ?`;
            params.push(filters.date);
        }

        if (filters.min_places) {
            query += ` AND t.places_disponibles >= ?`;
            params.push(filters.min_places);
        }

        query += ` ORDER BY t.heure_depart ASC`;

        const [rows] = await pool.query(query, params);
        return rows;
    }

    static async findById(id) {
        const [rows] = await pool.query(
            `SELECT 
                t.*,
                vd.nom as ville_depart_nom,
                va.nom as ville_arrivee_nom
            FROM trajets t
            JOIN villes vd ON t.ville_depart = vd.nom
            JOIN villes va ON t.ville_arrivee = va.nom
            WHERE t.id = ?`,
            [id]
        );
        return rows[0];
    }

    static async checkAvailability(id, nombrePlaces) {
        const [rows] = await pool.query(
            `SELECT places_disponibles 
             FROM trajets 
             WHERE id = ? AND places_disponibles >= ? AND est_actif = TRUE`,
            [id, nombrePlaces]
        );
        return rows.length > 0;
    }

    static async updatePlaces(id, nombrePlaces, operation) {
        let query;
        if (operation === 'reserver') {
            query = `UPDATE trajets 
                     SET places_disponibles = places_disponibles - ?,
                         updated_at = NOW()
                     WHERE id = ? AND places_disponibles >= ?`;
            return pool.query(query, [nombrePlaces, id, nombrePlaces]);
        } else if (operation === 'annuler') {
            query = `UPDATE trajets 
                     SET places_disponibles = places_disponibles + ?,
                         updated_at = NOW()
                     WHERE id = ?`;
            return pool.query(query, [nombrePlaces, id]);
        }
    }

    static async create(trajetData) {
        const {
            ville_depart, ville_arrivee, heure_depart, gare_depart,
            duree_estimee, places_total, prix, date_trajet
        } = trajetData;

        const [result] = await pool.query(
            `INSERT INTO trajets 
             (ville_depart, ville_arrivee, heure_depart, gare_depart, 
              duree_estimee, places_total, places_disponibles, prix, date_trajet)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [ville_depart, ville_arrivee, heure_depart, gare_depart,
             duree_estimee, places_total, places_total, prix, date_trajet]
        );
        return this.findById(result.insertId);
    }

    static async update(id, trajetData) {
        const fields = [];
        const values = [];

        for (const [key, value] of Object.entries(trajetData)) {
            if (value !== undefined) {
                fields.push(`${key} = ?`);
                values.push(value);
            }
        }

        if (fields.length === 0) return null;

        values.push(id);
        await pool.query(
            `UPDATE trajets SET ${fields.join(', ')}, updated_at = NOW() WHERE id = ?`,
            values
        );
        return this.findById(id);
    }

    static async delete(id) {
        const [result] = await pool.query(
            `UPDATE trajets SET est_actif = FALSE WHERE id = ?`,
            [id]
        );
        return result.affectedRows > 0;
    }
}

module.exports = Trajet;