// lib/pages/checkout/checkout_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controller/panier/panier_controller.dart';
import '../../repository/commande_repository/commande_repository.dart';
import '../../commun_widget/primary_button.dart';
import '../../cor/theme/app_theme.dart';
import '../../cor/utils/size_config.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});
  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _adresseController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitOrder() async {
    if (_adresseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer une adresse")),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final panier = ref.read(panierProvider);
    final repo = ref.read(commandeRepositoryProvider);

    try {
      await repo.createCommande(
        adresse: _adresseController.text,
        items: panier.items,
        montant: panier.total,
      );
      ref.read(panierProvider.notifier).clear();
      if (context.mounted) context.go('/success');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la commande")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final panier = ref.watch(panierProvider);

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: AppStyles.bgColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.getProportionateWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Mode de paiement", style: AppStyles.headingTextStyle),
            SizedBox(height: SizeConfig.getProportionateHeight(8)),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppStyles.navbarColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_shipping, color: AppStyles.primaryOrange),
                  SizedBox(width: SizeConfig.getProportionateWidth(10)),
                  const Text("Paiement à la livraison (Cash)"),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.getProportionateHeight(24)),
            const Text(
              "Adresse de livraison",
              style: AppStyles.headingTextStyle,
            ),
            SizedBox(height: SizeConfig.getProportionateHeight(8)),
            TextField(
              controller: _adresseController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Entrez l'adresse complète",
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: "Confirmer (Total: ${panier.total.toStringAsFixed(2)} €)",
              isLoading: _isSubmitting,
              onPressed: _submitOrder,
            ),
          ],
        ),
      ),
    );
  }
}
