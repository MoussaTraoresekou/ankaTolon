import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tolon/models/avis/avis_model.dart';

class AvisRepository {
  final FirebaseFirestore _firestore;

  AvisRepository({
    FirebaseFirestore? firestore,
  }) : _firestore =
            firestore ?? FirebaseFirestore.instance;

  // ==================================================
  // AJOUTER UN AVIS
  // ==================================================

  Future<void> ajouterAvis({
    required String jouetId,
    required AvisModel avis,
  }) async {
    await _firestore
        .collection('jouets')
        .doc(jouetId)
        .collection('avis')
        .add(
          avis.toFirestore(),
        );
  }

  // ==================================================
  // RÉCUPÉRER LES AVIS
  // ==================================================

  Stream<List<AvisModel>> recupererAvis(
    String jouetId,
  ) {
    return _firestore
        .collection('jouets')
        .doc(jouetId)
        .collection('avis')
        .orderBy(
          'date',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map(
                  (doc) =>
                      AvisModel.fromFirestore(doc),
                )
                .toList();
          },
        );
  }
}