// FILE: backend/utils/validationRules.js

const { body } = require('express-validator');

const trajetValidationRules = () => {
    return [
        body('ville_depart')
            .notEmpty().withMessage('La ville de depart est requise')
            .isString().withMessage('La ville de depart doit etre une chaine'),
        body('ville_arrivee')
            .notEmpty().withMessage("La ville d'arrivee est requise")
            .isString().withMessage("La ville d'arrivee doit etre une chaine"),
        body('heure_depart')
            .matches(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/)
            .withMessage('Format d heure invalide (HH:MM)'),
        body('gare_depart')
            .notEmpty().withMessage('La gare de depart est requise'),
        body('duree_estimee')
            .isInt({ min: 1 }).withMessage('La duree doit etre un nombre positif'),
        body('places_total')
            .isInt({ min: 1 }).withMessage('Le nombre total de places doit etre positif'),
        body('prix')
            .isInt({ min: 0 }).withMessage('Le prix doit etre un nombre positif'),
        body('date_trajet')
            .isDate().withMessage('La date doit etre valide')
    ];
};

const reservationValidationRules = () => {
    return [
        body('trajet_id')
            .isInt().withMessage('L ID du trajet doit etre un nombre entier'),
        body('nom_client')
            .notEmpty().withMessage('Le nom du client est requis')
            .isLength({ min: 2 }).withMessage('Le nom doit contenir au moins 2 caracteres'),
        body('telephone')
            .notEmpty().withMessage('Le telephone est requis')
            .isLength({ min: 9, max: 15 }).withMessage('Le telephone doit contenir entre 9 et 15 caracteres'),
        body('email')
            .optional()
            .isEmail().withMessage('Email invalide'),
        body('nombre_places')
            .isInt({ min: 1, max: 10 }).withMessage('Le nombre de places doit etre entre 1 et 10')
    ];
};

const villeValidationRules = () => {
    return [
        body('nom')
            .notEmpty().withMessage('Le nom de la ville est requis')
            .isString().withMessage('Le nom doit etre une chaine'),
        body('code')
            .optional()
            .isString().withMessage('Le code doit etre une chaine')
            .isLength({ max: 10 }).withMessage('Le code ne doit pas depasser 10 caracteres')
    ];
};

module.exports = {
    trajetValidationRules,
    reservationValidationRules,
    villeValidationRules
};