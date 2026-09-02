import 'package:cloud_firestore/cloud_firestore.dart';

class TutorielModel {
  final String id;
  final String titre;
  final String description;
  final int ageMin;
  final int ageMax;
  final DateTime dateCreation;
  final String videoUrl;
  final String imageVideoUrl; 
  final String categorieId; 

  const TutorielModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.ageMin,
    required this.ageMax,
    required this.dateCreation,
    required this.videoUrl,
    required this.imageVideoUrl,
    required this.categorieId,
  });

  factory TutorielModel.fromJson(Map<String, dynamic> json, String id) {
    DateTime parsedDate = DateTime.now();
    if (json['date_creation'] is Timestamp) {
      parsedDate = (json['date_creation'] as Timestamp).toDate();
    }

    return TutorielModel(
      id: id,
      titre: json['titre']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      ageMin: int.tryParse(json['age_min']?.toString() ?? '0') ?? 0,
      ageMax: int.tryParse(json['age_max']?.toString() ?? '0') ?? 0,
      dateCreation: parsedDate,
      videoUrl: json['video_url']?.toString() ?? '',
      imageVideoUrl: json['imageVideo_url']?.toString() ?? '',
      categorieId: json['categorie_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'description': description,
      'age_min': ageMin,
      'age_max': ageMax,
      'date_creation': Timestamp.fromDate(dateCreation),
      'video_url': videoUrl,
      'imageVideo_url' : imageVideoUrl,
      'categorie_id': categorieId,
    };
  }
}
