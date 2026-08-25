import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';

part 'enfant_repository.g.dart';

class EnfantRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  EnfantRepository(this.firestore, this.auth);

  String get _uid {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('Aucun utilisateur connecté');
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get enfantsRef {
    return firestore.collection('users').doc(_uid).collection('enfants');
  }

  Future<void> ajouterEnfant(EnfantModel enfant) async {
    await enfantsRef.add(enfant.toJson());
  }

  Stream<List<EnfantModel>> streamEnfants() {
    final user = auth.currentUser;

    if (user == null) {
      return Stream.error(Exception('Aucun utilisateur connecté'));
    }

    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('enfants')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return EnfantModel.fromJson(doc.data(), doc.id);
          }).toList();
        });
  }

  Future<EnfantModel?> getEnfant(String enfantId) async {
    final doc = await enfantsRef.doc(enfantId).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return EnfantModel.fromJson(doc.data()!, doc.id);
  }

  Future<void> modifierEnfant(EnfantModel enfant) async {
    await enfantsRef.doc(enfant.id).update(enfant.toJson());
  }
  Future<void> supprimerEnfant(String enfantId) async {
    await enfantsRef.doc(enfantId).delete();
  }
}

@riverpod
EnfantRepository enfantRepository(Ref ref) {
  return EnfantRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
}

@riverpod
Stream<List<EnfantModel>> enfantsStream(Ref ref) {
  final repository = ref.watch(enfantRepositoryProvider);

  return repository.streamEnfants();
}
