// FILE: backend/routes/reservations.js

const express = require('express');
const router = express.Router();
const { body, query, param } = require('express-validator');
const reservationController = require('../controllers/reservationController');
const { authenticateToken, authorizeAdmin } = require('../middleware/auth');

router.post('/',
    [
        body('trajet_id').isInt(),
        body('nom_client').notEmpty().isString().isLength({ min: 2 }),
        body('telephone').notEmpty().isString().isLength({ min: 9 }),
        body('email').optional().isEmail(),
        body('nombre_places').isInt({ min: 1, max: 10 })
    ],
    reservationController.createReservation
);

router.get('/',
    query('telephone').notEmpty(),
    reservationController.getReservationsByPhone
);

router.get('/code/:code',
    param('code').isString(),
    reservationController.getReservationByCode
);

router.post('/:id/annuler',
    param('id').isInt(),
    reservationController.cancelReservation
);

router.get('/admin/all',
    authenticateToken,
    authorizeAdmin,
    reservationController.getAllReservations
);

router.post('/admin/:id/confirmer',
    authenticateToken,
    authorizeAdmin,
    param('id').isInt(),
    reservationController.confirmReservation
);

router.get('/admin/stats',
    authenticateToken,
    authorizeAdmin,
    reservationController.getStats
);

module.exports = router;