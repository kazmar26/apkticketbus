// FILE: backend/controllers/reservationController.js

const Reservation = require('../models/Reservation');
const Trajet = require('../models/Trajet');
const { validationResult } = require('express-validator');

exports.createReservation = async (req, res, next) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                success: false,
                errors: errors.array()
            });
        }

        const { trajet_id, nombre_places } = req.body;

        const disponible = await Trajet.checkAvailability(trajet_id, nombre_places);
        if (!disponible) {
            return res.status(400).json({
                success: false,
                message: 'Places non disponibles pour ce trajet'
            });
        }

        const trajet = await Trajet.findById(trajet_id);
        if (!trajet) {
            return res.status(404).json({
                success: false,
                message: 'Trajet non trouve'
            });
        }

        const montant_total = trajet.prix * nombre_places;
        const reservationData = {
            ...req.body,
            montant_total
        };

        const reservation = await Reservation.create(reservationData);
        
        res.status(201).json({
            success: true,
            message: 'Reservation cree avec succes',
            data: reservation
        });
    } catch (error) {
        next(error);
    }
};

exports.getReservationsByPhone = async (req, res, next) => {
    try {
        const { telephone } = req.query;
        
        if (!telephone) {
            return res.status(400).json({
                success: false,
                message: 'Le numero de telephone est requis'
            });
        }

        const reservations = await Reservation.findByTelephone(telephone);
        
        res.status(200).json({
            success: true,
            count: reservations.length,
            data: reservations
        });
    } catch (error) {
        next(error);
    }
};

exports.getReservationByCode = async (req, res, next) => {
    try {
        const { code } = req.params;
        
        const reservation = await Reservation.findByCode(code);
        
        if (!reservation) {
            return res.status(404).json({
                success: false,
                message: 'Reservation non trouvee'
            });
        }

        res.status(200).json({
            success: true,
            data: reservation
        });
    } catch (error) {
        next(error);
    }
};

exports.cancelReservation = async (req, res, next) => {
    try {
        const reservation = await Reservation.cancel(req.params.id);
        
        res.status(200).json({
            success: true,
            message: 'Reservation annulee avec succes',
            data: reservation
        });
    } catch (error) {
        next(error);
    }
};

exports.getAllReservations = async (req, res, next) => {
    try {
        const filters = {
            statut: req.query.statut,
            telephone: req.query.telephone,
            date_debut: req.query.date_debut,
            date_fin: req.query.date_fin
        };

        const reservations = await Reservation.findAll(filters);
        
        res.status(200).json({
            success: true,
            count: reservations.length,
            data: reservations
        });
    } catch (error) {
        next(error);
    }
};

exports.confirmReservation = async (req, res, next) => {
    try {
        const reservation = await Reservation.confirm(req.params.id);
        
        if (!reservation) {
            return res.status(404).json({
                success: false,
                message: 'Reservation non trouvee'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Reservation confirmee',
            data: reservation
        });
    } catch (error) {
        next(error);
    }
};

exports.getStats = async (req, res, next) => {
    try {
        const stats = await Reservation.getStats();
        
        res.status(200).json({
            success: true,
            data: stats
        });
    } catch (error) {
        next(error);
    }
};