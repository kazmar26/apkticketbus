// FILE: backend/controllers/trajetController.js

const Trajet = require('../models/Trajet');
const { validationResult } = require('express-validator');

exports.getAllTrajets = async (req, res, next) => {
    try {
        const filters = {
            ville_depart: req.query.depart,
            ville_arrivee: req.query.arrivee,
            date: req.query.date,
            min_places: req.query.min_places
        };

        const trajets = await Trajet.findAll(filters);
        
        res.status(200).json({
            success: true,
            count: trajets.length,
            data: trajets
        });
    } catch (error) {
        next(error);
    }
};

exports.getTrajetById = async (req, res, next) => {
    try {
        const trajet = await Trajet.findById(req.params.id);
        
        if (!trajet) {
            return res.status(404).json({
                success: false,
                message: 'Trajet non trouve'
            });
        }

        res.status(200).json({
            success: true,
            data: trajet
        });
    } catch (error) {
        next(error);
    }
};

exports.checkDisponibilite = async (req, res, next) => {
    try {
        const { trajet_id, nombre_places } = req.query;
        
        const disponible = await Trajet.checkAvailability(trajet_id, nombre_places);
        
        res.status(200).json({
            success: true,
            disponible: disponible
        });
    } catch (error) {
        next(error);
    }
};

exports.createTrajet = async (req, res, next) => {
    try {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({
                success: false,
                errors: errors.array()
            });
        }

        const trajet = await Trajet.create(req.body);
        
        res.status(201).json({
            success: true,
            message: 'Trajet cree avec succes',
            data: trajet
        });
    } catch (error) {
        next(error);
    }
};

exports.updateTrajet = async (req, res, next) => {
    try {
        const trajet = await Trajet.update(req.params.id, req.body);
        
        if (!trajet) {
            return res.status(404).json({
                success: false,
                message: 'Trajet non trouve'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Trajet mis a jour avec succes',
            data: trajet
        });
    } catch (error) {
        next(error);
    }
};

exports.deleteTrajet = async (req, res, next) => {
    try {
        const deleted = await Trajet.delete(req.params.id);
        
        if (!deleted) {
            return res.status(404).json({
                success: false,
                message: 'Trajet non trouve'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Trajet supprime avec succes'
        });
    } catch (error) {
        next(error);
    }
};