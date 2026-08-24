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

String _$enfantControllerHash() => r'40b6aa33896b0e0bcfc6997e397d011b2bef59d4';

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
