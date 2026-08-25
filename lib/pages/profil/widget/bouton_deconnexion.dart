import 'package:flutter/material.dart';

class BoutonDeconnexion extends StatelessWidget {
  final VoidCallback onPressed;

  const BoutonDeconnexion({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(
            color: Color(0xFFE67E22), // Contour orange
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Coins arrondis Figma
          ),
          elevation: 0,
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            // ICÔNE AVEC FLÈCHE TOURNÉE VERS LA GAUCHE
            Transform.flip(
              flipX: true,
              child: const Icon(
                Icons.logout_rounded,
                size: 24,
                color: Color(0xFFE67E22),
              ),
            ),
            const SizedBox(width: 12),
            // TEXTE ORANGE
            const Text(
              'Se déconnecter',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE67E22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}