import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tolon/models/defis/defi_model.dart';


class DefiRepository {

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;


  // =====================================================
  // AJOUTER
  // =====================================================

  Future<String> ajouterDefi(
      Defi defi) async {

    final document =
    await firestore
        .collection('Defis')
        .add(
      defi.toMap(),
    );

    return document.id;
  }


  // =====================================================
  // RECUPERER
  // =====================================================

  Future<List<Defi>> recupererDefis() async {

    final resultat =
    await firestore
        .collection('Defis')
        .get();

    return resultat.docs.map((document) {

      return Defi.fromMap(
        document.data(),
        document.id,
      );

    }).toList();
  }


  // =====================================================
  // MODIFIER
  // =====================================================

  Future<void> modifierDefi(
      Defi defi) async {

    await firestore
        .collection('Defis')
        .doc(defi.id)
        .update(
      defi.toMap(),
    );
  }


  // =====================================================
  // SUPPRIMER
  // =====================================================

  Future<void> supprimerDefi(
      String id) async {

    await firestore
        .collection('Defis')
        .doc(id)
        .delete();
  }
}