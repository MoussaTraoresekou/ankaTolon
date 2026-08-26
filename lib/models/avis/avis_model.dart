import 'package:cloud_firestore/cloud_firestore.dart';

class AvisModel {
  final String id;
  final String userId;
  final int note;
  final String commentaire;
  final DateTime date;

  const AvisModel({
    required this.id,
    required this.userId,
    required this.note,
    required this.commentaire,
    required this.date,
  });

  factory AvisModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? {};

    return AvisModel(
      id: snapshot.id,
      userId: data['user_id']?.toString() ?? '',
      note: (data['note'] ?? 0).toInt(),
      commentaire:
          data['commentaire']?.toString() ?? '',
      date: data['date'] is Timestamp
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'note': note,
      'commentaire': commentaire,
      'date': Timestamp.fromDate(date),
    };
  }
}