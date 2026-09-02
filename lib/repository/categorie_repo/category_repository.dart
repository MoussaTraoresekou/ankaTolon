import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/models/categorie/categorie_model.dart';

class CategoryRepository {
    final FirebaseFirestore _firestore;
    CategoryRepository({required this._firestore});
    Future<void>ajouterCategorie(CategorieModel categorie) async{
        await _firestore.collection("categories").add(categorie.toJson());
    }
     Future<void>modifier(String id,CategorieModel categorie) async{
           await _firestore.collection("categories").doc(id).update(categorie.toJson());
     }
      Future<void>supprimer(String id) async{
          await _firestore.collection("categories").doc(id).delete();
      }
       Future<List<CategorieModel>>getCategories() async{
      final snapshot=await _firestore.collection("categories").get();
      return snapshot.docs.map((doc){
            return CategorieModel.fromJson(doc.data(),doc.id);
      }).toList();
  }
    Stream<List<CategorieModel>>getStreamCategories(){
      final snapshot= _firestore.collection("categories").snapshots();
      return snapshot.map((snapshot) {
        return snapshot.docs.map((doc) {
          return CategorieModel.fromJson(
            doc.data(),
            doc.id
          );
        }).toList();
      });
  }
  Stream<List<CategorieModel>> getCategoryByType(String type) {
  return _firestore
      .collection('categories')
      .where('type', isEqualTo: type)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return CategorieModel.fromJson(
        doc.data(),
        doc.id,
      );
    }).toList();
  });
}
}
final CategoryRepositoryProvider=Provider((Ref ref){

  return CategoryRepository(firestore: FirebaseFirestore.instance);
});

final listeCategoryByTypeProvider =
    StreamProvider.family<List<CategorieModel>, String>((ref, type) {
  return ref
      .read(CategoryRepositoryProvider)
      .getCategoryByType(type);
});