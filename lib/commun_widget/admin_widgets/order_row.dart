import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 💡 1. Import indispensable pour la navigation
import 'package:tolon/cor/router/routes.dart';
import '../../cor/app_colors.dart';

class OrderRow extends StatelessWidget {
  final String id;
  final String name;
  final String date;
  final String price;
  final String status;
  final Color statusColor;
  final String? avatarUrl;

  const OrderRow({
    required this.id,
    required this.name,
    required this.date,
    required this.price,
    required this.status,
    required this.statusColor,
    this.avatarUrl,
    super.key,
  }) ;

   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Avatar de l'utilisateur à gauche
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.greenPrimary.withValues(alpha: 0.2),
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null 
                ? const Icon(Icons.person, size: 40, color: AppColors.greenPrimary) 
                : null,
          ),
          const SizedBox(width: 8),
          
          // Zone de texte centrale (ID, Nom, Date, Prix)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(id, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.orangeSecondary)),
                Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('$date - $price', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ),
          const SizedBox(width: 0),
          
          // Le Badge de statut
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          //   decoration: BoxDecoration(
          //     color: statusColor.withValues(alpha: 0.15),
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: Text(
          //     status,
          //     style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
          //   ),
          // ),
          // const SizedBox(width: 4),

          // AJOUT : La petite icône flèche cliquable tout à la fin
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 4.0,  bottom: 30.0),
            child: InkWell(
              onTap: () {
                context.pushNamed(AppRoutes.commandeDetail.name, pathParameters: {'orderId': id});
              },
              child: const Padding(
                padding: EdgeInsets.all(4.0), // Agrandit la zone cliquable pour le doigt
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15, 
                  color: AppColors.greenPrimary, 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
