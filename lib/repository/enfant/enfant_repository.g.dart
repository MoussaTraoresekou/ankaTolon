// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enfant_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(enfantRepository)
final enfantRepositoryProvider = EnfantRepositoryProvider._();

final class EnfantRepositoryProvider
    extends
        $FunctionalProvider<
          EnfantRepository,
          EnfantRepository,
          EnfantRepository
        >
    with $Provider<EnfantRepository> {
  EnfantRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enfantRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enfantRepositoryHash();

  @$internal
  @override
  $ProviderElement<EnfantRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EnfantRepository create(Ref ref) {
    return enfantRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EnfantRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EnfantRepository>(value),
    );
  }
}

String _$enfantRepositoryHash() => r'8bf83d59c8784e6aa20ab7a0ab866ad4eb099c58';

@ProviderFor(enfants)
final enfantsProvider = EnfantsProvider._();

final class EnfantsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EnfantModel>>,
          List<EnfantModel>,
          Stream<List<EnfantModel>>
        >
    with
        $FutureModifier<List<EnfantModel>>,
        $StreamProvider<List<EnfantModel>> {
  EnfantsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enfantsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enfantsHash();

  @$internal
  @override
  $StreamProviderElement<List<EnfantModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<EnfantModel>> create(Ref ref) {
    return enfants(ref);
  }
}

String _$enfantsHash() => r'9a851a52984c621384c0f1729286137f40a843e7';
