import 'package:flutter/material.dart';
import 'package:tolon/cor/app_colors.dart';

class ListeCardTutos extends StatelessWidget {
  final Widget headerRow;
  final Widget listView;

  const ListeCardTutos({
    required this.headerRow,
    required this.listView,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.greenPrimary.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            // L'en-tête verte personnalisée
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF81C784),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              child: headerRow,
            ),
            // Le corps de la liste
            Expanded(child: listView),
          ],
        ),
      ),
    );
  }
}
