import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/cor/app_colors.dart';
import 'package:tolon/repository/adminRepository/jouet_plusAchete_repository.dart';

class JouetsPlusAchete extends ConsumerWidget {
  const JouetsPlusAchete({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topSalesAsync = ref.watch(topJouetsAchetesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            backgroundColor: AppColors.greenPrimary.withValues(alpha: 0.1),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.textDark),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Text(
          'Jouets les plus achetés',
          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: topSalesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.greenPrimary)),
        error: (err, stack) => Center(child: Text('Erreur d\'analyse : $err')),
                data: (topList) {
          if (topList.isEmpty) {
            return const Center(child: Text('Aucune commande enregistrée pour le moment.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: topList.length,
            // CONFIGURATION DE LA GRILLE À DEUX COLONNES
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,          // ──> 2 cartes par ligne
              crossAxisSpacing: 14,       // ──> Espace horizontal entre les cartes
              mainAxisSpacing: 14,        // ──> Espace vertical entre les lignes
              mainAxisExtent: 180,        // ──> Hauteur fixe totale de chaque carte
            ),
            itemBuilder: (context, index) {
              final item = topList[index];
              final int rang = index + 1;

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.30), 
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //L'IMAGE EN GRAND QUI REMPLIT TOUT LE HAUT DE LA CARDE
                    Expanded(
                      flex: 5, // Prend la majeure partie de la hauteur de la carte
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              // Arrondit uniquement les coins supérieurs de l'image
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: (item['image'] as String).isNotEmpty
                                  ? Image.network(
                                      item['image'],
                                      fit: BoxFit.cover, // Remplit tout le haut sans déformer
                                    )
                                  : Container(
                                      color: const Color(0xFFF9FBF9),
                                      child: const Icon(Icons.toys_outlined, color: Colors.grey, size: 40),
                                    ),
                            ),
                          ),
                          
                          // BADGE DE CLASSEMENT (Flottant par-dessus l'image en haut à gauche)
                          Positioned(
                            top: 10,
                            left: 10,
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: rang == 1 
                                  ? const Color(0xFFFFD700) // Or
                                  : rang == 2 
                                      ? const Color(0xFFC0C0C0) // Argent
                                      : AppColors.greenPrimary.withValues(alpha: 0.85),
                              child: Text(
                                '$rang',
                                style: const TextStyle(
                                  fontSize: 11, 
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // LES TEXTES ET INFOS JUSTE EN DESSOUS DE L'IMAGE
                    Expanded(
                      flex: 4, // Espace dédié aux textes en bas
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Titre du Jouet
                            Text(
                              item['nom'],
                              style: const TextStyle(
                                fontFamily: 'Quicksand', 
                                fontSize: 13, 
                                fontWeight: FontWeight.bold, 
                                color: AppColors.textDark,
                              ),
                              maxLines: 2, // Coupe proprement sur 2 lignes si le nom est long
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            // Statistiques de ventes
                            Text(
                              'Vendus : ${item['quantite']} exemplaires',
                              style: const TextStyle(
                                fontFamily: 'Quicksand', 
                                fontSize: 12, 
                                color: AppColors.greenPrimary, 
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },

      ),
    );
  }
}
