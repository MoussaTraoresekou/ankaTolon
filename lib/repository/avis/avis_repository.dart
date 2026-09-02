import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tolon/models/avis/avis_model.dart';

class AvisRepository {
  final FirebaseFirestore _firestore;

  AvisRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _avisCollection(String jouetId) {
    return _firestore.collection('jouets').doc(jouetId).collection('avis');
  }

  // ==================================================
  // AJOUTER UN AVIS
  // ==================================================

  Future<void> ajouterAvis({
    required String jouetId,
    required AvisModel avis,
  }) async {
    final avisRef = _avisCollection(jouetId);

    // Empêcher un second avis du même utilisateur
    final existing = await avisRef
        .where('user_id', isEqualTo: avis.userId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception('Vous avez déjà publié un avis pour ce jouet.');
    }

    await avisRef.add(avis.toFirestore());
    await _recalculerNoteMoyenne(jouetId);
  }

  // ==================================================
  // MODIFIER UN AVIS
  // ==================================================

  Future<void> modifierAvis({
    required String jouetId,
    required AvisModel avis,
  }) async {
    if (avis.id.isEmpty) {
      throw Exception('Identifiant de l\'avis manquant.');
    }

    await _avisCollection(jouetId).doc(avis.id).update({
      'note': avis.note,
      'commentaire': avis.commentaire,
      // On garde la date de publication d'origine
    });

    await _recalculerNoteMoyenne(jouetId);
  }

  // ==================================================
  // SUPPRIMER UN AVIS
  // ==================================================

  Future<void> supprimerAvis({
    required String jouetId,
    required String avisId,
  }) async {
    await _avisCollection(jouetId).doc(avisId).delete();
    await _recalculerNoteMoyenne(jouetId);
  }

  // ==================================================
  // RÉCUPÉRER L'AVIS D'UN UTILISATEUR
  // ==================================================

  Future<AvisModel?> getAvisUtilisateur({
    required String jouetId,
    required String userId,
  }) async {
    if (userId.isEmpty) return null;

    final snapshot = await _avisCollection(jouetId)
        .where('user_id', isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return AvisModel.fromFirestore(snapshot.docs.first);
  }

  // ==================================================
  // RÉCUPÉRER TOUS LES AVIS (stream)
  // ==================================================

  Stream<List<AvisModel>> recupererAvis(String jouetId) {
    return _avisCollection(jouetId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AvisModel.fromFirestore(doc))
          .toList();
    });
  }

  // ==================================================
  // RECALCULER LA NOTE MOYENNE
  // ==================================================

  Future<void> _recalculerNoteMoyenne(String jouetId) async {
    final jouetRef = _firestore.collection('jouets').doc(jouetId);
    final snapshot = await _avisCollection(jouetId).get();

    if (snapshot.docs.isEmpty) {
      await jouetRef.update({'note_moyen': 0.0});
      return;
    }

    double total = 0;
    for (final doc in snapshot.docs) {
      total += (doc.data()['note'] ?? 0).toDouble();
    }

    final moyenne = total / snapshot.docs.length;
    await jouetRef.update({'note_moyen': moyenne});
  }
}
