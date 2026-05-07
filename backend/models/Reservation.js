// FILE: backend/models/Reservation.js

const pool = require('../config/database');

class Reservation {
    static async create(reservationData) {
        const connection = await pool.getConnection();
        
        try {
            await connection.beginTransaction();

            const [codeResult] = await connection.query(
                `SELECT generate_reservation_code() as code`
            );
            const codeReservation = codeResult[0].code;

            const {
                trajet_id, nom_client, telephone, email,
                nombre_places, montant_total
            } = reservationData;

            const [result] = await connection.query(
                `INSERT INTO reservations 
                 (code_reservation, trajet_id, nom_client, telephone, 
                  email, nombre_places, montant_total, statut)
                 VALUES (?, ?, ?, ?, ?, ?, ?, 'en_attente')`,
                [codeReservation, trajet_id, nom_client, telephone,
                 email || null, nombre_places, montant_total]
            );

            await connection.query(
                `CALL update_places_disponibles(?, ?, 'reserver')`,
                [trajet_id, nombre_places]
            );

            await connection.commit();

            return this.findById(result.insertId);
        } catch (error) {
            await connection.rollback();
            throw error;
        } finally {
            connection.release();
        }
    }

    static async findById(id) {
        const [rows] = await pool.query(
            `SELECT * FROM v_reservations_details WHERE id = ?`,
            [id]
        );
        return rows[0];
    }

    static async findByTelephone(telephone) {
        const [rows] = await pool.query(
            `SELECT * FROM v_reservations_details 
             WHERE telephone = ? 
             ORDER BY date_reservation DESC`,
            [telephone]
        );
        return rows;
    }

    static async findByCode(code) {
        const [rows] = await pool.query(
            `SELECT * FROM v_reservations_details WHERE code_reservation = ?`,
            [code]
        );
        return rows[0];
    }

    static async cancel(id) {
        const connection = await pool.getConnection();
        
        try {
            await connection.beginTransaction();

            const [reservation] = await connection.query(
                `SELECT trajet_id, nombre_places, statut 
                 FROM reservations WHERE id = ?`,
                [id]
            );

            if (!reservation[0] || reservation[0].statut === 'annulee') {
                throw new Error('Reservation non trouvee ou deja annulee');
            }

            await connection.query(
                `UPDATE reservations 
                 SET statut = 'annulee', 
                     date_annulation = NOW(),
                     updated_at = NOW()
                 WHERE id = ?`,
                [id]
            );

            await connection.query(
                `CALL update_places_disponibles(?, ?, 'annuler')`,
                [reservation[0].trajet_id, reservation[0].nombre_places]
            );

            await connection.commit();
            return this.findById(id);
        } catch (error) {
            await connection.rollback();
            throw error;
        } finally {
            connection.release();
        }
    }

    static async confirm(id) {
        await pool.query(
            `UPDATE reservations 
             SET statut = 'confirmee', updated_at = NOW()
             WHERE id = ? AND statut = 'en_attente'`,
            [id]
        );
        return this.findById(id);
    }

    static async findAll(filters = {}) {
        let query = `SELECT * FROM v_reservations_details WHERE 1=1`;
        const params = [];

        if (filters.statut) {
            query += ` AND statut = ?`;
            params.push(filters.statut);
        }

        if (filters.telephone) {
            query += ` AND telephone LIKE ?`;
            params.push(`%${filters.telephone}%`);
        }

        if (filters.date_debut) {
            query += ` AND date_reservation >= ?`;
            params.push(filters.date_debut);
        }

        if (filters.date_fin) {
            query += ` AND date_reservation <= ?`;
            params.push(filters.date_fin);
        }

        query += ` ORDER BY date_reservation DESC LIMIT 100`;
        const [rows] = await pool.query(query, params);
        return rows;
    }

    static async getStats() {
        const [stats] = await pool.query(`
            SELECT 
                COUNT(*) as total,
                SUM(CASE WHEN statut = 'en_attente' THEN 1 ELSE 0 END) as en_attente,
                SUM(CASE WHEN statut = 'confirmee' THEN 1 ELSE 0 END) as confirmees,
                SUM(CASE WHEN statut = 'annulee' THEN 1 ELSE 0 END) as annulees,
                SUM(CASE WHEN statut = 'terminee' THEN 1 ELSE 0 END) as terminees,
                SUM(nombre_places) as total_places_reservees,
                SUM(montant_total) as chiffre_affaires
            FROM reservations
            WHERE date_reservation >= DATE_SUB(NOW(), INTERVAL 30 DAY)
        `);
        return stats[0];
    }
}

module.exports = Reservation;