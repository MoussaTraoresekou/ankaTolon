import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/auth/user_modal.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRepository(this.auth);

  /// Vérifie si le mot de passe saisi correspond à l'utilisateur actuellement connecté
  Future<bool> verifierMotDePasse(String password) async {
    try {
      final user = auth.currentUser;
      if (user != null && user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        // Effectue la réauthentification auprès de Firebase
        await user.reauthenticateWithCredential(credential);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> connectionAvecEmailPassword({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

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
      email: email,
      nom: nom,
      prenom: prenom,
      phoneNumber: phoneNumber,
      uid: cred.user!.uid,
      type: type,
    );

    // Conversion en Map et ajout de la date d'inscription du serveur
    final Map<String, dynamic> userData = userModel.toJson();
    userData['date_inscription'] = FieldValue.serverTimestamp();

    await _firestore
        .collection('users')
        .doc(cred.user!.uid)
        .set(userData); // Correction : enregistre userData avec la date
  }

  User? get currentUser => auth.currentUser;

  Stream<User?> authStateChange() {
    return auth.authStateChanges();
  }

  Future<void> modifierInformations({
    required String nom,
    required String prenom,
    required String phoneNumber,
  }) async {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('Aucun utilisateur connecté.');
    }

    final modifications = <String, dynamic>{
      'nom': nom.trim(),
      'prenom': prenom.trim(),
      'phoneNumber': phoneNumber.trim(),
    };

    await _firestore.collection('users').doc(user.uid).update(modifications);
  }

  Future<void> deconnecter() async {
    await auth.signOut();
  }

  Future<void> reinitialiserMotDePasse({required String email}) async {
    await auth.sendPasswordResetEmail(email: email);
  }
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

@riverpod
Stream<UserModel?> userData(Ref ref) {
  final user = ref.watch(currentUserProvider);

  if (user == null) {
    return Stream.value(null);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) {
        if (!doc.exists || doc.data() == null) {
          return null;
        }

        return UserModel.fromJson(doc.data()!, doc.id);
      });
}
