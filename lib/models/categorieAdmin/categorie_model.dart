class Categorie {
  String id;
  String nom;

  Categorie({
    required this.id,
    required this.nom,
  });

  // Transformer l'objet en données Firebase
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
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
    );
  }
}