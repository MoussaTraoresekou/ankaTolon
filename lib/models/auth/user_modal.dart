class UserModel {
  final String email;
  final String name;
  final String phoneNumber;
  final String userId;
  final String type;

  const UserModel({
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.userId,
    required this.type,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email:       json['email']       as String? ?? '',
      name:        json['name']        as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      userId:      json['userId']      as String? ?? '',
      type:        json['type']        as String? ?? 'parent',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email':       email,
      'name':        name,
      'phoneNumber': phoneNumber,
      'userId':      userId,
      'type':        type,
    };
  }

  UserModel copyWith({
    String? email,
    String? name,
    String? phoneNumber,
    String? userId,
    String? type,
  }) {
    return UserModel(
      email:       email       ?? this.email,
      name:        name        ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userId:      userId      ?? this.userId,
      type:        type        ?? this.type,
    );
  }

  bool get isAdmin  => type == 'admin';
  bool get isParent => type == 'parent';

  @override
  String toString() {
    return 'UserModel('
        'email: $email, '
        'name: $name, '
        'phoneNumber: $phoneNumber, '
        'userId: $userId, '
        'type: $type'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.email       == email       &&
        other.name        == name        &&
        other.phoneNumber == phoneNumber &&
        other.userId      == userId      &&
        other.type        == type;
  }

  @override
  int get hashCode =>
      email.hashCode       ^
      name.hashCode        ^
      phoneNumber.hashCode ^
      userId.hashCode      ^
      type.hashCode;
}