import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/router/routes.dart';
import '../../cor/app_colors.dart';

class UserRow extends StatelessWidget {
  final String id;
  final String initials;
  final String name;
  final String email;
  final String time;

  const UserRow({
    required this.id,
    required this.initials,
    required this.name,
    required this.email,
    required this.time,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          //Rond orange avec les initiales
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.orangeSecondary.withValues(alpha: 0.2),
            child: Text(
              initials,
              style: const TextStyle(fontSize: 20, color: AppColors.orangeSecondary, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          
          // Structure interne alignée horizontalement
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pousse l'heure tout à droite
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Partie Gauche : Bloc Nom + Email
                InkWell(
                  onTap: () {
                     //Navigation vers la page de détails avec l'ID du document Firestore
                     context.pushNamed(AppRoutes.adminutilisateurDetail.name, pathParameters: {'userId':id});
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name, 
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark), 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        email, 
                        style: const TextStyle(fontSize: 13, color: AppColors.textGrey), 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4), // Espace de sécurité
                
                // Partie Droite : L'heure calée à côté
                Text(
                  time, 
                  style: const TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
