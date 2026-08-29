import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';
import 'package:tolon/repository/enfant/enfant_repository.dart';

part 'enfant_controller.g.dart';

@Riverpod(keepAlive: true)
class EnfantController extends _$EnfantController {
  @override
  FutureOr<void> build() async {}

  bool validerInformationsEnfant({
    required String nom,
    required String prenom,
    required DateTime? naissance,
    required String? sexe,
  }) {
    if (nom.trim().isEmpty) {
      state = AsyncError(
        'Veuillez saisir le nom de l\'enfant.',
        StackTrace.current,
      );
      return false;
    }

    if (prenom.trim().isEmpty) {
      state = AsyncError(
        'Veuillez saisir le prénom de l\'enfant.',
        StackTrace.current,
      );
      return false;
    }

    if (naissance == null) {
      state = AsyncError(
        'Veuillez choisir une date de naissance.',
        StackTrace.current,
      );
      return false;
    }

    if (sexe == null || sexe.trim().isEmpty) {
      state = AsyncError(
        'Veuillez sélectionner le sexe de l\'enfant.',
        StackTrace.current,
      );
      return false;
    }

    return true;
  }

  Future<bool> ajouterEnfant({
    required String nom,
    required String prenom,
    required DateTime? naissance,
    required String? sexe,
    String? avatarUrl,
  }) async {
    final isValid = validerInformationsEnfant(
      nom: nom,
      prenom: prenom,
      naissance: naissance,
      sexe: sexe,
    );

    if (!isValid) {
      return false;
    }

    final enfant = EnfantModel(
      id: '',
      nom: nom.trim(),
      prenom: prenom.trim(),
      naissance: naissance!,
      sexe: sexe!,
      avatarUrl: avatarUrl,
      points: 0,
      niveau: 1,
      activitesRealisees: 0,
      defisRealises: const [],
      tutosTelecharges: const [],
    );
    state = const AsyncLoading();

    // Appel Repository
    state = await AsyncValue.guard(
      () => ref.read(enfantRepositoryProvider).ajouterEnfant(enfant),
    );

    return !state.hasError;
  }

  Future<bool> modifierEnfant(EnfantModel enfant) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(enfantRepositoryProvider).modifierEnfant(enfant),
    );

    return !state.hasError;
  }

  Future<bool> supprimerEnfant(String enfantId) async {
    if (enfantId.trim().isEmpty) {
      state = AsyncError(
        'Identifiant de l\'enfant invalide.',
        StackTrace.current,
      );
      return false;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(enfantRepositoryProvider).supprimerEnfant(enfantId),
    );

    return !state.hasError;
  }
}
