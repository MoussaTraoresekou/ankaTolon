import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tolon/models/auth/user_modal.dart';
import 'package:tolon/repository/authRepository/auth_repository.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() async {
    return null;
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      state = AsyncError(
        'Veuillez remplir tous les champs !',
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .connectionAvecEmailPassword(
            email: email.trim(),
            password: password.trim(),
          ),
    );
  }

  Future<void> loginOrCreateUserWithEmailAndPassword({
    required String email,
    required String password,
    required String nom,
    required String prenom,
    required String phoneNumber,
  }) async {
    if (email.trim().isEmpty ||
        password.trim().isEmpty ||
        nom.trim().isEmpty ||
        prenom.trim().isEmpty ||
        phoneNumber.trim().isEmpty) {
      state = AsyncError(
        'Veuillez remplir toutes les informations !',
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .createUserWithEmailPasseword(
            email: email.trim(),
            password: password.trim(),
            nom: nom.trim(),
            prenom: prenom.trim(),
            phoneNumber: phoneNumber.trim(),
            type: UserType.parent,
          ),
    );
  }

  Future<bool> modifierInformation({
  required String nom,
  required String prenom,
  required String phoneNumber,
}) async {
  if (nom.trim().isEmpty ||
      prenom.trim().isEmpty ||
      phoneNumber.trim().isEmpty) {
    state = AsyncError(
      'Veuillez remplir tous les champs !',
      StackTrace.current,
    );
    return false;
  }

  if (!RegExp(r'^\d{8}$').hasMatch(phoneNumber.trim())) {
    state = AsyncError(
      'Le numéro de téléphone doit contenir exactement 8 chiffres.',
      StackTrace.current,
    );
    return false;
  }

  state = const AsyncLoading();

  state = await AsyncValue.guard(
    () => ref.read(authRepositoryProvider).modifierInformations(
          nom: nom.trim(),
          prenom: prenom.trim(),
          phoneNumber: phoneNumber.trim(),
        ),
  );

  return !state.hasError;
}

  Future<void> logout() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).deconnecter(),
    );
  }
  Future<bool> reinitialiserMotDePasse({required String email}) async {
  if (email.trim().isEmpty) {
    state = AsyncError('Veuillez saisir votre adresse email.', StackTrace.current);
    return false;
  }
  state = const AsyncLoading();
  state = await AsyncValue.guard(
    () => ref.read(authRepositoryProvider).reinitialiserMotDePasse(email: email.trim()),
  );
  return !state.hasError;
}
}