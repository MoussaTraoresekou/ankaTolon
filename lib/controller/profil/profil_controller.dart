import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/models/auth/user_modal.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';
import 'package:tolon/repository/profil/profil_repository.dart';

final profilControllerProvider =
    NotifierProvider<ProfilController, ProfilState>(
  ProfilController.new,
);

class ProfilState {
  final UserModel? utilisateur;
  final List<EnfantModel> enfants;
  final bool chargement;

  const ProfilState({
    this.utilisateur,
    this.enfants = const [],
    this.chargement = false,
  });

  ProfilState copyWith({
    UserModel? utilisateur,
    List<EnfantModel>? enfants,
    bool? chargement,
  }) {
    return ProfilState(
      utilisateur: utilisateur ?? this.utilisateur,
      enfants: enfants ?? this.enfants,
      chargement: chargement ?? this.chargement,
    );
  }
}

class ProfilController extends Notifier<ProfilState> {
  ProfilRepository get _repository =>
      ref.read(profilRepositoryProvider);

  @override
  ProfilState build() {
    return const ProfilState();
  }

  // Remplace chargerProfil() par une écoute en temps réel
void initialiserProfil() {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  state = state.copyWith(chargement: true);

  //  Écouter l'utilisateur en temps réel
  FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .listen((snapshot) async {
    if (snapshot.exists && snapshot.data() != null) {
      final user = UserModel.fromJson(snapshot.data()!, snapshot.id);

      //  Charger les enfants correspondant à cet utilisateur
      final enfantsSnapshot = await FirebaseFirestore.instance
          .collection('users') 
          .doc(uid)
          .collection('enfants') 
          .get();

      final listeEnfants = enfantsSnapshot.docs
          .map((doc) => EnfantModel.fromJson(doc.data(), doc.id))
          .toList();

      //  Mettre à jour l'état AVEC l'utilisateur ET les enfants
      state = state.copyWith(
        utilisateur: user,
        enfants: listeEnfants, 
        chargement: false,
      );
    }
  });
}

  Future<void> deconnexion() async {
    await _repository.logout();
  }
}