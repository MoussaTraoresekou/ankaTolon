import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider du flux d'état d'authentification Firebase
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Stream pour écouter en temps réel les données de l'utilisateur dans Firestore
final userDocProvider = StreamProvider<DocumentSnapshot?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots();
});

/// Provider mis à jour pour lire le prénom depuis Firestore
final userDisplayNameProvider = Provider<String>((ref) {
  final userDoc = ref.watch(userDocProvider);

  return userDoc.when(
    data: (snapshot) {
      if (snapshot != null && snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['prenom'] != null) {
          return data['prenom'].toString();
        }
      }
      // Fallback sur Firebase Auth displayName si Firestore n'a rien
      final authUser = ref.read(authStateProvider).value;
      if (authUser?.displayName != null && authUser!.displayName!.isNotEmpty) {
        return authUser.displayName!.split(' ').first;
      }
      return 'Utilisateur';
    },
    loading: () => '...',
    error: (_, __) => 'Utilisateur',
  );
});
