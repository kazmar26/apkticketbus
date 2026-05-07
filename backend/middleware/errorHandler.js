// FILE: backend/middleware/errorHandler.js

const errorHandler = (err, req, res, next) => {
    console.error('Erreur:', err);

    let statusCode = err.statusCode || 500;
    let message = err.message || 'Erreur interne du serveur';

    if (err.code === 'ER_DUP_ENTRY') {
        statusCode = 400;
        message = 'Cette entree existe deja';
    }

    if (err.code === 'ER_NO_REFERENCED_ROW_2') {
        statusCode = 400;
        message = 'Reference invalide';
    }

    if (err.name === 'JsonWebTokenError') {
        statusCode = 401;
        message = 'Token invalide';
    }

    if (err.name === 'TokenExpiredError') {
        statusCode = 401;
        message = 'Token expire';
    }

    res.status(statusCode).json({
        success: false,
        message: message,
        ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
    });
};

module.exports = errorHandler;