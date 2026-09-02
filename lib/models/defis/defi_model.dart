class Defi {
  String id;
  String titre;
  String description;
  DateTime dateAjout;

  int ageMin;
  int ageMax;

  // Durée de validité en jours
  int dureeValidite;

  List<TacheDefi> activites;
  List<TacheDefi> quiz;

  Defi({
    required this.id,
    required this.titre,
    required this.description,
    required this.dateAjout,
    required this.ageMin,
    required this.ageMax,
    required this.dureeValidite,
    required this.activites,
    required this.quiz,
  });

  // =====================================================
  // TRANSFORMER EN DONNEES FIREBASE
  // =====================================================

  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'description': description,
      'date_ajout': dateAjout,

      'age_min': ageMin,
      'age_max': ageMax,

      'duree_validite': dureeValidite,

      'activites': activites
          .map((activite) => activite.toMap())
          .toList(),

      'quiz': quiz
          .map((quiz) => quiz.toMap())
          .toList(),
    };
  }

  // =====================================================
  // TRANSFORMER FIREBASE EN OBJET
  // =====================================================

  factory Defi.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return Defi(
      id: documentId,

      titre: map['titre'] ?? '',

      description: map['description'] ?? '',

      dateAjout: map['date_ajout'] != null
          ? map['date_ajout'].toDate()
          : DateTime.now(),

      ageMin: map['age_min'] ?? 0,

      ageMax: map['age_max'] ?? 0,

      // Si les anciens défis n'ont pas encore
      // duree_validite, on met 7 jours par défaut.
      dureeValidite:
      map['duree_validite'] ?? 7,

      activites:
      (map['activites'] as List? ?? [])
          .map(
            (item) => TacheDefi.fromMap(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList(),

      quiz:
      (map['quiz'] as List? ?? [])
          .map(
            (item) => TacheDefi.fromMap(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList(),
    );
  }
}


// =====================================================
// TACHE ACTIVITE / QUIZ
// =====================================================

class TacheDefi {
  String categorieId;
  int nombre;

  TacheDefi({
    required this.categorieId,
    required this.nombre,
  });

  // =====================================================
  // TRANSFORMER EN FIREBASE
  // =====================================================

  Map<String, dynamic> toMap() {
    return {
      'categorie_id': categorieId,
      'nombre': nombre,
    };
  }

  // =====================================================
  // TRANSFORMER FIREBASE EN OBJET
  // =====================================================

  factory TacheDefi.fromMap(
      Map<String, dynamic> map,
      ) {
    return TacheDefi(
      categorieId:
      map['categorie_id'] ?? '',

      nombre:
      map['nombre'] ?? 0,
    );
  }
}