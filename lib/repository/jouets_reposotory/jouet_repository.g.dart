// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jouet_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(jouetRepository)
final jouetRepositoryProvider = JouetRepositoryProvider._();

final class JouetRepositoryProvider
    extends
        $FunctionalProvider<JouetRepository, JouetRepository, JouetRepository>
    with $Provider<JouetRepository> {
  JouetRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jouetRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jouetRepositoryHash();

  @$internal
  @override
  $ProviderElement<JouetRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JouetRepository create(Ref ref) {
    return jouetRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JouetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JouetRepository>(value),
    );
  }
}

String _$jouetRepositoryHash() => r'4f1c7d28e561576a780bf6448b09e6b6956d1132';

@ProviderFor(watchJouets)
final watchJouetsProvider = WatchJouetsProvider._();

final class WatchJouetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<JouetModel>>,
          List<JouetModel>,
          Stream<List<JouetModel>>
        >
    with $FutureModifier<List<JouetModel>>, $StreamProvider<List<JouetModel>> {
  WatchJouetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchJouetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchJouetsHash();

  @$internal
  @override
  $StreamProviderElement<List<JouetModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<JouetModel>> create(Ref ref) {
    return watchJouets(ref);
  }
}

String _$watchJouetsHash() => r'147a665a94323f9b1a35cba3ea349ab5bf96a174';

@ProviderFor(streamJouetLesplusNotes)
final streamJouetLesplusNotesProvider = StreamJouetLesplusNotesProvider._();

final class StreamJouetLesplusNotesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<JouetModel>>,
          List<JouetModel>,
          Stream<List<JouetModel>>
        >
    with $FutureModifier<List<JouetModel>>, $StreamProvider<List<JouetModel>> {
  StreamJouetLesplusNotesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streamJouetLesplusNotesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streamJouetLesplusNotesHash();

  @$internal
  @override
  $StreamProviderElement<List<JouetModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<JouetModel>> create(Ref ref) {
    return streamJouetLesplusNotes(ref);
  }
}

String _$streamJouetLesplusNotesHash() =>
    r'218ec9928c541d110887c63e67f19303667f993a';
