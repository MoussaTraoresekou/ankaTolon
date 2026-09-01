class CategorieModel {
  final String? id;
  final String nom;
  final String type;

  const CategorieModel({
     this.id,
    required this.nom,
    required this.type
  });

  factory CategorieModel.fromJson(
    Map<String, dynamic> json,
    String id,
  ) {
    return CategorieModel(
      id: id,
      nom: json['nom'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'type':type
    };
  }

  CategorieModel copyWith({
    String? nom,
    String ? type
  }) {
    return CategorieModel(
      id: id,
      nom: nom ?? this.nom,
      type: type ?? this.type,
    );
  }

  @override
  String toString() {
    return 'CategorieModel(id: $id, nom: $nom,type:$type)';
  }
}