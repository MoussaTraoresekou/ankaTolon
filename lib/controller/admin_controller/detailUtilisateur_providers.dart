

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/cor/router/routes.dart'; 
import 'package:tolon/models/admin_model/parent_avec_enfants.dart';
import 'package:tolon/repository/adminRepository/detailUtilisateur_repository.dart';

final userDetailRepositoryProvider = Provider<UserDetailRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return UserDetailRepository(firestore);
});

final userDetailProvider = FutureProvider.family<ParentAvecEnfants?, String>((ref, userId) {
  final repository = ref.watch(userDetailRepositoryProvider);
  return repository.getParentAvecEnfants(userId);
});
