import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/auth/user_modal.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRepository(this.auth);

  // Connexion
  Future<void> connectionAvecEmailPassword({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Inscription parent
  Future<void> createUserWithEmailPasseword({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String phoneNumber,
    required UserType type,
  }) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userModel = UserModel(
      email:       email,
      nom:         nom,
      prenom:      prenom,
      phoneNumber: phoneNumber,
      uid:         cred.user!.uid,
      type:        type,
    );

     // On convertit en JSON et on ajoute dynamiquement la date du serveur
    final Map<String, dynamic> userData = userModel.toJson();
    userData['date_inscription'] = FieldValue.serverTimestamp(); // Enregistre l'heure précise de l'inscription


    await _firestore
        .collection('users')
        .doc(cred.user!.uid)
        .set(userModel.toJson());
  }

  User? get currentUser => auth.currentUser;

  Stream<User?> authStateChange() => auth.authStateChanges();

  Future<void> deconnecter() async => await auth.signOut();
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(FirebaseAuth.instance);
}

@riverpod
Stream<User?> authStateChanges(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChange();
}

@riverpod
User? currentUser(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentUser;
}