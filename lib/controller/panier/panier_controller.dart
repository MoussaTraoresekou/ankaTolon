import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/jouets/jouet_models.dart';
import '../../models/commande/command_model.dart';

class PanierState {
  final List<CommandeItem> items;
  const PanierState({this.items = const []});

  double get total =>
      items.fold(0, (sum, item) => sum + (item.prixUnitaire * item.quantite));

  // Nombre d'articles DISTINCTS (pour le badge)
  int get distinctItemCount => items.length;

  // Nombre total d'exemplaires (pour le sous-total et la commande)
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantite);

  PanierState copyWith({List<CommandeItem>? items}) =>
      PanierState(items: items ?? this.items);
}

class PanierNotifier extends Notifier<PanierState> {
  @override
  PanierState build() => const PanierState();

  // On passe directement le JouetModel
  void addToCart(JouetModel jouet) {
    final current = state.items;
    final index = current.indexWhere((item) => item.jouetId == jouet.id);

    final imageUrl = jouet.image.isNotEmpty
        ? jouet.image.first
        : ''; // On extrait la 1ère image de la liste, ou une chaîne vide si vide

    if (index != -1) {
      final item = current[index];
      final updated = CommandeItem(
        jouetId: item.jouetId,
        nomJouet: item.nomJouet,
        image: item.image,
        quantite: item.quantite + 1,
        prixUnitaire: item.prixUnitaire,
      );
      final newList = [...current]..[index] = updated;
      state = state.copyWith(items: newList);
    } else {
      state = state.copyWith(
        items: [
          ...current,
          CommandeItem(
            jouetId: jouet.id,
            nomJouet: jouet.nomJouet,
            image: imageUrl,
            quantite: 1,
            prixUnitaire: jouet.prix,
          ),
        ],
      );
    }
  }

  void removeFromCart(String jouetId) {
    state = state.copyWith(
      items: state.items.where((item) => item.jouetId != jouetId).toList(),
    );
  }

  void incrementItem(String jouetId) {
    final index = state.items.indexWhere((item) => item.jouetId == jouetId);
    if (index != -1) {
      final current = state.items;
      final item = current[index];
      final updated = CommandeItem(
        jouetId: item.jouetId,
        nomJouet: item.nomJouet,
        image: item.image,
        quantite: item.quantite + 1,
        prixUnitaire: item.prixUnitaire,
      );
      final newList = [...current]..[index] = updated;
      state = state.copyWith(items: newList);
    }
  }

  void decrementItem(String jouetId) {
    final index = state.items.indexWhere((item) => item.jouetId == jouetId);
    if (index != -1) {
      final current = state.items;
      final item = current[index];
      if (item.quantite > 1) {
        // Décrémente
        final updated = CommandeItem(
          jouetId: item.jouetId,
          nomJouet: item.nomJouet,
          image: item.image,
          quantite: item.quantite - 1,
          prixUnitaire: item.prixUnitaire,
        );
        final newList = [...current]..[index] = updated;
        state = state.copyWith(items: newList);
      } else {
        // Si la quantité est 1 et qu'on appuie sur -, on retire l'article
        removeFromCart(jouetId);
      }
    }
  }

  void clear() => state = const PanierState();
}

final panierProvider = NotifierProvider<PanierNotifier, PanierState>(
  PanierNotifier.new,
);
