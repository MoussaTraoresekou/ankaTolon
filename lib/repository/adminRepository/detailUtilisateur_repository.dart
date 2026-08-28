

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tolon/models/auth/user_modal.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';
import 'package:tolon/models/admin_model/parent_avec_enfants.dart';

class UserDetailRepository {
  final FirebaseFirestore _firestore;

  UserDetailRepository(this._firestore);

  /// Récupère le UserModel et sa liste d'EnfantModel associés
  Future<ParentAvecEnfants?> getParentAvecEnfants(String userId) async {
    try {
      // 1. Récupération du parent dans la collection principale 'users'
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists || userDoc.data() == null) return null;

      // Utilisation de ton constructeur UserModel.fromJson
      final parent = UserModel.fromJson(userDoc.data()!, userDoc.id);

      // 2. Récupération des enfants dans la sous-collection de ce parent
      final enfantsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('enfants')
          .get();

      List<EnfantModel> loadedEnfants = [];
      for (var doc in enfantsSnapshot.docs) {
        if (doc.data().isNotEmpty) {
          // Utilisation de ton constructeur EnfantModel.fromJson
          loadedEnfants.add(EnfantModel.fromJson(doc.data(), doc.id));
        }
      }

      // Renvoie du conteneur combiné
      return ParentAvecEnfants(user: parent, enfants: loadedEnfants);
    } catch (e) {
      debugPrint("Erreur UserDetailRepository : $e");
      return null;
    }
  }
}
