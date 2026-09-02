class Categorie {
  String id;
  String nom;
  String type;

  Categorie({
    required this.id,
    required this.nom,
    required this.type,
  });

  // Transformer l'objet en données Firebase
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'type': type,
    };
  }

  // Transformer les données Firebase en objet
  factory Categorie.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return Categorie(
      id: documentId,
      nom: map['nom'] ?? '',
      type: map['type'] ?? '',
    );
  }
}