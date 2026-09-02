

//FONCTION MAGIQUE : Calcule le temps écoulé ("Il y a 2h", "Il y a 15 min")

import 'package:cloud_firestore/cloud_firestore.dart';

String formatTempsEcoule(dynamic firebaseDate) {
  if (firebaseDate == null) return 'Récemment';

  DateTime date;
  if (firebaseDate is Timestamp) {
    date = firebaseDate.toDate();
  } else if (firebaseDate is String) {
    date = DateTime.tryParse(firebaseDate) ?? DateTime.now();
  } else {
    return 'Récemment';
  }

  final difference = DateTime.now().difference(date);

  if (difference.inMinutes < 60) {
    return 'Il y a ${difference.inMinutes} min';
  } else if (difference.inHours < 24) {
    return 'Il y a ${difference.inHours}h';
  } else {
    return 'Il y a ${difference.inDays}j';
  }
}