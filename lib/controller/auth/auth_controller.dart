import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    required String name,
    required String phoneNumber,
    required String type,
  }) async {
    if (email.trim().isEmpty ||
        password.trim().isEmpty ||
        name.trim().isEmpty ||
        phoneNumber.trim().isEmpty ||
        type.trim().isEmpty) {
      state = AsyncValue.error('Veuillez remplir toutes les informations !', StackTrace.current);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).createUserWithEmailPasseword(
            email: email,
            password: password,
            name: name,
            phoneNumber: phoneNumber,
            type: type,
          ),
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).deconnecter());
  }
}
