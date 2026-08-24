import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/commun_widget/bottom_navigation_bar.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:flutter/services.dart';

import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/cor/utils/mock_jouet.dart';

import 'package:tolon/controller/panier/panier_controller.dart';

import 'package:tolon/pages/parent/widget/barreNavigation.dart';
import 'package:tolon/pages/parent/widget/boutiqueJouet.dart';
import 'package:tolon/pages/parent/widget/entete.dart';
import 'package:tolon/pages/parent/widget/sectionEnfant.dart';
import 'package:tolon/pages/parent/widget/section_favorie.dart';
import 'package:tolon/pages/parent/widget/titreSection.dart';

import 'package:tolon/repository/enfant/enfant_repository.dart';
import 'package:tolon/repository/jouets_reposotory/jouet_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig.init(context);

    final enfantsAsync = ref.watch(enfantsStreamProvider);

    final jouetsAsync = ref.watch(streamJouetLesplusNotesProvider);

    return PopScope(
      canPop: false, // On intercepte le retour
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Affichage de la confirmation
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Quitter l'application ?"),
            content: const Text("Voulez-vous vraiment fermer AnkaTolon ?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Non"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Oui"),
              ),
            ],
          ),
        );

        if (shouldPop ?? false) {
          SystemNavigator.pop(); // Ferme l'application native
        }
      },
      child: Scaffold(
        backgroundColor: AppStyles.bgColor,
        body: SafeArea(
          child: RefreshIndicator(
            color: AppStyles.primaryOrange,
            onRefresh: () async {
              ref.invalidate(enfantsStreamProvider);
              ref.invalidate(streamJouetLesplusNotesProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateWidth(16),
                  vertical: SizeConfig.getProportionateHeight(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Entete(),

                    SizedBox(height: SizeConfig.getProportionateHeight(24)),

                   TitreSection(title: 'Mes enfants',onVoirTout:(){
                    context.pushNamed(AppRoutes.mesenfants.name);

                  },),

                    SizedBox(height: SizeConfig.getProportionateHeight(8)),

                  SectionEnfant(),

                    SizedBox(height: SizeConfig.getProportionateHeight(24)),

                    const TitreSection(title: 'Jeux les plus notés'),

                    SizedBox(height: SizeConfig.getProportionateHeight(8)),

                    BoutiquejouetSection(jouetsAsync: jouetsAsync),

                    SizedBox(height: SizeConfig.getProportionateHeight(24)),

                    const TitreSection(title: 'Mes favoris'),

                    SizedBox(height: SizeConfig.getProportionateHeight(8)),

                    const SectionFavoris(),

                    SizedBox(height: SizeConfig.getProportionateHeight(24)),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.primaryOrange,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        // On ajoute un jouet factice au panier
                        final jouet = MockData.createMockJouet();
                        ref.read(panierProvider.notifier).addToCart(jouet);

                        // Feedback visuel
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text(
                        //       "Jouet ajouté au panier (Simulation) !",
                        //     ),
                        //   ),
                        // );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text("Tester : Ajouter un jouet"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // bottomNavigationBar: const Barrenavigation(),
        bottomNavigationBar: const AppBottomNavigationBar(),
      ), // Votre Scaffold actuel
    );
  }
}
