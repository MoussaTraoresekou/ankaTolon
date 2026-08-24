class FavorisModel {
  final String userId;
  final List<String> favoris;

  FavorisModel({
    required this.userId,
    required this.favoris,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'favoris': favoris,
    };
  }

  factory FavorisModel.fromMap(Map<String, dynamic> map, String docId) {
    return FavorisModel(
      userId: docId,
      favoris: List<String>.from(map['favoris'] ?? []),
    );
  }
}