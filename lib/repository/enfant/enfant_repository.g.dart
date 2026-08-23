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

String _$enfantRepositoryHash() => r'253ca3bf4009a42f39edabe7cc918ac53547d625';

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
