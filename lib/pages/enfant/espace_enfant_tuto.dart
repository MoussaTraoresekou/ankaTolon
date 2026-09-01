import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/models/admin_model/tutoriel_model.dart';
import 'package:tolon/repository/adminRepository/tutoriel_repository.dart';

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

  static const Color primaryGreen = Color(0xFF388E52);
  static const Color bgLight = Color(0xFFF9FCF9);

  @override
  Widget build(BuildContext context) {
    final tutorielsAsync = ref.watch(watchTutorielsProvider);

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: bgLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------- TITRE PRINCIPAL -----------------
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Tutoriels',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: primaryGreen,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? primaryGreen : Colors.grey.shade300,
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
                  return const Center(
                    child: Text(
                      'Aucun tutoriel disponible.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
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
                      primaryGreen: primaryGreen,
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: primaryGreen),
              ),
              error: (err, stack) =>
                  Center(child: Text('Erreur de chargement : $err')),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------- CARTE DU TUTORIEL (SÉCURISÉE) -----------------
class _TutorielItemCard extends StatelessWidget {
  final TutorielModel tutoriel;
  final Color primaryGreen;

  const _TutorielItemCard({required this.tutoriel, required this.primaryGreen});

  @override
  Widget build(BuildContext context) {
    // Protection contre les valeurs nulles provenant de Firebase
    final String imageUrl = tutoriel.imageVideoUrl ?? '';
    final String categoryText =
        (tutoriel.categorieId != null && tutoriel.categorieId!.isNotEmpty)
        ? tutoriel.categorieId!
        : 'Dessins';

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryGreen.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        children: [
          // Image / Vignette à gauche
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 100,
                height: double.infinity,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
              ),
            ),
          ),

          // Titre et Badge de catégorie
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tutoriel.titre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4EC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      categoryText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bouton de lecture vert circulaire
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                // Insérer ici la logique de lecture vidéo
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
