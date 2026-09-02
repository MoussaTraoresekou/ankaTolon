import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/models/admin_model/commande_model.dart';
import 'package:tolon/repository/adminRepository/detailCommande_repository.dart';


// Votre provider de dépôt actuel
final detailCommandeRepositoryProvider = Provider<DetailCommandeRepository>((ref) {
  final firestore = ref.watch(firestoreProvider); // Votre provider firestore existant
  return DetailCommandeRepository(firestore);
});

// 💡 CORRECTION DU TYPE : Changez <Map<String, dynamic>?, String> par <CommandeModel?, String>
final orderDetailProvider = FutureProvider.family<CommandeModel?, String>((ref, orderId) {
  final repository = ref.watch(detailCommandeRepositoryProvider);
  
  // Désormais, cette ligne renvoie un Future<CommandeModel?> et le rouge disparaît !
  return repository.getOrderDetails(orderId); 
});
