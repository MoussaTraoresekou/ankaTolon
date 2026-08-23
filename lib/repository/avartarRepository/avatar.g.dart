// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(avatarRepository)
final avatarRepositoryProvider = AvatarRepositoryProvider._();

final class AvatarRepositoryProvider
    extends
        $FunctionalProvider<
          AvatarRepository,
          AvatarRepository,
          AvatarRepository
        >
    with $Provider<AvatarRepository> {
  AvatarRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'avatarRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$avatarRepositoryHash();

  @$internal
  @override
  $ProviderElement<AvatarRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AvatarRepository create(Ref ref) {
    return avatarRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AvatarRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AvatarRepository>(value),
    );
  }
}

String _$avatarRepositoryHash() => r'1185fb022a88ddeaca5c20ca85acaa78464d2ce6';

@ProviderFor(avatarUrls)
final avatarUrlsProvider = AvatarUrlsProvider._();

final class AvatarUrlsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  AvatarUrlsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'avatarUrlsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$avatarUrlsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return avatarUrls(ref);
  }
}

String _$avatarUrlsHash() => r'6f60e399cb736ac42331508705decf132fbdd8b4';
