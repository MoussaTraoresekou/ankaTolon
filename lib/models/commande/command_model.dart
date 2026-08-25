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
  final String statut;
  final DateTime dateCmd;
  final List<CommandeItem> jouets;

  Commande({
    this.id,
    required this.parentId,
    required this.montant,
    required this.adresse,
    required this.statut,
    required this.dateCmd,
    required this.jouets,
  });

  Map<String, dynamic> toMap() => {
    'parent_id': parentId,
    'montant': montant,
    'adresse': adresse,
    'statut': statut,
    'date_cmd': Timestamp.fromDate(dateCmd),
    'jouets': jouets.map((j) => j.toMap()).toList(),
  };
}
