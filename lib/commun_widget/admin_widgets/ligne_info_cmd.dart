import 'package:flutter/material.dart';
import 'package:tolon/cor/app_colors.dart';

class LigneInfoCmd extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;
  final Color? iconColor;

  const LigneInfoCmd({
    required this.icon,
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor ?? Color(0xFF34713A),
          ),
          const SizedBox(width: 10),

          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textNoir,
              //fontWeight: FontWeight.w500,
            ),
          ),
         // const Spacer(),

         const SizedBox(width: 20),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 14,
                //fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: valueColor ?? AppColors.textNoir,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
