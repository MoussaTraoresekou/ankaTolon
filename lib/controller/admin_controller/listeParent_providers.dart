import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/cor/router/routes.dart'; // 
import 'package:tolon/models/auth/user_modal.dart';
import 'package:tolon/repository/adminRepository/listeParent_repository.dart';

// Injection du dépôt de la liste
final parentsListRepositoryProvider = Provider<ParentsListRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ParentsListRepository(firestore);
});

// Le StreamProvider qui va alimenter l'interface automatiquement à chaque modification Firestore
final parentsStreamProvider = StreamProvider<List<UserModel>>((ref) {
  final repository = ref.watch(parentsListRepositoryProvider);
  return repository.getParentsStream();
});
