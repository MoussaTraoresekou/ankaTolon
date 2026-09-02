import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/cor/router/routes.dart'; 
import 'package:tolon/models/admin_model/commande_model.dart';
import 'package:tolon/repository/adminRepository/listeCommande_repository.dart';

// Injection du dépôt de la liste de commandes
final commandListRepositoryProvider = Provider<CommandeListRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return CommandeListRepository(firestore);
});

// Le StreamProvider qui alimente la vue en temps réel
final ordersStreamProvider = StreamProvider<List<CommandeModel>>((ref) {
  final repository = ref.watch(commandListRepositoryProvider);
  return repository.getOrdersStream();
});
