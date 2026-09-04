import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/admin_model/commande_model.dart';

part 'jouet_plusAchete_repository.g.dart';

@riverpod
Stream<List<Map<String, dynamic>>> topJouetsAchetes(Ref ref) {
  // On écoute la collection des commandes en temps réel
  return FirebaseFirestore.instance.collection('Commandes').snapshots().map((snapshot) {
    // Dictionnaire local pour cumuler les ventes : { jouetId: { 'nom': ..., 'quantite': ..., 'image': ... } }
    final Map<String, Map<String, dynamic>> cumulVentes = {};

    for (var doc in snapshot.docs) {
      final json = doc.data();
      // On utilise votre logique de décodage de sous-liste dynamic
      final List<dynamic> jouetsList = json['jouets'] is List ? json['jouets'] : [];

      for (var item in jouetsList) {
        final Map<String, dynamic> toyMap = Map<String, dynamic>.from(item);
        final String id = toyMap['jouet_id']?.toString() ?? '';
        final String nom = toyMap['nom_jouet']?.toString() ?? toyMap['name']?.toString() ?? 'Jouet';
        final String image = toyMap['image']?.toString() ?? '';
        final int qte = int.tryParse(toyMap['quantite']?.toString() ?? '0') ?? 0;

        if (id.isNotEmpty) {
          if (cumulVentes.containsKey(id)) {
            // Si le jouet existe déjà, on additionne la quantité
            cumulVentes[id]!['quantite'] = cumulVentes[id]!['quantite'] + qte;
          } else {
            // Sinon, on l'ajoute pour la première fois
            cumulVentes[id] = {
              'id': id,
              'nom': nom,
              'image': image,
              'quantite': qte,
            };
          }
        }
      }
    }

    // Extraction des valeurs, puis tri décroissant (le plus acheté en premier)
    final listResult = cumulVentes.values.toList();
    listResult.sort((a, b) => (b['quantite'] as int).compareTo(a['quantite'] as int));

    return listResult;
  });
}
