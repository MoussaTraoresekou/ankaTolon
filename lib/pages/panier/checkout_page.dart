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
  final _nomController = TextEditingController(text: "Adama Diarra");
  final _telController = TextEditingController(text: "+225 79 78 67 67");
  final _adresseController = TextEditingController(text: "Kalaban Coura - Rue 223");
  
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nomController.dispose();
    _telController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (_nomController.text.isEmpty || _adresseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir les informations obligatoires")),
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
      if (context.mounted) context.pushReplacement('/success');
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
    const fraisLivraison = 2000.0; // À adapter selon votre logique métier

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: const Text("Aperçu de commande"),
        backgroundColor: AppStyles.bgColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionateWidth(16),
          vertical: SizeConfig.getProportionateHeight(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Informations
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
<<<<<<< HEAD
                border: Border.all(color: AppStyles.primaryOrange.withValues(alpha: 0.2)),
=======
                border: Border.all(color: AppStyles.primaryOrange.withOpacity(0.2)),
>>>>>>> a6c71b2ac4deaa38b9b0d96fcc7f9186d61b0b78
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.person_outline, "Nom", _nomController),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.phone_outlined, "Téléphone", _telController),
                  const Divider(height: 24),
                  _buildInfoRow(Icons.location_on_outlined, "Lieu de livraison", _adresseController, showChevron: true),
                ],
              ),
            ),
            
            SizedBox(height: SizeConfig.getProportionateHeight(24)),

            // Section Articles
            const Text("Articles", style: AppStyles.headingTextStyle),
            SizedBox(height: SizeConfig.getProportionateHeight(12)),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: panier.items.length,
              itemBuilder: (context, index) {
                final item = panier.items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(item.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.nomJouet, style: AppStyles.titleTextStyle.copyWith(fontSize: 14)),
                            Text("x${item.quantite}", style: AppStyles.normalTextStyle.copyWith(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Text("${(item.prixUnitaire * item.quantite).toStringAsFixed(0)} FCFA", 
                        style: AppStyles.titleTextStyle.copyWith(fontSize: 14)),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: SizeConfig.getProportionateHeight(12)),

            // Section Totaux
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildTotalRow("Sous-total", panier.total),
                  const SizedBox(height: 8),
                  _buildTotalRow("Frais de livraison", fraisLivraison),
                  const Divider(height: 24),
                  _buildTotalRow("Total", panier.total + fraisLivraison, isBold: true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          label: "Valider",
          isLoading: _isSubmitting,
          onPressed: _submitOrder,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, TextEditingController controller, {bool showChevron = false}) {
    return Row(
      children: [
        Icon(icon, color: AppStyles.primaryOrange),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppStyles.normalTextStyle.copyWith(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: AppStyles.titleTextStyle.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
        if (showChevron) const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }

  Widget _buildTotalRow(String label, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isBold ? AppStyles.headingTextStyle : AppStyles.normalTextStyle),
        Text(
          "${value.toStringAsFixed(0)} FCFA",
          style: isBold 
            ? AppStyles.headingTextStyle.copyWith(color: AppStyles.primaryOrange) 
            : AppStyles.titleTextStyle,
        ),
      ],
    );
  }
}