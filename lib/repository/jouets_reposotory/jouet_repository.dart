import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/models/jouets/jouet_models.dart';

part 'jouet_repository.g.dart';

class JouetRepository {
  final FirebaseFirestore firestore;

  JouetRepository(this.firestore);

  CollectionReference<Map<String, dynamic>> get jouetsCollection =>firestore.collection('jouets');
  Future<List<JouetModel>> getJouets() async {
    final snapshot = await jouetsCollection.get();

    return snapshot.docs.map((doc) {
      return JouetModel.fromJson(doc.data(), doc.id);
    }).toList();
  }

  Future<JouetModel?> getJouetById(String id) async {
    final doc = await jouetsCollection.doc(id).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return JouetModel.fromJson(doc.data()!, doc.id);
  }

  Future<void> ajouterJouet({
    required JouetModel jouet,
    required List<dynamic> images,
  }) async {
    // Ta logique d'upload Supabase doit être ici
  }

  Future<void> modifierJouet({required JouetModel jouet}) async {
    await jouetsCollection.doc(jouet.id).update(jouet.toJson());
  }

  Future<void> supprimerJouet(String id) async {
    await jouetsCollection.doc(id).delete();
  }

  Stream<List<JouetModel>> watchJouets() {
    return jouetsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return JouetModel.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }
  Stream<List<JouetModel>> streamJouetLesplusNotes() {
    return jouetsCollection.orderBy("note_moyen",descending:true)
        .snapshots().map((snapshot){
          return snapshot.docs.map((doc) {
        return JouetModel.fromJson(doc.data(), doc.id);
           }).toList();

        });
          
      }
}




@riverpod
JouetRepository jouetRepository(Ref ref) {
  return JouetRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<JouetModel>> watchJouets(Ref ref) {
  final repository = ref.watch(jouetRepositoryProvider);

  return repository.watchJouets();
}
@riverpod
Stream<List<JouetModel>> streamJouetLesplusNotes(Ref ref){
   final repository=ref.watch(jouetRepositoryProvider);
   return repository.streamJouetLesplusNotes();
}
          
  
