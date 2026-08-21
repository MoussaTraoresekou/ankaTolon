import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/jouets/jouet_models.dart';
import 'package:tolon/repository/jouets_reposotory/jouet_repository.dart';

part 'jouet_controller.g.dart';

@riverpod
class JouetController extends _$JouetController {
  @override
  FutureOr<void> build() async {}

  // ============================================================
  // AJOUTER UN JOUET
  // ============================================================

  Future<bool> ajouterJouet({
    required String nom,
    required String ageMin,
    required String ageMax,
    required String prix,
    required String description,
    required String benefices,
    required DocumentReference? categorieId,
    required List<File> images,
  }) async {
    // ==========================================================
    // VALIDATION DU NOM
    // ==========================================================

    if (nom.trim().isEmpty) {
      state = AsyncError(
        'Veuillez saisir le nom du jouet.',
        StackTrace.current,
      );
      return false;
    }

    // ==========================================================
    // VALIDATION CATÉGORIE
    // ==========================================================

    if (categorieId == null) {
      state = AsyncError(
        'Veuillez sélectionner une catégorie.',
        StackTrace.current,
      );
      return false;
    }

    // ==========================================================
    // CONVERSION ÂGE MINIMUM
    // ==========================================================

    final ageMinValue = int.tryParse(
      ageMin.trim(),
    );

    if (ageMinValue == null) {
      state = AsyncError(
        'Veuillez saisir un âge minimum valide.',
        StackTrace.current,
      );
      return false;
    }

    // ==========================================================
    // CONVERSION ÂGE MAXIMUM
    // ==========================================================

    final ageMaxValue = int.tryParse(
      ageMax.trim(),
    );

    if (ageMaxValue == null) {
      state = AsyncError(
        'Veuillez saisir un âge maximum valide.',
        StackTrace.current,
      );
      return false;
    }

    // ==========================================================
    // VALIDATION DES ÂGES
    // ==========================================================

    if (ageMinValue < 0 || ageMaxValue < 0) {
      state = AsyncError(
        'Les âges doivent être positifs.',
        StackTrace.current,
      );
      return false;
    }

    if (ageMinValue > ageMaxValue) {
      state = AsyncError(
        'L’âge minimum ne peut pas être supérieur à l’âge maximum.',
        StackTrace.current,
      );
      return false;
    }

    // ==========================================================
    // CONVERSION PRIX
    // ==========================================================

    final prixValue = double.tryParse(
      prix.trim().replaceAll(',', '.'),
    );

    if (prixValue == null || prixValue < 0) {
      state = AsyncError(
        'Veuillez saisir un prix valide.',
        StackTrace.current,
      );
      return false;
    }

    // ==========================================================
    // VALIDATION DESCRIPTION
    // ==========================================================

    if (description.trim().isEmpty) {
      state = AsyncError(
        'Veuillez saisir une description.',
        StackTrace.current,
      );
      return false;
    }

    // ==========================================================
    // VALIDATION DES IMAGES
    // ==========================================================

    if (images.isEmpty) {
      state = AsyncError(
        'Veuillez sélectionner au moins une image.',
        StackTrace.current,
      );
      return false;
    }

    // ==========================================================
    // CONVERSION DES BÉNÉFICES
    // ==========================================================

    final List<String> beneficesList = benefices
        .split(',')
        .map(
          (benefice) => benefice.trim(),
        )
        .where(
          (benefice) => benefice.isNotEmpty,
        )
        .toList();

    // ==========================================================
    // CRÉATION DU MODEL
    // ==========================================================

    final jouet = JouetModel(
      id: '',
      ageMax: ageMaxValue,
      ageMin: ageMinValue,
      benefices: beneficesList,
      categorieId: categorieId,
      dateAjout: DateTime.now(),
      description: description.trim(),
      image: [],
      nomJouet: nom.trim(),
      noteMoyen: 0,
      prix: prixValue,
    );

    // ==========================================================
    // ENVOI AU REPOSITORY
    // ==========================================================

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref
          .read(jouetRepositoryProvider)
          .ajouterJouet(
            jouet: jouet,
            images: images,
          ),
    );

    return !state.hasError;
  }

  // ============================================================
  // MODIFIER UN JOUET
  // ============================================================

  Future<bool> modifierJouet(
    JouetModel jouet,
  ) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref
          .read(jouetRepositoryProvider)
          .modifierJouet(
            jouet: jouet,
          ),
    );

    return !state.hasError;
  }

  // ============================================================
  // SUPPRIMER UN JOUET
  // ============================================================

  Future<bool> supprimerJouet(
    String jouetId,
  ) async {
    if (jouetId.trim().isEmpty) {
      state = AsyncError(
        'L\'identifiant du jouet est obligatoire.',
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref
          .read(jouetRepositoryProvider)
          .supprimerJouet(
            jouetId,
          ),
    );

    return !state.hasError;
  }
}