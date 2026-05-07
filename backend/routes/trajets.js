// FILE: backend/routes/trajets.js

const express = require('express');
const router = express.Router();
const { body, query, param } = require('express-validator');
const trajetController = require('../controllers/trajetController');
const { authenticateToken, authorizeAdmin } = require('../middleware/auth');

router.get('/',
    query('depart').optional().isString(),
    query('arrivee').optional().isString(),
    query('date').optional().isDate(),
    trajetController.getAllTrajets
);

router.get('/disponibilite',
    query('trajet_id').isInt(),
    query('nombre_places').isInt({ min: 1 }),
    trajetController.checkDisponibilite
);

router.get('/:id',
    param('id').isInt(),
    trajetController.getTrajetById
);

router.post('/',
    authenticateToken,
    authorizeAdmin,
    [
        body('ville_depart').notEmpty().isString(),
        body('ville_arrivee').notEmpty().isString(),
        body('heure_depart').matches(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/),
        body('gare_depart').notEmpty(),
        body('duree_estimee').isInt({ min: 1 }),
        body('places_total').isInt({ min: 1 }),
        body('prix').isInt({ min: 0 }),
        body('date_trajet').isDate()
    ],
    trajetController.createTrajet
);

router.put('/:id',
    authenticateToken,
    authorizeAdmin,
    [
        param('id').isInt(),
        body('ville_depart').optional().isString(),
        body('ville_arrivee').optional().isString(),
        body('heure_depart').optional().matches(/^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/),
        body('gare_depart').optional(),
        body('duree_estimee').optional().isInt({ min: 1 }),
        body('places_total').optional().isInt({ min: 1 }),
        body('prix').optional().isInt({ min: 0 })
    ],
    trajetController.updateTrajet
);

router.delete('/:id',
    authenticateToken,
    authorizeAdmin,
    param('id').isInt(),
    trajetController.deleteTrajet
);

module.exports = router;