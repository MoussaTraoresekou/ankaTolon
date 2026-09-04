import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class BoutonMesCommandes extends StatelessWidget {
  final VoidCallback onPressed;

  const BoutonMesCommandes({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: context.textInverse,
          side: BorderSide(color: context.borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Transform.flip(
              flipX: true,
              child: Icon(
                Icons.receipt_long,
                size: 24,
                color: context.primary,
              ),
            ),
            const SizedBox(width: 12),
            // TEXTE ORANGE
            Text(
              'Mes commandes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: context.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
