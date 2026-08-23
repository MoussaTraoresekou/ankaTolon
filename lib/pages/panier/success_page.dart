import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../cor/theme/app_theme.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 16),
            const Text(
              "Commande confirmée !",
              style: AppStyles.headingTextStyle,
            ),
            SizedBox(height: 8),
            const Text("Vous paierez à la livraison."),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryOrange,
                foregroundColor: Colors.white,
              ),
              onPressed: () => context.go('/home'), // Retour à l'accueil
              child: const Text("Retour à l'accueil"),
            ),
          ],
        ),
      ),
    );
  }
}
