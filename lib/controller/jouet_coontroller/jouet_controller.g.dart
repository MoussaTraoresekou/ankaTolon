// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jouet_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(JouetController)
final jouetControllerProvider = JouetControllerProvider._();

final class JouetControllerProvider
    extends $AsyncNotifierProvider<JouetController, void> {
  JouetControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jouetControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jouetControllerHash();

  @$internal
  @override
  JouetController create() => JouetController();
}

String _$jouetControllerHash() => r'fcb8a787283a835c37d0afa87c2938d4584ef83a';

abstract class _$JouetController extends $AsyncNotifier<void> {
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
