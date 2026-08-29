import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tolon/models/admin_model/commande_model.dart'; 

class CommandeListRepository {
  final FirebaseFirestore _firestore;

  CommandeListRepository(this._firestore);

  /// Écoute en temps réel de toutes les commandes (Sans besoin d'index !)
  Stream<List<CommandeModel>> getOrdersStream() {
    return _firestore
        .collection('Commandes')
        .snapshots()
        .map((snapshot) {
          List<CommandeModel> orders = [];
          
          for (var doc in snapshot.docs) {
            final data = doc.data();
            
            // On convertit chaque document en utilisant le constructeur fromFirestore.
            // Comme on charge globalement, on met une valeur par défaut pour le nom du parent.
            orders.add(
              CommandeModel.fromFirestore(
                json: data,
                docId: doc.id,
                resolvedParentName: data['parent_name'] ?? 'Parent Ankan Tolon',
              ),
            );
          }
          return orders;
        })
        .handleError((error) {
          debugPrint("Erreur de lecture des commandes : $error");
          return <CommandeModel>[];
        });
  }
}
