import 'package:tolon/models/auth/user_modal.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';

class ParentAvecEnfants {
  final UserModel user;
  final List<EnfantModel> enfants;

  ParentAvecEnfants({required this.user, required this.enfants});
}
