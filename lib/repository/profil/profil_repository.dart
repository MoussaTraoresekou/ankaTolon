import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/models/auth/user_modal.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';

final profilRepositoryProvider = Provider<ProfilRepository>((ref) {
  return ProfilRepository();
});

class ProfilRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  // Récupérer les informations du parent connecté
  Future<UserModel?> getCurrentUser() async {
    if (_currentUserId.isEmpty) {
      return null;
    }

    final doc = await _firestore
        .collection('users')
        .doc(_currentUserId)
        .get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return UserModel.fromJson(
      doc.data()!,
      doc.id,
    );
  }

  // Récupérer les enfants du parent connecté
  Future<List<EnfantModel>> getEnfants() async {
    if (_currentUserId.isEmpty) {
      return [];
    }

    final snapshot = await _firestore
        .collection('users')
        .doc(_currentUserId)
        .collection('enfants')
        .get();

    return snapshot.docs.map((doc) {
      return EnfantModel.fromJson(
        doc.data(),
        doc.id,
      );
    }).toList();
  }

  // Déconnexion
  Future<void> logout() async {
    await _auth.signOut();
  }
}