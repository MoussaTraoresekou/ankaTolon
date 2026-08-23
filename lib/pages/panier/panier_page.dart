// lib/pages/panier/panier_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../controller/panier/panier_controller.dart';
import '../../commun_widget/primary_button.dart';
import '../../cor/theme/app_theme.dart';
import '../../cor/utils/size_config.dart';

class PanierPage extends ConsumerWidget {
  const PanierPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panier = ref.watch(panierProvider);

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      appBar: AppBar(
        title: const Text("Mon panier"),
        backgroundColor: AppStyles.bgColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // Retour fluide
        ),
      ),
      body: panier.items.isEmpty
          ? const Center(child: Text("Votre panier est vide"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(
                      SizeConfig.getProportionateWidth(16),
                    ),
                    itemCount: panier.items.length,
                    itemBuilder: (context, index) {
                      final item = panier.items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Image du produit
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: NetworkImage(item.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Détails du produit
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.nomJouet,
                                    style: AppStyles.titleTextStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "4-6 ans", // Statique pour l'exemple, à adapter
                                    style: AppStyles.normalTextStyle.copyWith(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${item.prixUnitaire.toStringAsFixed(0)} FCFA",
                                    style: AppStyles.headingTextStyle.copyWith(
                                      fontSize: 16,
                                      color: AppStyles.primaryOrange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Contrôle de la quantité (- 1 +)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 18),
                                    onPressed: () => ref
                                        .read(panierProvider.notifier)
                                        .decrementItem(item.jouetId),
                                  ),
                                  Text(
                                    "${item.quantite}",
                                    style: AppStyles.titleTextStyle,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18),
                                    onPressed: () => ref
                                        .read(panierProvider.notifier)
                                        .incrementItem(item.jouetId),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Sous-total et Bouton
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sous-total", style: AppStyles.titleTextStyle),
                          Text(
                            "${panier.total.toStringAsFixed(0)} FCFA",
                            style: AppStyles.headingTextStyle.copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: "Passer commande",
                        onPressed: () =>
                            context.push('/checkout'), // Push pour fluidité
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
