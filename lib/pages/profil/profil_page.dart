import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/controller/profil/profil_controller.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/pages/profil/widget/bouton_deconnexion.dart';
import 'package:tolon/pages/profil/widget/enfant_profil_card.dart';
import 'package:tolon/pages/profil/widget/informations_personnelles.dart';
import 'package:tolon/pages/profil/widget/modifier_profil_button.dart';
import 'package:tolon/pages/profil/widget/profil_header.dart';
import 'package:tolon/repository/enfant/enfant_repository.dart';

class ProfilPage extends ConsumerStatefulWidget {
  const ProfilPage({super.key});

  @override
  ConsumerState<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends ConsumerState<ProfilPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profilControllerProvider.notifier).initialiserProfil();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profil = ref.watch(profilControllerProvider);
    final enfantsAsync = ref.watch(enfantsStreamProvider);

    return Scaffold(
      backgroundColor: AppStyles.bgColor, // Fond vert très clair / cassé
      body: SafeArea(
        child: profil.chargement
            ? Center(
                child: CircularProgressIndicator(
                  color: AppStyles.primaryOrange,
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // TITRE CENTRAL
                    Text(
                      'Mon profil',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppStyles.textDark,
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (profil.utilisateur != null)
                      ProfilHeader(utilisateur: profil.utilisateur!),

                    const SizedBox(height: 16),

                    ModifierProfilButton(utilisateur: profil.utilisateur),

                    const SizedBox(height: 20),

                    // BLOC INFORMATIONS PERSONNELLES
                    if (profil.utilisateur != null)
                      InformationsPersonnelles(
                        utilisateur: profil.utilisateur!,
                      ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppStyles.textInverse,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFCBE3CE),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mes enfants',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppStyles.textDark,
                            ),
                          ),
                          const SizedBox(height: 14),
                          enfantsAsync.when(
                            data: (enfants) {
                              if (enfants.isEmpty) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Aucun enfant enregistré',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                );
                              }
                              return Column(
                                children: enfants
                                    .map(
                                      (enfant) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: EnfantProfilCard(enfant: enfant),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                            loading: () => const Center(
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(
                                  color: AppStyles.primaryOrange,
                                ),
                              ),
                            ),
                            error: (err, stack) => Text(
                              'Erreur de chargement : $err',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    BoutonDeconnexion(
                      onPressed: () async {
                        await ref
                            .read(profilControllerProvider.notifier)
                            .deconnexion();
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
