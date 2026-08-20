// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enfant_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EnfantController)
final enfantControllerProvider = EnfantControllerProvider._();

final class EnfantControllerProvider
    extends $AsyncNotifierProvider<EnfantController, void> {
  EnfantControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enfantControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enfantControllerHash();

  @$internal
  @override
  EnfantController create() => EnfantController();
}

String _$enfantControllerHash() => r'e05bf349b5364a6b0c458f468c041e4276f22d93';

abstract class _$EnfantController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(enfantsStream)
final enfantsStreamProvider = EnfantsStreamProvider._();

final class EnfantsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EnfantModel>>,
          List<EnfantModel>,
          Stream<List<EnfantModel>>
        >
    with
        $FutureModifier<List<EnfantModel>>,
        $StreamProvider<List<EnfantModel>> {
  EnfantsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enfantsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enfantsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<EnfantModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<EnfantModel>> create(Ref ref) {
    return enfantsStream(ref);
  }
}

String _$enfantsStreamHash() => r'cd9b6228e6c360af6d35f9bdb3487fa081cf8f33';
