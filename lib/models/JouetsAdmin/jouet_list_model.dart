class Jouet {
  String id;
  String nom;
  String categorie;
  int ageMinimum;
  int ageMaximum;
  double prix;
  int stock;
  String description;
  List<String> benefices;
  List<String> images;

  double noteMoyen;

  Jouet({
    required this.id,
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
  });
}