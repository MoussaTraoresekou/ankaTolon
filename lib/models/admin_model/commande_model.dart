import 'package:cloud_firestore/cloud_firestore.dart';

class CommandeModel {
  final String id;
  final String adresse;
  final DateTime dateCmd;
  final int montantTotal;
  final String parentId;
  final String status;
  final List<dynamic> jouets; 
  final String parentName; 

  CommandeModel({
    required this.id,
    required this.adresse,
    required this.dateCmd,
    required this.montantTotal,
    required this.parentId,
    required this.status,
    required this.jouets,
    required this.parentName,
  });

  // Le constructeur magique fortifié pour éviter les crashs de conversion
  factory CommandeModel.fromFirestore({
    required Map<String, dynamic> json, 
    required String docId, 
    required String resolvedParentName, 
  }) {
    // Sécurité Date
    DateTime parsedDate = DateTime.now();
    if (json['date_cmd'] is Timestamp) {
      parsedDate = (json['date_cmd'] as Timestamp).toDate();
    }

    // Sécurité Montant
    int total = 0;
    if (json['montant_total'] != null) {
      total = int.tryParse(json['montant_total'].toString()) ?? 0;
    }

    return CommandeModel(
      id: docId,
      adresse: json['adresse']?.toString() ?? 'Bamako, Mali',
      dateCmd: parsedDate,
      montantTotal: total,
      parentId: json['parent_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'en cours',
      jouets: json['jouets'] is List ? json['jouets'] as List<dynamic> : [], 
      parentName: resolvedParentName,
    );
  }
}
