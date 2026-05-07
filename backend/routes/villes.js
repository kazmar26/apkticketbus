// FILE: backend/routes/villes.js

const express = require('express');
const router = express.Router();
const { body, param } = require('express-validator');
const villeController = require('../controllers/villeController');
const { authenticateToken, authorizeAdmin } = require('../middleware/auth');

router.get('/', villeController.getAllVilles);

router.get('/:id',
    param('id').isInt(),
    villeController.getVilleById
);

router.post('/',
    authenticateToken,
    authorizeAdmin,
    [
        body('nom').notEmpty().isString(),
        body('code').optional().isString()
    ],
    villeController.createVille
);

router.put('/:id',
    authenticateToken,
    authorizeAdmin,
    [
        param('id').isInt(),
        body('nom').optional().isString(),
        body('code').optional().isString()
    ],
    villeController.updateVille
);

router.delete('/:id',
    authenticateToken,
    authorizeAdmin,
    param('id').isInt(),
    villeController.deleteVille
);

module.exports = router;