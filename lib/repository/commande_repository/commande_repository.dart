import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../cor/router/routes.dart';
import '../../models/commande/command_model.dart' show Commande, CommandeItem; // Pour récupérer firestoreProvider et firebaseAuthProvider

final commandeRepositoryProvider = Provider<CommandeRepository>((ref) {
  return CommandeRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  );
});

class CommandeRepository {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  CommandeRepository(this._db, this._auth);

  Future<void> createCommande({
    required String adresse,
    required List<CommandeItem> items,
    required double montant,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Non connecté");

    final commande = Commande(
      parentId: user.uid,
      montant: montant,
      adresse: adresse,
      status: 'en_attente_livraison',
      dateCmd: DateTime.now(),
      jouets: items,
    );

    await _db.collection('Commandes').add(commande.toMap());
  }
   
   Future<List<Commande>> getMesCommandes() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Non connecté");
    }

    final snapshot = await _db
        .collection('Commandes')
        .where('parent_id', isEqualTo: user.uid)
        .orderBy('date_cmd', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      final jouetsData = data['jouets'] as List<dynamic>? ?? [];

      final jouets = jouetsData.map((item) {
        final jouet = Map<String, dynamic>.from(item);

        return CommandeItem(
          jouetId: jouet['jouet_id'] ?? '',
          nomJouet: jouet['nom_jouet'] ?? '',
          image: jouet['image'] ?? '',
          quantite: jouet['quantite'] ?? 0,
          prixUnitaire: (jouet['prix_unitaire'] ?? 0).toDouble(),
        );
      }).toList();

      return Commande(
        id: doc.id,
        parentId: data['parent_id'] ?? '',
        montant: (data['montant'] ?? 0).toDouble(),
        adresse: data['adresse'] ?? '',
        status: data['status'] ?? '',
        dateCmd: (data['date_cmd'] as Timestamp).toDate(),
        jouets: jouets,
      );
    }).toList();
  }
  
   Future<Commande> getCommandeById(String id) async {

    final snapshot = await _db
        .collection('Commandes')
        .doc(id)
        .get();

    final data = snapshot.data()!;

    return Commande.fromFirestore(json: data, docId: id);

  }
  
}

