// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutoriel_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tutorielRepository)
final tutorielRepositoryProvider = TutorielRepositoryProvider._();

final class TutorielRepositoryProvider
    extends
        $FunctionalProvider<
          TutorielRepository,
          TutorielRepository,
          TutorielRepository
        >
    with $Provider<TutorielRepository> {
  TutorielRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tutorielRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tutorielRepositoryHash();

  @$internal
  @override
  $ProviderElement<TutorielRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TutorielRepository create(Ref ref) {
    return tutorielRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TutorielRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TutorielRepository>(value),
    );
  }
}

String _$tutorielRepositoryHash() =>
    r'ee4c106a8a1567a617c44da9b957d702062d4b6a';

@ProviderFor(watchTutoriels)
final watchTutorielsProvider = WatchTutorielsProvider._();

final class WatchTutorielsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TutorielModel>>,
          List<TutorielModel>,
          Stream<List<TutorielModel>>
        >
    with
        $FutureModifier<List<TutorielModel>>,
        $StreamProvider<List<TutorielModel>> {
  WatchTutorielsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchTutorielsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchTutorielsHash();

  @$internal
  @override
  $StreamProviderElement<List<TutorielModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TutorielModel>> create(Ref ref) {
    return watchTutoriels(ref);
  }
}

String _$watchTutorielsHash() => r'dd217ff241f1e6be7206071044ab74aceaffb407';
