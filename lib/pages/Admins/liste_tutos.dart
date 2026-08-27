import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/commun_widget/admin_widgets/liste_card_tutos.dart';
import 'package:tolon/cor/app_colors.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/models/admin_model/tutoriel_model.dart';
import 'package:tolon/repository/adminRepository/tutoriel_repository.dart';

class ListeTutos extends ConsumerStatefulWidget {
  const ListeTutos({super.key});

  @override
  ConsumerState<ListeTutos> createState() => _ListeTutosState();
}

class _ListeTutosState extends ConsumerState<ListeTutos> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // On écoute ton provider de flux temps réel généré automatiquement par Riverpod
    final tutosAsync = ref.watch(watchTutorielsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            _buildActionBar(context),
            const SizedBox(height: 12),

            // TON COMPOSANT TABLEAU SURÉLEVÉ RÉUTILISABLE
            ListeCardTutos(
              headerRow: const Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Titre',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Date',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Age',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Actions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        fontFamily: 'Quicksand',
                      ),
                    ),
                  ),
                ],
              ),

              listView: tutosAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.greenPrimary,
                  ),
                ),
                error: (err, stack) => Center(
                  child: Text(
                    'Erreur : $err',
                    style: const TextStyle(fontFamily: 'Quicksand'),
                  ),
                ),
                data: (tutosList) {
                  // Filtrage dynamique local sur le titre saisi par l'admin
                  final filteredList = tutosList
                      .where(
                        (t) => t.titre.toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        ),
                      )
                      .toList();

                  if (filteredList.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aucun tutoriel disponible.',
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          color: AppColors.textGrey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final tuto = filteredList[index];
                      return _buildTutoRow(context, tuto);
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

  // EN-TÊTE : Titres textuels alignés avec l'image du Nounours de ta maquette
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
                'Liste des tutoriels',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Gérez tous les ajoutés',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 13,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),

          Image.asset(
            'assets/images/imageAjoutTuto.png',
            height: 100,
            width: 100,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.play_lesson_rounded,
                size: 55,
                color: AppColors.orangeSecondary,
              );
            },
          ),
        ],
      ),
    );
  }

  // BARRE D'ACTION : Recherche + Bouton d'ajout "Ajouter un tutoriel" orange
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
                  hintText: 'Rechercher une vidéo',
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),

            // GoRouter vers le formulaire d'ajout
            onPressed: () =>
                context.pushNamed(AppRoutes.adminajoututoriels.name),
            child: const Text(
              'Ajouter un tutoriel',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CHAQUE LIGNE DE TUTORIEL
  Widget _buildTutoRow(BuildContext context, TutorielModel tuto) {
    final dt = tuto.dateCreation;
    final String dateFormatted =
        '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // Miniature de la vidéo + Titre
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FBF9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFEEEEEE)),

                    // Si le lien de miniature Supabase existe, on l'affiche en fond !
                    image: tuto.imageVideoUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(tuto.imageVideoUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),

                  // Icône de lecture superposée en cas d'absence d'image
                  child: tuto.imageVideoUrl.isEmpty
                      ? const Icon(
                          Icons.play_circle_outline_rounded,
                          color: AppColors.greenPrimary,
                          size: 22,
                        )
                      : null,
                ),

                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tuto.titre,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      fontFamily: 'Quicksand',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),

          // Date de création
          Expanded(
            flex: 2,
            child: Text(
              dateFormatted,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 10),

          // Tranche d'âge
          Expanded(
            flex: 2,
            child: Text(
              '${tuto.ageMin}-${tuto.ageMax} ans',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8),

          // Bloc d'actions
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Action 1 : voir detail
                GestureDetector(
                  onTap: () {
                    // Logique d'ouverture de la vidéo
                  },
                  child: const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(width: 6),

                // Action 2 : Modifier
                GestureDetector(
                  onTap: () {
                    _showConfirmDialog(
                      context: context,
                      title: 'Modifier le tutoriel',
                      content:
                          'Voulez-vous ouvrir le formulaire pour modifier "${tuto.titre}" ?',
                      confirmLabel: 'Modifier',
                      confirmColor: AppColors.greenPrimary,
                      onConfirm: () {
                        context.pushNamed(
                          AppRoutes.adminajoututoriels.name,
                          extra: tuto,
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(width: 6),

                // Action 3 : Supprimer
                GestureDetector(
                  onTap: () {
                    _showConfirmDialog(
                      context: context,
                      title: 'Supprimer définitivement',
                      content:
                          'Êtes-vous sûr de vouloir supprimer "${tuto.titre}" ? Cette action est irréversible.',
                      confirmLabel: 'Supprimer',
                      confirmColor: Colors.redAccent,
                      onConfirm: () async {
                        await ref
                            .read(tutorielRepositoryProvider)
                            .supprimerTutoriel(tuto.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Tutoriel supprimé avec succès.',
                              ),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmLabel,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textDark,
            ),
          ),
          content: Text(
            content,
            style: const TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Annuler',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGrey,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue d'abord
                onConfirm(); // Exécute l'action de modification ou suppression
              },
              child: Text(
                confirmLabel,
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
