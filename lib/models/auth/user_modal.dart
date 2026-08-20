enum UserType { admin, parent }

class UserModel {
  final String email;
  final String nom;
  final String prenom;
  final String phoneNumber;
  final String uid;
  final UserType type;

  const UserModel({
    required this.email,
    required this.nom,
    required this.prenom,
    required this.phoneNumber,
    required this.uid,
    required this.type,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String uid) {
    return UserModel(
      uid:         uid,
      email:       json['email']       as String? ?? '',
      nom:         json['nom']         as String? ?? '',
      prenom:      json['prenom']      as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      type: UserType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => UserType.parent,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email':       email,
      'nom':         nom,
      'prenom':      prenom,
      'phoneNumber': phoneNumber,
      'type':        type.name,
    };
  }

  UserModel copyWith({
    String? email,
    String? nom,
    String? prenom,
    String? phoneNumber,
    String? uid,
    UserType? type,
  }) {
    return UserModel(
      email:       email       ?? this.email,
      nom:         nom         ?? this.nom,
      prenom:      prenom      ?? this.prenom,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      uid:         uid         ?? this.uid,
      type:        type        ?? this.type,
    );
  }

  bool get isAdmin => type == UserType.admin;

  @override
  String toString() {
    return 'UserModel('
        'email: $email, '
        'nom: $nom, '
        'prenom: $prenom, '
        'phoneNumber: $phoneNumber, '
        'uid: $uid, '
        'type: ${type.name}'
        ')';
  }
}