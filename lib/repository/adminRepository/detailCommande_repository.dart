import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tolon/models/admin_model/commande_model.dart';

class DetailCommandeRepository {
  final FirebaseFirestore _firestore;

  DetailCommandeRepository(this._firestore);

  // Récupère les données d'une commande et les encapsule dans un CommandeModel sécurisé
  Future<CommandeModel?> getOrderDetails(String orderId) async {
    try {
      final orderDoc = await _firestore.collection('Commandes').doc(orderId).get();
      if (!orderDoc.exists || orderDoc.data() == null) return null;

      final orderData = orderDoc.data() as Map<String, dynamic>;
      String resolvedName = 'Parent Ankan Tolon';
      final dynamic parentParam = orderData['parent_id'];

      String cleanUserId = '';
      if (parentParam is DocumentReference) {
        cleanUserId = parentParam.id;
      } else if (parentParam is String && parentParam.isNotEmpty) {
        cleanUserId = parentParam.contains('/') ? parentParam.split('/').last : parentParam;
      }

      if (cleanUserId.isNotEmpty) {
        final parentDoc = await _firestore.collection('users').doc(cleanUserId).get();
        if (parentDoc.exists && parentDoc.data() != null) {
          final pData = parentDoc.data() as Map<String, dynamic>;
          resolvedName = pData['name'] ?? pData['nom'] ?? pData['displayName'] ?? resolvedName;
        } else {
          resolvedName = 'ID introuvable : ${cleanUserId.substring(0, cleanUserId.length > 6 ? 6 : cleanUserId.length)}...';
        }
      }

      // TRANSFERT VERS LE MODÈLE : On convertit la Map brute en CommandeModel typé
      return CommandeModel.fromFirestore(
        json: orderData,
        docId: orderId,
        resolvedParentName: resolvedName,
      );
    } catch (e) {
      return null;
    }
  }

  // Permet de modifier le statut de la commande en un clic
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore.collection('Commandes').doc(orderId).update({'status': status});
  }
}
