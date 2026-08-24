import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tolon/models/jouets/jouet_models.dart';

class CatalogueController {
  final CollectionReference<JouetModel> _jouetCollection = FirebaseFirestore.instance
      .collection("jouets")
      .withConverter<JouetModel>(
    fromFirestore: (snapshot, _) => JouetModel.fromFirestoreToCatalogue(snapshot),
    toFirestore: (jouet, _) => jouet.toJson(),
  );

  Stream<List<JouetModel>> getJouets() {
    return _jouetCollection.snapshots().map((snapshot) {

      print("***********NOOB SAYBOT*****les donnees arrivent ils");

      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
