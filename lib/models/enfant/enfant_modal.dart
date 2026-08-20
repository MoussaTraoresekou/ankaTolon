import 'package:cloud_firestore/cloud_firestore.dart';

class EnfantModel {
  final String id;
  final String nom;
  final String prenom;
  final DateTime naissance;
  final String? avatarUrl;
  final int points;
  final int niveau;
  final int activitesRealisees;
  final List<String> defisRealises;
  final List<String> tutosTelecharges;

  const EnfantModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.naissance,
    this.avatarUrl,
    required this.points,
    required this.niveau,
    required this.activitesRealisees,
    required this.defisRealises,
    required this.tutosTelecharges,
  });

  factory EnfantModel.fromJson(Map<String, dynamic> json, String id) {
    return EnfantModel(
      id:                 id,
      nom:                json['nom']        as String? ?? '',
      prenom:             json['prenom']     as String? ?? '',
      naissance:          (json['naissance'] as Timestamp).toDate(),
      avatarUrl:          json['avatar_url'] as String?,
      points:             json['points']     as int? ?? 0,
      niveau:             json['niveau']     as int? ?? 1,
      activitesRealisees: json['activites_realisees'] as int? ?? 0,
      defisRealises:      List<String>.from(json['defis_realises'] ?? []),
      tutosTelecharges:   List<String>.from(json['tutos_telecharges'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom':                  nom,
      'prenom':               prenom,
      'naissance':            Timestamp.fromDate(naissance),
      'avatar_url':           avatarUrl,
      'points':               points,
      'niveau':               niveau,
      'activites_realisees':  activitesRealisees,
      'defis_realises':       defisRealises,
      'tutos_telecharges':    tutosTelecharges,
    };
  }

  EnfantModel copyWith({
    String? id,
    String? nom,
    String? prenom,
    DateTime? naissance,
    String? avatarUrl,
    int? points,
    int? niveau,
    int? activitesRealisees,
    List<String>? defisRealises,
    List<String>? tutosTelecharges,
  }) {
    return EnfantModel(
      id:                 id                 ?? this.id,
      nom:                nom                ?? this.nom,
      prenom:             prenom             ?? this.prenom,
      naissance:          naissance          ?? this.naissance,
      avatarUrl:          avatarUrl          ?? this.avatarUrl,
      points:             points             ?? this.points,
      niveau:             niveau             ?? this.niveau,
      activitesRealisees: activitesRealisees ?? this.activitesRealisees,
      defisRealises:      defisRealises      ?? this.defisRealises,
      tutosTelecharges:   tutosTelecharges   ?? this.tutosTelecharges,
    );
  }

  @override
  String toString() {
    return 'EnfantModel('
        'id: $id, '
        'nom: $nom, '
        'prenom: $prenom, '
        'naissance: $naissance, '
        'points: $points, '
        'niveau: $niveau'
        ')';
  }
}