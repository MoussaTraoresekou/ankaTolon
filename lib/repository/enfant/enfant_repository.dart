import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';

part 'enfant_repository.g.dart';

class EnfantRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  EnfantRepository(this._firestore, this._auth);

  // ============================================================
  // UTILISATEUR CONNECTÉ
  // ============================================================

  String get _uid {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Aucun utilisateur connecté');
    }

    return user.uid;
  }

  // ============================================================
  // COLLECTION ENFANTS DE L'UTILISATEUR CONNECTÉ
  // ============================================================

  CollectionReference<Map<String, dynamic>> get _enfantsRef {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('enfants');
  }

  // ============================================================
  // AJOUTER UN ENFANT
  // ============================================================

  Future<void> ajouterEnfant(EnfantModel enfant) async {
    await _enfantsRef.add(enfant.toJson());
  }

  // ============================================================
  // RÉCUPÉRER LES ENFANTS DE L'UTILISATEUR CONNECTÉ
  // ============================================================

  Stream<List<EnfantModel>> streamEnfants() {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.error(
        Exception('Aucun utilisateur connecté'),
      );
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('enfants')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return EnfantModel.fromJson(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  // ============================================================
  // RÉCUPÉRER UN ENFANT
  // ============================================================

  Future<EnfantModel?> getEnfant(String enfantId) async {
    final doc = await _enfantsRef.doc(enfantId).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return EnfantModel.fromJson(
      doc.data()!,
      doc.id,
    );
  }

  // ============================================================
  // MODIFIER UN ENFANT
  // ============================================================

  Future<void> modifierEnfant(
    EnfantModel enfant,
  ) async {
    await _enfantsRef.doc(enfant.id).update(
          enfant.toJson(),
        );
  }

  // ============================================================
  // SUPPRIMER UN ENFANT
  // ============================================================

  Future<void> supprimerEnfant(
    String enfantId,
  ) async {
    await _enfantsRef.doc(enfantId).delete();
  }
}

// ============================================================
// PROVIDER REPOSITORY
// ============================================================

@riverpod
EnfantRepository enfantRepository(
  Ref ref,
) {
  return EnfantRepository(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
}

// ============================================================
// PROVIDER DES ENFANTS
// ============================================================

@riverpod
Stream<List<EnfantModel>> enfants(
  Ref ref,
) {
  final repository = ref.watch(
    enfantRepositoryProvider,
  );

  return repository.streamEnfants();
}