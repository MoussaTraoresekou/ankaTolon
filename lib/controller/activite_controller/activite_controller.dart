import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/activites/activite_model.dart';
import 'package:tolon/repository/activite_repository/activite_repository.dart';

part 'activite_controller.g.dart';

@riverpod
class ActiviteController extends _$ActiviteController {
  @override
  FutureOr<void> build() async {}

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

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () async {
        await ref.read(activiteRepositoryProvider).ajouterActivite(
              activite,
              image: image,
              video: video,
            );
      },
    );

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
          .modifierActivite(
            activite,
            image: image,
            video: video,
          ),
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
      () => ref
          .read(activiteRepositoryProvider)
          .supprimerActivite(activiteId),
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
      () => ref.read(activiteRepositoryProvider).ajouterActiviteRealisee(
            parentUid: parentUid,
            enfantId: enfantId,
            activiteId: activiteId,
          ),
    );
    return !state.hasError;
  }
}
