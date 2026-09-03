// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activite_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiviteController)
final activiteControllerProvider = ActiviteControllerProvider._();

final class ActiviteControllerProvider
    extends $AsyncNotifierProvider<ActiviteController, void> {
  ActiviteControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activiteControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activiteControllerHash();

  @$internal
  @override
  ActiviteController create() => ActiviteController();
}

String _$activiteControllerHash() =>
    r'7f69d3d2cd13238b518ad5e1cbbbbc2d07f5e8c8';

abstract class _$ActiviteController extends $AsyncNotifier<void> {
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
