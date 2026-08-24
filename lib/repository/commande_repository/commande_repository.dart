import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/commande/command_model.dart';
import '../../cor/router/routes.dart'; // Pour récupérer firestoreProvider et firebaseAuthProvider

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
      statut: 'en_attente_livraison',
      dateCmd: DateTime.now(),
      jouets: items,
    );

    await _db.collection('Commandes').add(commande.toMap());
  }
}
