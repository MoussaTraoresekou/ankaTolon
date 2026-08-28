import 'package:cloud_firestore/cloud_firestore.dart';

class ActiviteModel {
  final String id;
  final String titre;
  final String description;
  final DocumentReference? categorieId;
  final String? image;
  final String? videoUrl;
  final int dureeMinutes;
  final int ageMin;
  final int ageMax;
  final DateTime dateCreation;
  

  const ActiviteModel({
    required this.id,
    required this.titre,
    required this.description,
    this.categorieId,
    this.image,
    this.videoUrl,
    required this.dureeMinutes,
    required this.ageMin,
    required this.ageMax,
    required this.dateCreation,
  });

  factory ActiviteModel.fromJson(Map<String, dynamic> json, String id) {
    return ActiviteModel(
      id: id,
      titre: json['titre'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categorieId: json['categorie_id'] as DocumentReference?,
      image: json['image'] as String?,
      videoUrl: json['video_url'] as String?,
      dureeMinutes: json['duree_minutes'] as int? ?? 0,
      ageMin: json['age_min'] as int? ?? 0,
      ageMax: json['age_max'] as int? ?? 0,
      dateCreation: json['date_creation'] != null
          ? (json['date_creation'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'description': description,
      'categorie_id': categorieId,
      'image': image,
      'video_url': videoUrl,
      'duree_minutes': dureeMinutes,
      'age_min': ageMin,
      'age_max': ageMax,
      'date_creation': Timestamp.fromDate(dateCreation),
    };
  }

  ActiviteModel copyWith({
    String? titre,
    String? description,
    DocumentReference? categorieId,
    String? image,
    String? videoUrl,
    int? dureeMinutes,
    int? ageMin,
    int? ageMax,
  }) {
    return ActiviteModel(
      id: id,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      categorieId: categorieId ?? this.categorieId,
      image: image ?? this.image,
      videoUrl: videoUrl ?? this.videoUrl,
      dureeMinutes: dureeMinutes ?? this.dureeMinutes,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      dateCreation: dateCreation,
    );
  }

  @override
  String toString() {
    return 'ActiviteModel(id: $id, titre: $titre, dureeMinutes: $dureeMinutes)';
  }
}