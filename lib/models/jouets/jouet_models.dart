import 'package:cloud_firestore/cloud_firestore.dart';

class JouetModel {
  final String id;
  final int ageMax;
  final int ageMin;
  final List<String> benefices;
  final DocumentReference? categorieId;
  final DateTime dateAjout;
  final String description;
  final List<String> image;
  final String nomJouet;
  final double noteMoyen;
  final double prix;

  const JouetModel({required this.id,required this.ageMax,required this.ageMin,required this.benefices, required this.categorieId,required this.dateAjout,required this.description,required this.image,required this.nomJouet,required this.noteMoyen,required this.prix,});

  factory JouetModel.jouetModelForCatalogue({
    required String id,
    required String nomJouet,
    required double prix,
    required List<String> image,
    required int ageMax,
    required int ageMin,
    required double noteMoyen,
    required DocumentReference? categorieId,
    DateTime? dateAjout, 
  }) {
    return JouetModel(
      id: id,
      nomJouet: nomJouet,
      prix: prix,
      image: image,
      ageMax: ageMax,
      ageMin: ageMin,
      noteMoyen: noteMoyen,
      categorieId: categorieId,
      // des valeurs par défaut pour les variables manquantes
      benefices: const [],
      dateAjout: DateTime.now(),
      description: '',
    );
  }


  factory JouetModel.fromJson( Map<String, dynamic> json,String id) {
    return JouetModel(
      id: id,
      ageMax: json['age_max'] ?? 0,
      ageMin: json['age_min'] ?? 0,
      benefices: List<String>.from(json['benefices'] ?? []),
      categorieId: json['categorie_id'] as DocumentReference?,
      dateAjout: json['date_ajout'] != null
          ? (json['date_ajout'] as Timestamp).toDate()
          : DateTime.now(),
      description: json['description'] ?? '',
      image: List<String>.from(json['image'] ?? []),
      nomJouet: json['nom_jouet'] ?? '',
      // noteMoyen: (json['note_moyen'] ?? 0).toDouble(),
      noteMoyen: double.tryParse(
  (json['note_moyen'] ?? 0).toString(),
) ?? 0.0,

      // prix: (json['prix'] ?? 0).toDouble(),
      prix: double.tryParse( (json['prix'] ?? 0).toString(),) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age_max': ageMax,
      'age_min': ageMin,
      'benefices': benefices,
      'categorie_id': categorieId,
      'date_ajout': Timestamp.fromDate(dateAjout),
      'description': description,
      'image': image,
      'nom_jouet': nomJouet,
      'note_moyen': noteMoyen,
      'prix': prix,
    };
  }

  JouetModel copyWith({
    int? ageMax,
    int? ageMin,
    List<String>? benefices,
    DocumentReference? categorieId,
    DateTime? dateAjout,
    String? description,
    List<String>? image,
    String? nomJouet,
    double? noteMoyen,
    double? prix,
  }) {
    return JouetModel(
      id: id,
      ageMax: ageMax ?? this.ageMax,
      ageMin: ageMin ?? this.ageMin,
      benefices: benefices ?? this.benefices,
      categorieId: categorieId ?? this.categorieId,
      dateAjout: dateAjout ?? this.dateAjout,
      description: description ?? this.description,
      image: image ?? this.image,
      nomJouet: nomJouet ?? this.nomJouet,
      noteMoyen: noteMoyen ?? this.noteMoyen,
      prix: prix ?? this.prix,
    );
  }

  @override
  String toString() {
    return 'JouetModel('
        'id: $id, '
        'nomJouet: $nomJouet, '
        'prix: $prix, '
        'noteMoyen: $noteMoyen'
        ')';
  }

  factory JouetModel.fromFirestoreToCatalogue(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      ) {
    final data = snapshot.data() ?? {};

    return JouetModel.jouetModelForCatalogue(
      id: snapshot.id,

      ageMax: (data['age_max'] ?? 0).toInt(),

      ageMin: (data['age_min'] ?? 0).toInt(),

      categorieId:
      data['categorie_id'] as DocumentReference?,

      image: List<String>.from(
        data['image'] ?? [],
      ),

      nomJouet:
      data['nom_jouet']?.toString() ?? '',

      noteMoyen: double.tryParse(data['note_moyen'].toString()) ?? 0.0,
      prix: double.tryParse(data['prix'].toString()) ?? 0.0,

    );
  }

}