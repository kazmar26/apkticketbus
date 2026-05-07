// FILE: backend/middleware/validation.js

const { validationResult } = require('express-validator');

const validateRequest = (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({
            success: false,
            errors: errors.array().map(err => ({
                field: err.param,
                message: err.msg
            }))
        });
    }
    next();
};

const validateTrajet = {
    ville_depart: {
        notEmpty: { errorMessage: 'La ville de depart est requise' },
        isString: { errorMessage: 'La ville de depart doit etre une chaine' }
    },
    ville_arrivee: {
        notEmpty: { errorMessage: "La ville d'arrivee est requise" },
        isString: { errorMessage: "La ville d'arrivee doit etre une chaine" }
    },
    heure_depart: {
        matches: { 
            options: /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/,
            errorMessage: 'Format d heure invalide (HH:MM)'
        }
    },
    gare_depart: {
        notEmpty: { errorMessage: 'La gare de depart est requise' }
    },
    duree_estimee: {
        isInt: { 
            options: { min: 1 },
            errorMessage: 'La duree doit etre un nombre positif'
        }
    },
    prix: {
        isInt: { 
            options: { min: 0 },
            errorMessage: 'Le prix doit etre un nombre positif'
        }
    }
};

const validateReservation = {
    trajet_id: {
        isInt: { errorMessage: 'L ID du trajet doit etre un nombre entier' }
    },
    nom_client: {
        notEmpty: { errorMessage: 'Le nom du client est requis' },
        isLength: { 
            options: { min: 2 },
            errorMessage: 'Le nom doit contenir au moins 2 caracteres'
        }
    },
    telephone: {
        notEmpty: { errorMessage: 'Le telephone est requis' },
        isLength: { 
            options: { min: 9, max: 15 },
            errorMessage: 'Le telephone doit contenir entre 9 et 15 caracteres'
        }
    },
    nombre_places: {
        isInt: { 
            options: { min: 1, max: 10 },
            errorMessage: 'Le nombre de places doit etre entre 1 et 10'
        }
    }
};

module.exports = {
    validateRequest,
    validateTrajet,
    validateReservation
};