import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/app_colors.dart';
import 'package:tolon/models/admin_model/commande_model.dart';
import 'package:tolon/cor/router/routes.dart';

class CardCommandeListe extends StatelessWidget {
  final CommandeModel order;

  const CardCommandeListe({required this.order, super.key});

  @override
  Widget build(BuildContext context) {
    final String status = order.status.toLowerCase().trim();
    
    //Détermination de la couleur exacte du statut selon votre maquette
    Color statusColor = Colors.orange;
    String statusText = 'En cours';

    if (status == 'livree' || status == 'confimée' || status == 'confirmée') {
      statusColor = Colors.green;
      statusText = 'Livrée';
    } else if (status == 'en preparation' || status == 'en cours') {
      statusColor = Colors.orange;
      statusText = 'En cours';
    } else if (status == 'livrer') {
      statusColor = const Color(0xFF81C784); // Vert plus clair de l'image
      statusText = 'Livrer';
    }

    // Formatage de la date (Exemple: 12 Aout 2026)
    final dt = order.dateCmd;
    final List<String> mois = ['Janv', 'Févr', 'Mars', 'Avril', 'Mai', 'Juin', 'Juil', 'Aout', 'Sept', 'Oct', 'Nov', 'Déc'];
    final String dateStr = '${dt.day} ${mois[dt.month - 1]} ${dt.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.40),
            blurRadius: 4,
            //spreadRadius: 2,
            //offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            AppRoutes.admincommandeDetail.name,
            pathParameters: {'orderId': order.id},
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Miniature de l'image du jouet (ou icône par défaut)
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FBF9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                ),
                child: const Icon(Icons.toys_outlined, color: AppColors.textGrey, size: 30),
              ),
              const SizedBox(width: 16),
              
              // Centre : Détails informatifs
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CMD-${order.id.substring(0, order.id.length > 8 ? 8 : order.id.length).toUpperCase()}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    Text(
                      '${order.montantTotal} FCFA',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      statusText,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: statusColor),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      dateStr,
                      style: const TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              
              // Droite : Petite flèche de navigation
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textDark),
            ],
          ),
        ),
      ),
    );
  }
}
