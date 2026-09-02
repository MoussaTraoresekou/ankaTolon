import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/admin_model/tutoriel_model.dart';
import 'package:tolon/repository/adminRepository/tutoriel_repository.dart';
import 'package:go_router/go_router.dart';

class EspaceEnfantTutoScreen extends ConsumerStatefulWidget {
  const EspaceEnfantTutoScreen({super.key});

  @override
  ConsumerState<EspaceEnfantTutoScreen> createState() =>
      _EspaceEnfantTutoScreenState();
}

class _EspaceEnfantTutoScreenState
    extends ConsumerState<EspaceEnfantTutoScreen> {
  String _selectedCategory = 'Tous';
  final List<String> _categories = ['Tous', 'Dessins', 'Sciences', 'Cultures'];

  @override
  Widget build(BuildContext context) {
    final tutorielsAsync = ref.watch(watchTutorielsProvider);

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: context.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: context.textDark),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------- TITRE PRINCIPAL -----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Tutoriels',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: context.textDark,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ----------------- BARRE DE FILTRES -----------------
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ChoiceChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : context.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: context.primary,
                    backgroundColor: context.boxSurfaceLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? context.primary
                            : context.borderColor.withOpacity(0.5),
                      ),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedCategory = category);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // ----------------- FLUX FIREBASE EN TEMPS RÉEL -----------------
          Expanded(
            child: tutorielsAsync.when(
              data: (tutoriels) {
                final filteredList = tutoriels.where((tuto) {
                  if (_selectedCategory == 'Tous') return true;
                  return tuto.categorieId == _selectedCategory;
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucun tutoriel disponible.',
                      style: TextStyle(color: context.textMuted, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final tuto = filteredList[index];
                    return _TutorielItemCard(
                      tutoriel: tuto,
                      primaryGreen: context.primary,
                    );
                  },
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(color: context.primary),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'Erreur de chargement : $err',
                  style: TextStyle(color: context.textDark),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------- CARTE DU TUTORIEL ENRICHI -----------------
class _TutorielItemCard extends StatelessWidget {
  final TutorielModel tutoriel;
  final Color primaryGreen;

  const _TutorielItemCard({required this.tutoriel, required this.primaryGreen});

  void _navigateToDetail(BuildContext context) {
    context.pushNamed(AppRoutes.TutorielDetail.name, extra: tutoriel);
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = tutoriel.imageVideoUrl ?? '';
    final String categoryText =
        (tutoriel.categorieId != null && tutoriel.categorieId!.isNotEmpty)
        ? tutoriel.categorieId!
        : 'Général';
    final String descriptionText = tutoriel.description ?? '';
    final String ageText = (tutoriel.ageMin != null && tutoriel.ageMax != null)
        ? '${tutoriel.ageMin} - ${tutoriel.ageMax} ans'
        : 'Tous âges';

    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: context.boxSurfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: context.borderColor.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: context.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / Vignette à gauche
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 100,
                height: 100,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: context.primarySoft,
                          child: Icon(Icons.image, color: context.textMuted),
                        ),
                      )
                    : Container(
                        color: context.primarySoft,
                        child: Icon(Icons.image, color: context.textMuted),
                      ),
              ),
            ),
            const SizedBox(width: 12),

            // Section centrale : Titre, Description, Badges
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tutoriel.titre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (descriptionText.isNotEmpty)
                    Text(
                      descriptionText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.textMuted,
                        height: 1.2,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      // Badge Âge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: context.avatarOrangeBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.child_care,
                              size: 14,
                              color: context.primaryOrange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              ageText,
                              style: TextStyle(
                                fontSize: 11,
                                color: context.primaryOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Badge Catégorie
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: context.primarySoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          categoryText,
                          style: TextStyle(
                            fontSize: 11,
                            color: context.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bouton Play à droite
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 28.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
