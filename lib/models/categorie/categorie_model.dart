class CategorieModel {
  final String id;
  final String nom;

  const CategorieModel({
    required this.id,
    required this.nom,
  });

  factory CategorieModel.fromJson(
    Map<String, dynamic> json,
    String id,
  ) {
    return CategorieModel(
      id: id,
      nom: json['nom'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
    };
  }

  CategorieModel copyWith({
    String? nom,
  }) {
    return CategorieModel(
      id: id,
      nom: nom ?? this.nom,
    );
  }

  @override
  String toString() {
    return 'CategorieModel(id: $id, nom: $nom)';
  }
}