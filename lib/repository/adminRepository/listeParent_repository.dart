import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tolon/models/auth/user_modal.dart'; 

class ParentsListRepository {
  final FirebaseFirestore _firestore;

  ParentsListRepository(this._firestore);

  //Écoute en temps réel de tous les utilisateurs de type 'parent'
  
  Stream<List<UserModel>> getParentsStream() {
    return _firestore
        .collection('users')
        .where('type', isEqualTo: 'parent')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return UserModel.fromJson(doc.data(), doc.id);
          }).toList();
        });
  }
}
