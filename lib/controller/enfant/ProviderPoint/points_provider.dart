import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class EnfantPointsNotifier extends StateNotifier<int> {
  // Valeur de départ par défaut en mémoire
  EnfantPointsNotifier() : super(0);

  // Méthode pour ajouter les étoiles gagnées aux points totaux
  void ajouterEtoiles(int etoilesGagnees) {
    state += etoilesGagnees;
  }
}

// Provider global pour le nombre de points
final enfantPointsProvider = StateNotifierProvider<EnfantPointsNotifier, int>((
  ref,
) {
  return EnfantPointsNotifier();
});
