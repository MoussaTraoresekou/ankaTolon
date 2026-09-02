class Jouet {
  final String id;
  final String nom;
  final String categorieId;

  final int ageMinimum;
  final int ageMaximum;

  final double prix;
  final int stock;

  final String description;

  final List<String> benefices;
  final List<String> images;

  Jouet({
    required this.id,
    required this.nom,
    required this.categorieId,
    required this.ageMinimum,
    required this.ageMaximum,
    required this.prix,
    required this.stock,
    required this.description,
    required this.benefices,
    required this.images,
  });
}