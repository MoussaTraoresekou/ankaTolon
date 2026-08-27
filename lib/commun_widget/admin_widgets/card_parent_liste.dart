import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/app_colors.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/models/auth/user_modal.dart';

class ParentCard extends StatelessWidget {
  final UserModel parent;

  const ParentCard({required this.parent, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.textGrey.withValues(alpha: 1.0),
            blurRadius: 2,
            //spreadRadius: 1,
            //offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar de profil (générique ou personnalisé)
          CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.greenPrimary.withValues(alpha: 0.1),
            child: const Icon(Icons.account_circle_outlined, size: 45, color: AppColors.greenPrimary),
          ),
          const SizedBox(width: 16),
          
          // Détails textuels du parent
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${parent.prenom} ${parent.nom}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    // BOUTON CLICABLE "Voir profil" connecté à ton GoRouter
                    InkWell(
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.adminutilisateurDetail.name,
                          pathParameters: {'userId': parent.uid},
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.greenPrimary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Voir profil',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.greenPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(parent.phoneNumber, style: const TextStyle(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.mail_outline_rounded, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        parent.email, 
                        style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
