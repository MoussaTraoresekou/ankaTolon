import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/jouets/jouet_models.dart';

part 'jouet_repository.g.dart';

class JouetRepository {
  final FirebaseFirestore _firestore;

  JouetRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _jouetsCollection =>
      _firestore.collection('jouets');

  // ============================================================
  // RÉCUPÉRER TOUS LES JOUETS
  // ============================================================

  Future<List<JouetModel>> getJouets() async {
    final snapshot = await _jouetsCollection.get();

    return snapshot.docs.map((doc) {
      return JouetModel.fromJson(
        doc.data(),
        doc.id,
      );
    }).toList();
  }

  // ============================================================
  // RÉCUPÉRER UN JOUET
  // ============================================================

  Future<JouetModel?> getJouetById(String id) async {
    final doc = await _jouetsCollection.doc(id).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return JouetModel.fromJson(
      doc.data()!,
      doc.id,
    );
  }

  // ============================================================
  // AJOUTER UN JOUET
  // ============================================================

  Future<void> ajouterJouet({
    required JouetModel jouet,
    required List<dynamic> images,
  }) async {
    // Ta logique d'upload Supabase doit être ici
  }

  // ============================================================
  // MODIFIER
  // ============================================================

  Future<void> modifierJouet({
    required JouetModel jouet,
  }) async {
    await _jouetsCollection
        .doc(jouet.id)
        .update(jouet.toJson());
  }

  // ============================================================
  // SUPPRIMER
  // ============================================================

  Future<void> supprimerJouet(String id) async {
    await _jouetsCollection
        .doc(id)
        .delete();
  }

  // ============================================================
  // ÉCOUTER LES JOUETS EN TEMPS RÉEL
  // ============================================================

  Stream<List<JouetModel>> watchJouets() {
    return _jouetsCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return JouetModel.fromJson(
              doc.data(),
              doc.id,
            );
          },
        ).toList();
      },
    );
  }
}

// ================================================================
// RIVERPOD : REPOSITORY
// ================================================================

@riverpod
JouetRepository jouetRepository(Ref ref) {
  return JouetRepository(
    FirebaseFirestore.instance,
  );
}

// ================================================================
// RIVERPOD : LISTE DES JOUETS EN TEMPS RÉEL
// ================================================================

@riverpod
Stream<List<JouetModel>> watchJouets(Ref ref) {
  final repository =
      ref.watch(jouetRepositoryProvider);

  return repository.watchJouets();
}