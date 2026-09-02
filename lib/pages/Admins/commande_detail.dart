import 'package:flutter/material.dart';
import 'package:tolon/cor/app_colors.dart';
import 'package:tolon/commun_widget/admin_widgets/card_detail_cmd.dart';
import 'package:tolon/commun_widget/admin_widgets/ligne_info_cmd.dart';
import 'package:tolon/commun_widget/admin_widgets/ligne_jouet_cmd.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/controller/admin_controller/detailCommande_providers.dart';

class CommandeDetail extends ConsumerWidget {
  final String orderId;

  const CommandeDetail({required this.orderId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On écoute le contrôleur (Provider) qui gère le cache et les états asynchrones
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            backgroundColor: AppColors.greenPrimary.withValues(alpha: 0.1),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 12,
                color: AppColors.textNoir,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Text(
          'Détails commande',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: orderAsync.when(
        // ÉTAT 1 : Chargement
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.greenPrimary),
        ),

        // ÉTAT 2 : Erreur technique
        error: (err, stack) => Center(
          child: Text(
            'Erreur de chargement : $err',
            style: const TextStyle(fontFamily: 'Quicksand'),
          ),
        ),

        // ÉTAT 3 : Données reçues avec succès (Utilisation du modèle typé)
        data: (orderData) {
          if (orderData == null) {
            return Center(
              child: Text(
                'Commande introuvable.\nID : $orderId',
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Quicksand'),
              ),
            );
          }

          // Formatage propre de la date lue du modèle
          final dt = orderData.dateCmd;
          final String dateFormatted =
              '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} - ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête : Badge ID et Badge Statut
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.greenPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '#${orderData.id.substring(0, orderData.id.length > 7 ? 7 : orderData.id.length).toUpperCase()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: (orderData.status.toLowerCase() == 'livree')
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        orderData.status.toLowerCase() == 'livree'
                            ? 'Livrée'
                            : 'En cours',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (orderData.status.toLowerCase() == 'livree')
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // BLOC 1 : Informations Générales
                CardDetailCmd(
                  context: context,
                  title: 'Informations générales',
                  icon: Icons.info_outline_rounded,
                  child: Column(
                    children: [
                      LigneInfoCmd(
                        icon: Icons.calendar_today_outlined,
                        label: 'Date commande',
                        value: dateFormatted,
                      ),
                      LigneInfoCmd(
                        icon: Icons.person_outline_rounded,
                        label: 'Parent',
                        value:
                            orderData.parentName, // Résolu en amont par le repo
                      ),
                      LigneInfoCmd(
                        icon: Icons.location_on_outlined,
                        label: 'Adresse',
                        value: orderData.adresse.length > 25
                            ? '${orderData.adresse.substring(0, 25)}...'
                            : orderData.adresse,
                      ),
                      LigneInfoCmd(
                        icon: Icons.access_time,
                        label: 'Status',
                        value: orderData.status.toLowerCase() == 'livree'
                            ? 'Livrée'
                            : 'En cours',
                        valueColor: (orderData.status.toLowerCase() == 'livree')
                            ? Colors.green
                            : Colors.orange,
                        iconColor: Colors.orange,
                      ),

                      LigneInfoCmd(
                        icon: Icons.functions_rounded,
                        label: 'Montant total',
                        value: '${orderData.montantTotal} F CFA',
                        isBold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // BLOC 2 : Jouets Commandés
                CardDetailCmd(
                  context: context,
                  title: 'Jouets commandés',
                  icon: null,
                  child: orderData.jouets.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'Aucun jouet dans cette commande',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontFamily: 'Quicksand',
                            ),
                          ),
                        )
                      : Column(
                          children: orderData.jouets.map((item) {
                            final Map<String, dynamic> toy = item;

                            return LigneJouetCmd(
                              title:
                                  toy['nom_jouet'] ??
                                  toy['name'] ??
                                  'Jouet Éveil',
                              quantity: toy['quantite'] ?? 1,
                              price: toy['prix_unitaire'] != null? "${toy['prix_unitaire']} F CFA" : "0 F CFA",
                              image: toy['image']?.toString() ?? '',

                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(height: 24),

                // BOUTON D'ACTION : Évolue dynamiquement selon l'état du modèle
                if (orderData.status.toLowerCase() != 'livree')
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.greenPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 20,
                      ),
                      label: const Text(
                        'Marquer comme livrée',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () async {
                        // Modification du statut sur Firestore via la couche Repository
                        await ref
                            .read(detailCommandeRepositoryProvider)
                            .updateOrderStatus(orderId, 'livree');

                        // Invalidation du cache de Riverpod pour rafraîchir instantanément l'UI
                        ref.invalidate(orderDetailProvider(orderId));

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Commande validée et marquée comme livrée !',
                              ),
                              backgroundColor: AppColors.greenPrimary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
