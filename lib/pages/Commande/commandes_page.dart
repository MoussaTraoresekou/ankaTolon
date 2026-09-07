import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tolon/commun_widget/admin_widgets/card_commande_liste.dart';

import 'package:tolon/controller/commande/commande_controller.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/commande/command_model.dart';
import 'package:tolon/pages/Commande/widgets/commandes_card.dart';
import 'package:tolon/repository/commande_repository/commande_repository.dart';

class CommandesPage extends ConsumerWidget {
  const CommandesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commandes = ref.watch(listeCommandeProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            const SizedBox(height: 72),

              Expanded(
                child: commandes.when(
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },

                  error: (error, stackTrace) {
                    return Center(
                      child: Text(
                        'Erreur : $error',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: context.textDark),
                      ),
                    );
                  },

                  data: (commandees) {

                    return !commandes.hasValue
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      itemCount: commandes.value?.length,
                      itemBuilder: (context, index) {
                        return CommandeCard(
                          commande: commandes.value!.elementAt(index),
                        );
                      },
                    );

                  
                  },
                ),
              ),
              
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 20,
        top: 20,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFE1F0E4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(width: 12),

          const Text(
            'Mes commandes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'Aucune commande pour le moment',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}