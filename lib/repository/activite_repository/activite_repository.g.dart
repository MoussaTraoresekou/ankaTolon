// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activite_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activiteRepository)
final activiteRepositoryProvider = ActiviteRepositoryProvider._();

final class ActiviteRepositoryProvider
    extends
        $FunctionalProvider<
          ActiviteRepository,
          ActiviteRepository,
          ActiviteRepository
        >
    with $Provider<ActiviteRepository> {
  ActiviteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activiteRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activiteRepositoryHash();

  @$internal
  @override
  $ProviderElement<ActiviteRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActiviteRepository create(Ref ref) {
    return activiteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActiviteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActiviteRepository>(value),
    );
  }
}

String _$activiteRepositoryHash() =>
    r'b5a3673f2ffa48d999d64df919641afb8e44c28f';

@ProviderFor(activites)
final activitesProvider = ActivitesProvider._();

final class ActivitesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActiviteModel>>,
          List<ActiviteModel>,
          FutureOr<List<ActiviteModel>>
        >
    with
        $FutureModifier<List<ActiviteModel>>,
        $FutureProvider<List<ActiviteModel>> {
  ActivitesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activitesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activitesHash();

  @$internal
  @override
  $FutureProviderElement<List<ActiviteModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ActiviteModel>> create(Ref ref) {
    return activites(ref);
  }
}

String _$activitesHash() => r'41e00f487d81380f78a4f0ac83cab2e736402470';

@ProviderFor(activiteById)
final activiteByIdProvider = ActiviteByIdFamily._();

final class ActiviteByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActiviteModel?>,
          ActiviteModel?,
          FutureOr<ActiviteModel?>
        >
    with $FutureModifier<ActiviteModel?>, $FutureProvider<ActiviteModel?> {
  ActiviteByIdProvider._({
    required ActiviteByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'activiteByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activiteByIdHash();

  @override
  String toString() {
    return r'activiteByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ActiviteModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ActiviteModel?> create(Ref ref) {
    final argument = this.argument as String;
    return activiteById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiviteByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activiteByIdHash() => r'eafd347cbfe2fc3ba618926092d25ac5b70772bb';

final class ActiviteByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ActiviteModel?>, String> {
  ActiviteByIdFamily._()
    : super(
        retry: null,
        name: r'activiteByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ActiviteByIdProvider call(String id) =>
      ActiviteByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'activiteByIdProvider';
}

@ProviderFor(watchActivites)
final watchActivitesProvider = WatchActivitesProvider._();

final class WatchActivitesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ActiviteModel>>,
          List<ActiviteModel>,
          Stream<List<ActiviteModel>>
        >
    with
        $FutureModifier<List<ActiviteModel>>,
        $StreamProvider<List<ActiviteModel>> {
  WatchActivitesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchActivitesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchActivitesHash();

  @$internal
  @override
  $StreamProviderElement<List<ActiviteModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ActiviteModel>> create(Ref ref) {
    return watchActivites(ref);
  }
}

String _$watchActivitesHash() => r'9b16e911346c9489d7cc7acaa3a62115c60e1386';

@ProviderFor(watchCategories)
final watchCategoriesProvider = WatchCategoriesProvider._();

final class WatchCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategorieModel>>,
          List<CategorieModel>,
          Stream<List<CategorieModel>>
        >
    with
        $FutureModifier<List<CategorieModel>>,
        $StreamProvider<List<CategorieModel>> {
  WatchCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchCategoriesHash();

  @$internal
  @override
  $StreamProviderElement<List<CategorieModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CategorieModel>> create(Ref ref) {
    return watchCategories(ref);
  }
}

String _$watchCategoriesHash() => r'1a47dc6766482799b535665ad68209b0853a11de';
