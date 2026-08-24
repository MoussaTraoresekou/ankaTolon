import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Instance globale de Firebase Firestore
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);



// Stream pour compter le nombre total d'utilisateurs (Excluant l'admin)
final totalUsersStreamProvider = StreamProvider<int>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('users')
      .where('type', isNotEqualTo: 'admin') 
      .snapshots()
      .map((snapshot) => snapshot.size);
});




// Compteur d'enfants (Correction de la structure de calcul)
final totalChildrenStreamProvider = StreamProvider<int>((ref) {
  final firestore = ref.watch(firestoreProvider);
  
  // collectionGroup('enfants') cherche TOUTES les sous-collections nommées 'enfants'
  return firestore
  .collectionGroup('enfants')
  .snapshots()
  .map((snapshot) =>snapshot.docs.length); // Retourne le nombre total d'enfants trouvés
 
});


// Stream corrigé pour compter le nombre total de commandes
final totalOrdersStreamProvider = StreamProvider<int>((ref) {
  final firestore = ref.watch(firestoreProvider);

  // collectionGroup permet de chercher toutes les sous-collections nommées 'commandes'
  return firestore
      .collection('commandes')
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
});


// Stream pour sommer le champ 'activite_realisees' de chaque document enfant
final totalActivitiesStreamProvider = StreamProvider<int>((ref) {
  final firestore = ref.watch(firestoreProvider);
  
  return firestore.collectionGroup('enfants').snapshots().map((snapshot) {
    int totalGlobal = 0;
    
    for (var doc in snapshot.docs) {
      final data = doc.data();
      // On récupère la valeur numérique du champ
      final dynamic rawValue = data['activites_realisees'];
      
      if (rawValue != null) {
        // Conversion sécurisée en int au cas où
        totalGlobal += int.tryParse(rawValue.toString()) ?? 0;
      }
    }
    return totalGlobal;
  });
});





// Liste des 5 dernières commandes (Sécurisée sans blocage lié au tri)
final lastOrdersStreamProvider = StreamProvider<QuerySnapshot>((ref) {
  final firestore = ref.watch(firestoreProvider);
  // On supprime temporairement le .orderBy pour contourner l'absence d'index ou de champ de date
  return firestore.collection('commandes').limit(5).snapshots().handleError((dynamic e) {
    // En cas d'erreur d'indexation, retourne un flux vide propre au lieu de bloquer l'UI
    return const Stream<QuerySnapshot>.empty();
  });
});

// Liste des 5 derniers utilisateurs inscrits (Sécurisée)
final lastUsersStreamProvider = StreamProvider<QuerySnapshot>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('users')
      //Filtrage : On ne récupère que les comptes de type 'parent'
      .where('type', isEqualTo: 'parent') 
      .limit(5)
      .snapshots();
});

