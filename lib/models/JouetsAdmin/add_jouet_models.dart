import 'package:cloud_firestore/cloud_firestore.dart';

class JouetModel {
  final String? id;

  final String nom;
  final String categorie;

  final int ageMinimum;
  final int ageMaximum;

  final double prix;
  final int stock;

  final String description;

  final List<String> benefices;
  final List<String> images;

  final double noteMoyen;

  final Timestamp? dateCreation;

  JouetModel({
    this.id,

    required this.nom,
    required this.categorie,

    required this.ageMinimum,
    required this.ageMaximum,

    required this.prix,
    required this.stock,

    required this.description,

    required this.benefices,
    required this.images,

    this.noteMoyen = 0,

    this.dateCreation,
  });

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,

      'categorie': categorie,

      'ageMinimum': ageMinimum,

      'ageMaximum': ageMaximum,

      'prix': prix,

      'stock': stock,

      'description': description,

      'benefices': benefices,

      'images': images,

      'note_moyen': noteMoyen,
    };
  }

  factory JouetModel.fromMap(
      Map<String, dynamic> map,
      String id,
      ) {
    return JouetModel(
      id: id,

      nom: map['nom'] ?? '',

      categorie: map['categorie'] ?? '',

      ageMinimum:
      map['ageMinimum'] ?? 0,

      ageMaximum:
      map['ageMaximum'] ?? 0,

      prix:
      (map['prix'] ?? 0).toDouble(),

      stock:
      map['stock'] ?? 0,

      description:
      map['description'] ?? '',

      benefices:
      List<String>.from(
        map['benefices'] ?? [],
      ),

      images:
      List<String>.from(
        map['images'] ?? [],
      ),

      noteMoyen:
      (map['note_moyen'] ?? 0).toDouble(),

      dateCreation:
      map['dateCreation'] as Timestamp?,
    );
  }
}