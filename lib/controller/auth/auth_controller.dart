import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/auth/user_modal.dart';
import 'package:tolon/repository/authRepository/auth_repository.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() async {}

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      state = AsyncError('Veuillez remplir tous les champs !', StackTrace.current);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).connectionAvecEmailPassword(
            email: email,
            password: password,
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
      state = AsyncValue.error('Veuillez remplir toutes les informations !', StackTrace.current);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).createUserWithEmailPasseword(
            email: email,
            password: password,
            nom: nom,
            prenom: prenom,
            phoneNumber: phoneNumber,
            type: UserType.parent,   // fixé : l'inscription publique ne crée que des parents
          ),
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).deconnecter());
  }
}