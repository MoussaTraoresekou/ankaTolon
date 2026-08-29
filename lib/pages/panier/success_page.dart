import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../cor/theme/app_theme.dart';
import '../../cor/utils/size_config.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    // données transmises par le router
    final Map<String, dynamic>? args =
        GoRouterState.of(context).extra as Map<String, dynamic>?;

    final String adresse = args?['adresse'] ?? 'Adresse non spécifiée';
    final double montant = args?['montant'] ?? 0.0;
    final String montantFormatted = "${montant.toStringAsFixed(0)} FCFA";

    final dateEstimee = DateTime.now().add(const Duration(days: 1));
    final formattedDate = DateFormat('d MMMM, HH\'h\'').format(dateEstimee);

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),

              // Bouton retour
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => context.go('/home'),
                  child: Icon(Icons.arrow_back_ios_new, color: Colors.grey),
                ),
              ),

              SizedBox(height: 60),

              // Icône de succès
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7FB685).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Color(0xFF7FB685), size: 50),
                ),
              ),

              SizedBox(height: 24),

              // Titre
              Center(
                child: Text(
                  "Votre commande a\nbien été enregistrée.",
                  textAlign: TextAlign.center,
                  style: AppStyles.headingTextStyle,
                ),
              ),

              SizedBox(height: 40),

              // Récapitulatif
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppStyles.textInverse,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildSuccessRow(
                      "Lieu de livraison",
                      adresse,
                      isOrange: true,
                    ),
                    const Divider(height: 24),
                    _buildSuccessRow(
                      "Date de livraison estimée",
                      formattedDate,
                    ),
                    const Divider(height: 24),
                    _buildSuccessRow("Montant à payer", montantFormatted),
                  ],
                ),
              ),

              const Spacer(),

              // Bouton Retour
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyles.primaryOrange,
                    foregroundColor: AppStyles.textInverse,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => context.go('/home'),
                  child: Text(
                    "Retour au catalogue",
                    style: AppStyles.titleTextStyle.copyWith(
                      color: AppStyles.textInverse,
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.getProportionateHeight(24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessRow(String label, String value, {bool isOrange = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.normalTextStyle.copyWith(
              fontSize: 14,
              color: AppStyles.textMuted,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.titleTextStyle.copyWith(
              fontSize: 14,
              color: isOrange ? AppStyles.primaryOrange : AppStyles.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
