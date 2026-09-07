import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

extension AsyncValueUi on AsyncValue {
  void showErrorDialog(BuildContext context) {
    if (!isLoading && hasError) {
      if (ModalRoute.of(context)?.isCurrent == false) {
        return;
      }

      final message = _errorMessage(error);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          icon: Icon(Icons.error, color: context.badgeRed, size: 40),
          title: Text(
            message,
            textAlign: TextAlign.center,
            style: context.normalTextStyle.copyWith(
              color: context.badgeRed,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.badgeRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Fermer',
                    style: TextStyle(
                      color: context.textInverse,
                      fontFamily: 'Madimi One',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  void showSuccessDialog(
    BuildContext context,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false, // Oblige l'utilisateur à cliquer sur le bouton
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: context.bgColor,
        icon: Icon(
          Icons.check_circle_outline,
          color: context.primary,
          size: 54,
        ),
        title: Text(
          message,
          textAlign: TextAlign.center,
          style: context.normalTextStyle.copyWith(
            color: context.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le dialogue
                  onConfirm(); // Déclenche l'action de redirection
                },
                child: Text(
                  'Continuer',
                  style: TextStyle(
                    color: context.textInverse,
                    fontFamily: 'Madimi One',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _errorMessage(Object? error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'Aucun utilisateur trouvé avec cet email.';
        case 'wrong-password':
          return 'Mot de passe incorrect.';
        case 'email-already-in-use':
          return 'Cet email est déjà utilisé par un autre compte.';
        case 'invalid-email':
          return 'L’adresse email n’est pas valide.';
        case 'weak-password':
          return 'Le mot de passe choisi est trop faible.';
        case 'invalid-credential':
             return "mot de passe ou email incorrect!";
        default:
          return error.message ?? 'Une erreur d’authentification est survenue.';
      }
    }

    return error?.toString() ?? 'Une erreur inattendue est survenue.';
  }
}
