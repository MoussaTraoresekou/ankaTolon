import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/auth/user_modal.dart';

part 'auth_repository.g.dart'; // Vérifiez si votre build_runner génère en .dart.g.dart ou .g.dart selon votre config

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

  // Inscription parent (Nettoyée du signOut prématuré)
  Future<void> createUserWithEmailPasseword({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String type,
  }) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userModel = UserModel(
      email:       email,
      name:        name,
      phoneNumber: phoneNumber,
      userId:      cred.user!.uid,
      type:        type,
    );

    await _firestore
        .collection('users')
        .doc(cred.user!.uid)
        .set(userModel.toJson());
        
    // REMARQUE : Le signOut a été retiré d'ici. C'est l'écran (UI) qui déclenchera 
    // la déconnexion proprement au moment où le parent cliquera sur "Continuer" sur le pop-up.
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
