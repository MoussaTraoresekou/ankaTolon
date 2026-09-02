import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tolon/models/categorieAdmin/categorie_model.dart';

class CategorieRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ajout des categories
  Future<void> ajouterCategorie(Categorie categorie) async {
    await firestore
        .collection('categories')
        .add(categorie.toMap());
  }

  // affichage des categories
  Future<List<Categorie>> recupererCategories() async {
    QuerySnapshot snapshot =
    await firestore.collection('categories').get();

    return snapshot.docs.map((doc) {
      return Categorie.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  // modification des categories
  Future<void> modifierCategorie(Categorie categorie) async {
    await firestore
        .collection('categories')
        .doc(categorie.id)
        .update(categorie.toMap());
  }

  // suppresion des categories
  Future<void> supprimerCategorie(String id) async {
    await firestore
        .collection('categories')
        .doc(id)
        .delete();
  }
}