import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favorisRepositoryProvider = Provider((ref) => FavorisRepository());

class FavorisRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  // Récupère la liste des IDs de jouets favoris du parent connecté
  Future<List<String>> getFavoris() async {
    if (_currentUserId.isEmpty) return [];
    
    final doc = await _firestore.collection('favoris').doc(_currentUserId).get();
    if (doc.exists && doc.data() != null) {
      return List<String>.from(doc.data()!['favoris'] ?? []);
    }
    return [];
  }

  // Ajoute un jouet aux favoris
  Future<void> ajouterFavori(String jouetId) async {
    if (_currentUserId.isEmpty) return;
    await _firestore.collection('favoris').doc(_currentUserId).set({
      'favoris': FieldValue.arrayUnion([jouetId]),
    }, SetOptions(merge: true));
  }

  // Retire un jouet des favoris
  Future<void> retirerFavori(String jouetId) async {
    if (_currentUserId.isEmpty) return;
    await _firestore.collection('favoris').doc(_currentUserId).set({
      'favoris': FieldValue.arrayRemove([jouetId]),
    }, SetOptions(merge: true));
  }
}