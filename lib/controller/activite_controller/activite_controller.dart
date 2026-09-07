import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/activites/activite_model.dart';
import 'package:tolon/repository/activite_repository/activite_repository.dart';

part 'activite_controller.g.dart';

@riverpod
class ActiviteController extends _$ActiviteController {
  @override
  FutureOr<void> build() async {}

  bool validerActivite({
    required String titre,
    required String description,
    required String ageMinText,
    required String ageMaxText,
    required String dureeText,
    required dynamic categorie,
  }) {
    if (titre.trim().isEmpty) {
      state = AsyncError(
        'Veuillez saisir le titre de l\'activité.',
        StackTrace.current,
      );
      return false;
    }

    if (description.trim().isEmpty) {
      state = AsyncError(
        'Veuillez saisir la description de l\'activité.',
        StackTrace.current,
      );
      return false;
    }

    if (categorie == null) {
      state = AsyncError(
        'Veuillez sélectionner une catégorie.',
        StackTrace.current,
      );
      return false;
    }

    if (ageMinText.trim().isEmpty) {
      state = AsyncError('Veuillez saisir l\'âge minimum.', StackTrace.current);
      return false;
    }

    final ageMin = int.tryParse(ageMinText.trim());

    if (ageMin == null) {
      state = AsyncError(
        'L\'âge minimum doit être un nombre entier.',
        StackTrace.current,
      );
      return false;
    }

    if (ageMin < 0) {
      state = AsyncError(
        'L\'âge minimum ne peut pas être négatif.',
        StackTrace.current,
      );
      return false;
    }

    if (ageMaxText.trim().isEmpty) {
      state = AsyncError('Veuillez saisir l\'âge maximum.', StackTrace.current);
      return false;
    }

    final ageMax = int.tryParse(ageMaxText.trim());

    if (ageMax == null) {
      state = AsyncError(
        'L\'âge maximum doit être un nombre entier.',
        StackTrace.current,
      );
      return false;
    }

    if (ageMax < 0) {
      state = AsyncError(
        'L\'âge maximum ne peut pas être négatif.',
        StackTrace.current,
      );
      return false;
    }

    if (ageMin > ageMax) {
      state = AsyncError(
        'L\'âge minimum ne peut pas être supérieur à l\'âge maximum.',
        StackTrace.current,
      );
      return false;
    }

    if (dureeText.trim().isEmpty) {
      state = AsyncError(
        'Veuillez saisir la durée de l\'activité.',
        StackTrace.current,
      );
      return false;
    }

    final duree = int.tryParse(dureeText.trim());

    if (duree == null) {
      state = AsyncError(
        'La durée doit être un nombre entier.',
        StackTrace.current,
      );
      return false;
    }

    if (duree <= 0) {
      state = AsyncError(
        'La durée doit être supérieure à 0 minute.',
        StackTrace.current,
      );
      return false;
    }

    return true;
  }

  Future<bool> ajouterActivite(
    ActiviteModel activite, {
    File? image,
    File? video,
  }) async {
    if (activite.titre.trim().isEmpty) {
      state = AsyncError(
        'Veuillez saisir le titre de l\'activité.',
        StackTrace.current,
      );
      return false;
    }

    if (activite.description.trim().isEmpty) {
      state = AsyncError(
        'Veuillez saisir la description de l\'activité.',
        StackTrace.current,
      );
      return false;
    }

    if (activite.categorieId == null) {
      state = AsyncError(
        'Veuillez sélectionner une catégorie.',
        StackTrace.current,
      );
      return false;
    }

    if (activite.ageMin < 0) {
      state = AsyncError(
        'L\'âge minimum ne peut pas être négatif.',
        StackTrace.current,
      );
      return false;
    }

    if (activite.ageMax < 0) {
      state = AsyncError(
        'L\'âge maximum ne peut pas être négatif.',
        StackTrace.current,
      );
      return false;
    }

    if (activite.ageMin > activite.ageMax) {
      state = AsyncError(
        'L\'âge minimum ne peut pas être supérieur à l\'âge maximum.',
        StackTrace.current,
      );
      return false;
    }

    if (activite.dureeMinutes <= 0) {
      state = AsyncError(
        'La durée doit être supérieure à 0 minute.',
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref
          .read(activiteRepositoryProvider)
          .ajouterActivite(activite, image: image, video: video);
    });

    return !state.hasError;
  }

  Future<bool> modifierActivite(
    ActiviteModel activite, {
    File? image,
    File? video,
  }) async {
    if (activite.id.trim().isEmpty) {
      state = AsyncError(
        'Identifiant de l\'activité invalide.',
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref
          .read(activiteRepositoryProvider)
          .modifierActivite(activite, image: image, video: video),
    );

    return !state.hasError;
  }

  Future<bool> supprimerActivite(String activiteId) async {
    if (activiteId.trim().isEmpty) {
      state = AsyncError(
        'Identifiant de l\'activité invalide.',
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(activiteRepositoryProvider).supprimerActivite(activiteId),
    );

    return !state.hasError;
  }

  Future<bool> marquerCommeTerminee({
    required String parentUid,
    required String enfantId,
    required String activiteId,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref
          .read(activiteRepositoryProvider)
          .ajouterActiviteRealisee(
            parentUid: parentUid,
            enfantId: enfantId,
            activiteId: activiteId,
          ),
    );

    return !state.hasError;
  }
}
