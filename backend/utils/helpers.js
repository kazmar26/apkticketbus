// FILE: backend/utils/helpers.js

const formatDate = (date) => {
    const d = new Date(date);
    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    const hours = String(d.getHours()).padStart(2, '0');
    const minutes = String(d.getMinutes()).padStart(2, '0');
    const seconds = String(d.getSeconds()).padStart(2, '0');
    
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};

const formatPhoneNumber = (phone) => {
    const cleaned = phone.replace(/\D/g, '');
    
    if (cleaned.startsWith('243') && cleaned.length === 12) {
        return `+${cleaned}`;
    }
    
    if (cleaned.startsWith('0') && cleaned.length === 10) {
        return `+243${cleaned.substring(1)}`;
    }
    
    return phone;
};

const generateRandomCode = (length = 8) => {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    let result = '';
    for (let i = 0; i < length; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
};

const calculateTotalPrice = (prix, nombrePlaces) => {
    return prix * nombrePlaces;
};

const validateEmail = (email) => {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
};

const validatePhone = (phone) => {
    const cleaned = phone.replace(/\D/g, '');
    return cleaned.length >= 9 && cleaned.length <= 15;
};

const formatResponse = (success, message, data = null, errors = null) => {
    const response = { success, message };
    if (data) response.data = data;
    if (errors) response.errors = errors;
    return response;
};

module.exports = {
    formatDate,
    formatPhoneNumber,
    generateRandomCode,
    calculateTotalPrice,
    validateEmail,
    validatePhone,
    formatResponse
};