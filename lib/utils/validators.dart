// FILE: lib/utils/validators.dart

class Validators {
  // Validation du nom
  static String? validateNom(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre nom';
    }
    if (value.length < 2) {
      return 'Nom trop court (minimum 2 caractères)';
    }
    if (value.length > 100) {
      return 'Nom trop long (maximum 100 caractères)';
    }
    // Vérifie que le nom ne contient que des lettres, espaces et tirets
    final nameRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s\-]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Nom invalide (caractères non autorisés)';
    }
    return null;
  }

  // Validation du prénom
  static String? validatePrenom(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre prénom';
    }
    if (value.length < 2) {
      return 'Prénom trop court (minimum 2 caractères)';
    }
    if (value.length > 100) {
      return 'Prénom trop long (maximum 100 caractères)';
    }
    final nameRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s\-]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Prénom invalide (caractères non autorisés)';
    }
    return null;
  }

  // Validation du téléphone
  static String? validateTelephone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre numéro de téléphone';
    }
    
    // Nettoie le numéro (garde uniquement chiffres et +)
    String cleaned = value.replaceAll(RegExp(r'[^0-9+]'), '');
    
    // Vérifie la longueur minimale
    if (cleaned.length < 9) {
      return 'Numéro de téléphone invalide (minimum 9 chiffres)';
    }
    
    // Vérifie la longueur maximale
    if (cleaned.length > 15) {
      return 'Numéro trop long (maximum 15 chiffres)';
    }
    
    // Vérifie le format pour la RDC (+243 ou 0)
    if (cleaned.startsWith('+243')) {
      if (cleaned.length != 13) {
        return 'Format RDC invalide (+243 suivi de 9 chiffres)';
      }
    } else if (cleaned.startsWith('0')) {
      if (cleaned.length != 10 && cleaned.length != 11) {
        return 'Numéro local invalide (0 suivi de 9 ou 10 chiffres)';
      }
    }
    
    return null;
  }

  // Validation de l'email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email optionnel
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Adresse email invalide (exemple: nom@domaine.com)';
    }
    
    if (value.length > 255) {
      return 'Email trop long (maximum 255 caractères)';
    }
    
    return null;
  }

  // Validation du nombre de places
  static String? validateNombrePlaces(int value, int maxPlaces) {
    if (value < 1) {
      return 'Minimum 1 place requise';
    }
    if (value > maxPlaces) {
      return 'Maximum $maxPlaces places disponibles pour ce trajet';
    }
    if (value > 10) {
      return 'Maximum 10 places par réservation (contactez le service client pour plus)';
    }
    return null;
  }

  // Validation du code de réservation
  static String? validateCodeReservation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer le code de réservation';
    }
    
    // Nettoie le code (enlève les tirets et espaces)
    String cleaned = value.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
    
    if (cleaned.length != 12) {
      return 'Code invalide (doit contenir exactement 12 caractères)';
    }
    
    // Format attendu: XXXX-XXXX-XXXX
    final codeRegex = RegExp(r'^[A-Z0-9]{4}[A-Z0-9]{4}[A-Z0-9]{4}$');
    if (!codeRegex.hasMatch(cleaned)) {
      return 'Format de code invalide (utilisez uniquement lettres et chiffres)';
    }
    
    return null;
  }

  // Validation de la recherche
  static String? validateSearch(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un terme de recherche';
    }
    if (value.length < 2) {
      return 'Terme de recherche trop court (minimum 2 caractères)';
    }
    if (value.length > 50) {
      return 'Terme de recherche trop long (maximum 50 caractères)';
    }
    return null;
  }

  // Validation de la ville
  static String? validateVille(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez sélectionner une ville';
    }
    return null;
  }

  // Validation de la date
  static String? validateDate(DateTime? date, {DateTime? minDate, DateTime? maxDate}) {
    if (date == null) {
      return 'Veuillez sélectionner une date';
    }
    
    if (minDate != null && date.isBefore(minDate)) {
      return 'La date ne peut pas être antérieure à ${_formatDateForValidation(minDate)}';
    }
    
    if (maxDate != null && date.isAfter(maxDate)) {
      return 'La date ne peut pas être postérieure à ${_formatDateForValidation(maxDate)}';
    }
    
    return null;
  }

  // Formatage de date pour les messages d'erreur
  static String _formatDateForValidation(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Validation du mot de passe
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre mot de passe';
    }
    if (value.length < 6) {
      return 'Mot de passe trop court (minimum 6 caractères)';
    }
    if (value.length > 50) {
      return 'Mot de passe trop long (maximum 50 caractères)';
    }
    return null;
  }

  // Confirmation du mot de passe
  static String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  // Validation du montant
  static String? validateMontant(double? value) {
    if (value == null) {
      return 'Montant invalide';
    }
    if (value <= 0) {
      return 'Le montant doit être supérieur à 0';
    }
    return null;
  }

  // Validation d'un champ vide
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Le champ $fieldName est requis';
    }
    return null;
  }
}