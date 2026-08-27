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
  final jouetRef = _firestore.collection('jouets').doc(jouetId);
  final avisRef = jouetRef.collection('avis');

  // Ajouter l'avis
  await avisRef.add(avis.toFirestore());

  // Recalculer la note moyenne
  final snapshot = await avisRef.get();
  if (snapshot.docs.isEmpty) {
    await jouetRef.update({'note_moyen': 0.0});
    return;
  }

  double total = 0;
  for (final doc in snapshot.docs) {
    final data = doc.data();
    total += (data['note'] ?? 0).toDouble();
  }
  final moyenne = total / snapshot.docs.length;

  await jouetRef.update({'note_moyen': moyenne});
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