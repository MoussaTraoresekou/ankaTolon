import 'package:tolon/models/categorieAdmin/categorie_model.dart';
import 'package:tolon/repository/categorieAdminRepository/categorie_repository.dart';

class CategorieController {
  final CategorieRepository repository =
  CategorieRepository();

  // ajout
  Future<void> ajouterCategorie(String nom) async {
    Categorie categorie = Categorie(
      id: '',
      nom: nom,
    );

    await repository.ajouterCategorie(categorie);
  }

  // affichage
  Future<List<Categorie>> afficherCategories() async {
    return await repository.recupererCategories();
  }

  // modification
  Future<void> modifierCategorie(
      String id,
      String nouveauNom,
      ) async {
    Categorie categorie = Categorie(
      id: id,
      nom: nouveauNom,
    );

    await repository.modifierCategorie(
      categorie,
    );
  }

  // suppression
  Future<void> supprimerCategorie(
      String id,
      ) async {
    await repository.supprimerCategorie(id);
  }
}