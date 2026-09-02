import 'package:flutter/material.dart';
import 'package:tolon/cor/app_colors.dart';

class LigneJouetCmd extends StatelessWidget {
  final String title;
  final int quantity;
  final String price;

  const LigneJouetCmd({
    required this.title,
    required this.quantity,
    required this.price,
    super.key, required String image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBF9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: const Icon(
              Icons.toys_outlined,
              color: AppColors.textGrey,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantité : $quantity',
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
                const SizedBox(height: 2),
                Text(
                  'Prix unitaire : $price',
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
