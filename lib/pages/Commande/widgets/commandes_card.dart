import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tolon/models/commande/command_model.dart';

class CommandeCard extends StatelessWidget {
  final Commande commande;

  const CommandeCard({
    required this.commande,
  });

  @override
  Widget build(BuildContext context) {
    final premierJouet =
        commande.jouets.isNotEmpty ? commande.jouets.first : null;

    final date = DateFormat(
      'dd MMM yyyy',
      'fr_FR',
    ).format(commande.dateCmd);

    return Container(
      height: 118,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD0D0D0),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x25000000),
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // IMAGE DU JOUET
          SizedBox(
            width: 58,
            height: 75,
            child: premierJouet != null &&
                    premierJouet.image.isNotEmpty
                ? Image.network(
                    premierJouet.image,
                    fit: BoxFit.contain,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return const Icon(
                        Icons.image_outlined,
                        size: 40,
                        color: Colors.grey,
                      );
                    },
                  )
                : const Icon(
                    Icons.shopping_bag_outlined,
                    size: 40,
                    color: Colors.grey,
                  ),
          ),

          const SizedBox(width: 13),

          // INFORMATIONS
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _numeroCommande(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${_formatMontant(commande.montant)} FCFA',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // CHEVRON
          const Icon(
            Icons.chevron_right,
            size: 27,
            color: Colors.black,
          ),

          const SizedBox(width: 2),
        ],
      ),
    );
  }

  String _numeroCommande() {
    if (commande.id == null || commande.id!.isEmpty) {
      return 'CMD-';
    }

    return commande.id!.startsWith('CMD-')
        ? commande.id!
        : 'CMD-${commande.id}';
  }

  String _formatMontant(double montant) {
    return NumberFormat(
      '#,###',
      'fr_FR',
    ).format(montant).replaceAll('\u00A0', ' ');
  }
}