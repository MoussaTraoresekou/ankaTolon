import 'package:flutter/material.dart';

import 'package:tolon/models/defis/defi_model.dart';
import 'package:tolon/models/categorieAdmin/categorie_model.dart';

import 'package:tolon/repository/categorieAdminRepository/categorie_repository.dart';
import 'package:tolon/repository/defis/defi_repository.dart';


class DefiController extends ChangeNotifier {

  // =====================================================
  // REPOSITORIES
  // =====================================================

  final DefiRepository repository =
  DefiRepository();

  final CategorieRepository categorieRepository =
  CategorieRepository();


  // =====================================================
  // LISTE DES DEFIS
  // =====================================================

  List<Defi> listeDefis = [];


  // =====================================================
  // LISTE DES CATEGORIES
  // =====================================================

  List<Categorie> categories = [];


  // =====================================================
  // CHARGEMENT
  // =====================================================

  bool isLoading = false;


  // =====================================================
  // ERREUR
  // =====================================================

  String? erreur;


  // =====================================================
  // CHARGER LES CATEGORIES
  // =====================================================

  Future<void> chargerCategories() async {

    try {

      isLoading = true;
      erreur = null;

      notifyListeners();

      categories =
      await categorieRepository
          .recupererCategories();

    } catch (e) {

      erreur = e.toString();

      print(
        "Erreur chargement catégories : $e",
      );

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }


  // =====================================================
  // AJOUTER UN DEFI
  // =====================================================

  Future<void> ajouterDefi(
      Defi defi) async {

    try {

      isLoading = true;
      erreur = null;

      notifyListeners();

      await repository.ajouterDefi(defi);

      listeDefis.add(defi);

    } catch (e) {

      erreur = e.toString();

      print(
        "Erreur ajout défi : $e",
      );

      // Important :
      // on relance l'erreur pour que la page
      // puisse l'afficher.
      rethrow;

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }


  // =====================================================
  // RECUPERER LES DEFIS
  // =====================================================

  Future<void> recupererDefis() async {

    try {

      isLoading = true;
      erreur = null;

      notifyListeners();

      listeDefis =
      await repository.recupererDefis();

    } catch (e) {

      erreur = e.toString();

      print(
        "Erreur récupération défis : $e",
      );

      rethrow;

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }


  // =====================================================
  // MODIFIER UN DEFI
  // =====================================================

  Future<void> modifierDefi(
      Defi defi) async {

    try {

      isLoading = true;
      erreur = null;

      notifyListeners();

      await repository.modifierDefi(defi);

      int index =
      listeDefis.indexWhere(
            (element) =>
        element.id == defi.id,
      );

      if (index != -1) {

        listeDefis[index] = defi;
      }

    } catch (e) {

      erreur = e.toString();

      print(
        "Erreur modification défi : $e",
      );

      rethrow;

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }


  // =====================================================
  // SUPPRIMER UN DEFI
  // =====================================================

  Future<void> supprimerDefi(
      String id) async {

    try {

      isLoading = true;
      erreur = null;

      notifyListeners();

      await repository.supprimerDefi(id);

      listeDefis.removeWhere(
            (defi) =>
        defi.id == id,
      );

    } catch (e) {

      erreur = e.toString();

      print(
        "Erreur suppression défi : $e",
      );

      rethrow;

    } finally {

      isLoading = false;

      notifyListeners();
    }
  }
}