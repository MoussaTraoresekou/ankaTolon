import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';

part 'enfant_repository.g.dart';

class EnfantRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth;

  EnfantRepository(this._auth);

  String get _uid => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _enfantsRef =>
      _firestore.collection('users').doc(_uid).collection('enfants');

  // Créer un enfant
  Future<void> ajouterEnfant(EnfantModel enfant) async {
    await _enfantsRef.add(enfant.toJson());
  }

  // Lister les enfants du parent connecté, en temps réel
  Stream<List<EnfantModel>> streamEnfants() {
    return _enfantsRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => EnfantModel.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  // Récupérer un enfant précis
  Future<EnfantModel?> getEnfant(String enfantId) async {
    final doc = await _enfantsRef.doc(enfantId).get();
    if (!doc.exists) return null;
    return EnfantModel.fromJson(doc.data()!, doc.id);
  }

  // Modifier un enfant
  Future<void> modifierEnfant(EnfantModel enfant) async {
    await _enfantsRef.doc(enfant.id).update(enfant.toJson());
  }

  // Supprimer un enfant
  Future<void> supprimerEnfant(String enfantId) async {
    await _enfantsRef.doc(enfantId).delete();
  }
}

@riverpod
EnfantRepository enfantRepository(Ref ref) {
  return EnfantRepository(FirebaseAuth.instance);
}