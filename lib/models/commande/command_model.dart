import 'package:cloud_firestore/cloud_firestore.dart';

class CommandeItem {
  final String jouetId;
  final String nomJouet; // Dénormalisé pour éviter les lectures supplémentaires
  final String image;
  final int quantite;
  final double prixUnitaire;

  CommandeItem({
    required this.jouetId,
    required this.nomJouet,
    required this.image,
    required this.quantite,
    required this.prixUnitaire,
  });

  Map<String, dynamic> toMap() => {
    'jouet_id': jouetId,
    'nom_jouet': nomJouet,
    'image': image,
    'quantite': quantite,
    'prix_unitaire': prixUnitaire,
  };
}

class Commande {
  final String? id;
  final String parentId;
  final double montant;
  final String adresse;
  final String status;
  final DateTime dateCmd;
  final List<CommandeItem> jouets;

  Commande({
    this.id,
    required this.parentId,
    required this.montant,
    required this.adresse,
    required this.status,
    required this.dateCmd,
    required this.jouets,
  });

  Map<String, dynamic> toMap() => {
    'parent_id': parentId,
    'montant': montant,
    'adresse': adresse,
    'status': status,
    'date_cmd': Timestamp.fromDate(dateCmd),
    'jouets': jouets.map((j) => j.toMap()).toList(),
  };

  factory Commande.fromFirestore({
    required Map<String, dynamic> json, 
    required String docId,
  }) {
    // Sécurité Date
    DateTime parsedDate = DateTime.now();
    if (json['date_cmd'] is Timestamp) {
      parsedDate = (json['date_cmd'] as Timestamp).toDate();
    }

    // Sécurité Montant
    double total = 0;
    if (json['montant'] != null) {
      total = double.tryParse(json['montant'].toString()) ?? 0;
    }

    return Commande(
      id: docId,
      adresse: json['adresse']?.toString() ?? 'Bamako, Mali',
      dateCmd: parsedDate,
      montant: total,
      parentId: json['parent_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'en cours',
      jouets: json['jouets'] is List ? json['jouets'] as List<CommandeItem> : [],
    );
  }
}
