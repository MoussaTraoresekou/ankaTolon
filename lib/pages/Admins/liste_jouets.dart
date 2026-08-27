import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/app_colors.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/repository/jouets_reposotory/jouet_repository.dart';
import 'package:tolon/commun_widget/admin_widgets/liste_card_tutos.dart';

class ListeJouets extends ConsumerStatefulWidget {
  const ListeJouets({super.key});

  @override
  ConsumerState<ListeJouets> createState() => _ListeJouetsState();
}

class _ListeJouetsState extends ConsumerState<ListeJouets> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // 💡 RECTIFICATION DU PROVIDER : On écoute la méthode watchJouets() à partir du dépôt Riverpod officiel
    final jouetsAsync = ref.watch(watchJouetsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            _buildActionBar(context),
            const SizedBox(height: 12),
            
            // Le tableau blanc surélevé réutilisable
            ListeCardTutos(
              headerRow: const Row(
                children: [
                  Expanded(flex: 3, child: Text('Catégorie', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Quicksand'))),
                  Expanded(flex: 2, child: Center(child: Text('Age', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Quicksand')))),
                  Expanded(flex: 2, child: Center(child: Text('Prix', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Quicksand')))),
                  Expanded(flex: 2, child: Center(child: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Quicksand')))),
                ],
              ),
              listView: jouetsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.greenPrimary)),
                error: (err, stack) => Center(child: Text('Erreur : $err', style: const TextStyle(fontFamily: 'Quicksand'))),
                data: (jouetsList) {
                  // Filtrage de recherche textuel local
                  final filteredList = jouetsList
                      .where((j) => j.nomJouet.toLowerCase().contains(searchQuery.toLowerCase()))
                      .toList();

                  if (filteredList.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aucun jouet trouvé.',
                        style: TextStyle(fontFamily: 'Quicksand', color: AppColors.textGrey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final jouet = filteredList[index];
                      return _buildJouetRow(context, jouet);
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

  // 🧸 EN-TÊTE : Image locale depuis vos assets sans planter
  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Liste des jouets',
                style: TextStyle(fontFamily: 'Quicksand', fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                'Gérez tous les ajoutés',
                style: TextStyle(fontFamily: 'Quicksand', fontSize: 13, color: AppColors.textGrey),
              ),
            ],
          ),
          
          // 💡 RECTIFICATION ASSET : Sécurisation de l'image locale avec un try/catch de conteneur
          Container(
            height: 150,
            width: 150,
            child: Image.asset(
              'assets/images/ajoutImageJouet.png', // ──> Assurez-vous que ce fichier existe bien dans votre dossier assets/images/
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Si l'image locale est introuvable ou mal déclarée dans pubspec, cette icône prend le relais sans faire planter l'application
                return const Icon(Icons.toys_rounded, size: 55, color: AppColors.orangeSecondary);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2ECE2)),
              ),
              child: TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: const InputDecoration(
                  icon: Icon(Icons.search, color: AppColors.textGrey, size: 20),
                  hintText: 'Rechercher un jouet',
                  hintStyle: TextStyle(fontFamily: 'Quicksand', fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orangeSecondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            onPressed: () => context.pushNamed(AppRoutes.addjouet.name),
            child: const Text('Ajouter', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildJouetRow(BuildContext context, dynamic jouet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          
          // 1. Image Miniature + Nom
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FBF9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                    image: jouet.image.isNotEmpty 
                        ? DecorationImage(image: NetworkImage(jouet.image.first), fit: BoxFit.cover) 
                        : null,
                  ),
                  child: jouet.image.isEmpty ? const Icon(Icons.toys_outlined, color: AppColors.textGrey) : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    jouet.nomJouet,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark, fontFamily: 'Quicksand'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          
          // 2. Tranche d'âge
          Expanded(
            flex: 2, 
            child: Center(
              child: Text(
                '${jouet.ageMin}-${jouet.ageMax} ans',
                style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          
          // 3. Prix
          Expanded(
            flex: 2, 
            child: Center(
              child: Text(
                '${jouet.prix.toInt()} F',
                style: const TextStyle(fontSize: 13, color: AppColors.textDark, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          
          // 4. Actions Crayon / Poubelle
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textDark),
                  onPressed: () => context.pushNamed(AppRoutes.addjouet.name, extra: jouet),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
                  onPressed: () async {
                    // Cible directement le bon fournisseur de dépôt généré
                    await ref.read(jouetRepositoryProvider).supprimerJouet(jouet.id);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}