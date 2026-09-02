import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class BoutonDeconnexion extends StatelessWidget {
  final VoidCallback onPressed;

  const BoutonDeconnexion({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: context.textInverse,
          side: BorderSide(color: context.primaryOrange, width: 1.5),
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
                Icons.logout_rounded,
                size: 24,
                color: context.primaryOrange,
              ),
            ),
            const SizedBox(width: 12),
            // TEXTE ORANGE
            Text(
              'Se déconnecter',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.primaryOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
