import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/repository/favoris/favoris_repository.dart';

// 1. Déclaration du NotifierProvider modernisé
final favorisControllerProvider =
    NotifierProvider<FavorisController, List<String>>(FavorisController.new);

// 2. La classe hérite de Notifier au lieu de StateNotifier
class FavorisController extends Notifier<List<String>> {
  @override
  List<String> build() {
    // Initialise l'état à vide puis charge les données
    chargerFavoris();
    return [];
  }

  FavorisRepository get _repository => ref.read(favorisRepositoryProvider);

  Future<void> chargerFavoris() async {
    final ids = await _repository.getFavoris();
    state = ids;
  }

  Future<void> toggleFavori(String jouetId) async {
    final existe = state.contains(jouetId);

    if (existe) {
      state = state.where((id) => id != jouetId).toList();
      await _repository.retirerFavori(jouetId);
    } else {
      state = [...state, jouetId];
      await _repository.ajouterFavori(jouetId);
    }
  }
}