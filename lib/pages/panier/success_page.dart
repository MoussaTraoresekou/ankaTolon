import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../cor/theme/app_theme.dart';
import '../../cor/utils/size_config.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulation des données (à remplacer par les vraies données de commande si vous les passez en arguments)
    final dateEstimee = DateTime.now().add(const Duration(days: 1));
    final formattedDate = DateFormat('d MMMM, HH\'h\'').format(dateEstimee);

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateWidth(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.getProportionateHeight(40)),

              // Bouton retour
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => context.go('/home'),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.grey),
                ),
              ),

              SizedBox(height: SizeConfig.getProportionateHeight(60)),

              // Icône de succès
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7FB685).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Color(0xFF7FB685), size: 50),
                ),
              ),

              SizedBox(height: SizeConfig.getProportionateHeight(24)),

              // Titre
              const Center(
                child: Text(
                  "Votre commande a\nbien été enregistrée.",
                  textAlign: TextAlign.center,
                  style: AppStyles.headingTextStyle,
                ),
              ),

              SizedBox(height: SizeConfig.getProportionateHeight(40)),

              // Récapitulatif
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildSuccessRow("Lieu de livraison", "Kalaban Coura", isOrange: true),
                    const Divider(height: 24),
                    _buildSuccessRow("Date de livraison estimé", formattedDate),
                    const Divider(height: 24),
                    _buildSuccessRow("Montant à payer", "26 000 FCFA"),
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
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: SizeConfig.getProportionateHeight(16)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => context.go('/home'),
                  child: Text("Retour au catalogue", style: AppStyles.titleTextStyle.copyWith(color: Colors.white)),
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
          child: Text(label, style: AppStyles.normalTextStyle.copyWith(fontSize: 14, color: Colors.grey)),
        ),
        const SizedBox(width: 16),
        Text(
          value,
          style: AppStyles.titleTextStyle.copyWith(
            fontSize: 14,
            color: isOrange ? AppStyles.primaryOrange : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}