import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 
import '../../cor/app_colors.dart';

class SectionContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionContainer({
    required this.title, 
    required this.child, 
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.orangeSecondary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title, 
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
              ),
              
              //  "Voir tout" cliquable avec InkWell
              InkWell(
                onTap: () {
                  // Détecte automatiquement sur quel bloc on clique pour ouvrir la bonne page
                  if (title == 'Dernières commandes') {
                    // Ouvre la liste complète des commandes
                   // context.push('/adminDashboard/all-orders'); 
                  } else if (title == 'Nouveaux utilisateurs') {
                    // Ouvre la liste complète des utilisateurs
                   // context.push('/adminDashboard/all-users');
                  }
                },
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                  child: Row(
                    children: const [
                      Text(
                        'Voir tout', 
                        style: TextStyle(fontSize: 12, color: AppColors.greenPrimary, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_ios_rounded, 
                        size: 12, 
                        color: AppColors.greenPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          child,
        ],
      ),
    );
  }
}
