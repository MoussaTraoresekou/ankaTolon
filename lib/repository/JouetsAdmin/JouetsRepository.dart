import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:tolon/models/JouetsAdmin/add_jouet_models.dart';
import 'package:tolon/models/JouetsAdmin/jouet_list_model.dart';

class JouetRepository {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final SupabaseClient supabase =
      Supabase.instance.client;

  Future<String> uploadImage(XFile image) async {
    final bytes = await image.readAsBytes();

    String extension =
    image.name.split('.').last.toLowerCase();

    if (extension != 'jpg' &&
        extension != 'jpeg' &&
        extension != 'png' &&
        extension != 'webp') {
      extension = 'png';
    }

    final String fileName =
        '${DateTime.now().microsecondsSinceEpoch}.$extension';

    final String filePath =
        'jouets/$fileName';

    await supabase.storage
        .from('images')
        .uploadBinary(
      filePath,
      bytes,
    );

    final String imageUrl =
    supabase.storage
        .from('images')
        .getPublicUrl(
      filePath,
    );

    return imageUrl;
  }

  Future<void> ajouterJouet(
      JouetModel jouet) async {
    await firestore
        .collection('jouets')
        .add({
      ...jouet.toMap(),
      'dateCreation':
      FieldValue.serverTimestamp(),
    });
  }

  Future<List<Jouet>> getJouets() async {
    QuerySnapshot resultat =
    await firestore
        .collection('jouets')
        .get();

    List<Jouet> listeJouets = [];

    for (var document in resultat.docs) {
      Map<String, dynamic> data =
      document.data()
      as Map<String, dynamic>;

      Jouet jouet = Jouet(
        id: document.id,
        nom: data['nom'] ?? '',
        categorie: data['categorie'] ?? '',
        ageMinimum: data['ageMinimum'] ?? 0,
        ageMaximum: data['ageMaximum'] ?? 0,
        prix: (data['prix'] ?? 0).toDouble(),
        stock: data['stock'] ?? 0,
        description: data['description'] ?? '',
        benefices: List<String>.from(
          data['benefices'] ?? [],
        ),
        images: List<String>.from(
          data['images'] ?? [],
        ),
      );

      listeJouets.add(jouet);
    }

    return listeJouets;
  }

  Future<void> supprimerJouet(
      String id) async {
    await firestore
        .collection('jouets')
        .doc(id)
        .delete();
  }

  Future<void> modifierJouet({
    required String id,
    required String nom,
    required String categorie,
    required int ageMinimum,
    required int ageMaximum,
    required double prix,
    required int stock,
    required String description,
    required List<String> benefices,
    required List<String> anciennesImages,
    required List<XFile> nouvellesImages,
  }) async {
    List<String> imagesFinales = [];

    imagesFinales.addAll(
      anciennesImages,
    );

    for (XFile image in nouvellesImages) {
      final String imageUrl =
      await uploadImage(image);

      imagesFinales.add(
        imageUrl,
      );
    }

    final DocumentReference document =
    firestore
        .collection('jouets')
        .doc(id);

    final DocumentSnapshot verification =
    await document.get();

    if (!verification.exists) {
      throw Exception(
        'Le document $id n\'existe pas dans Firestore',
      );
    }

    await document.update({
      'nom': nom,
      'categorie': categorie,
      'ageMinimum': ageMinimum,
      'ageMaximum': ageMaximum,
      'prix': prix,
      'stock': stock,
      'description': description,
      'benefices': benefices,
      'images': imagesFinales,
    });
  }
}