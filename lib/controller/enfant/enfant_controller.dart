import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';
import 'package:tolon/repository/enfant/enfant_repository.dart';

part 'enfant_controller.g.dart';

@riverpod
class EnfantController extends _$EnfantController {
  @override
  FutureOr<void> build() async {}

  Future<bool> ajouterEnfant({
    required String nom,
    required String prenom,
    required DateTime naissance,
  }) async {
    if (nom.trim().isEmpty || prenom.trim().isEmpty) {
      state = AsyncError('Veuillez remplir tous les champs !', StackTrace.current);
      return false;
    }

    final enfant = EnfantModel(
      id: '',
      nom: nom.trim(),
      prenom: prenom.trim(),
      naissance: naissance,
      points: 0,
      niveau: 1,
      activitesRealisees: 0,
      defisRealises: const [],
      tutosTelecharges: const [],
    );

    state = const AsyncLoading();
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
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(enfantRepositoryProvider).supprimerEnfant(enfantId),
    );
    return !state.hasError;
  }
}

@riverpod
Stream<List<EnfantModel>> enfantsStream(Ref ref) {
  final repository = ref.watch(enfantRepositoryProvider);
  return repository.streamEnfants();
}