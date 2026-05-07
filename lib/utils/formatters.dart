// FILE: lib/utils/formatters.dart

import 'package:intl/intl.dart';

class Formatters {
  static String formatPrix(int prix) {
    final formatter = NumberFormat('#,###', 'fr_FR');
    return '${formatter.format(prix)} FC';
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR').format(date);
  }

  static String formatDuree(int minutes) {
    int heures = minutes ~/ 60;
    int mins = minutes % 60;
    
    if (heures > 0 && mins > 0) {
      return '${heures}h ${mins}min';
    } else if (heures > 0) {
      return '${heures}h';
    } else {
      return '${mins}min';
    }
  }

  static String formatTelephone(String phone) {
    if (phone.length == 12 && phone.startsWith('243')) {
      return '+243 ${phone.substring(3, 5)} ${phone.substring(5, 8)} ${phone.substring(8)}';
    }
    return phone;
  }

  static String formatCodeReservation(String code) {
    if (code.length == 12) {
      return '${code.substring(0, 4)}-${code.substring(4, 8)}-${code.substring(8, 12)}';
    }
    return code;
  }
}