// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jouet_plusAchete_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(topJouetsAchetes)
final topJouetsAchetesProvider = TopJouetsAchetesProvider._();

final class TopJouetsAchetesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          Stream<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $StreamProvider<List<Map<String, dynamic>>> {
  TopJouetsAchetesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topJouetsAchetesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topJouetsAchetesHash();

  @$internal
  @override
  $StreamProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Map<String, dynamic>>> create(Ref ref) {
    return topJouetsAchetes(ref);
  }
}

String _$topJouetsAchetesHash() => r'c92849a40300387888a202712741cd4c94d9da03';
