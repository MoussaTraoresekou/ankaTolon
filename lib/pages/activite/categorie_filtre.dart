import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/categorie/categorie_model.dart';
import 'package:tolon/pages/activite/categorie_btn_filtre.dart';

class CategorieFilter extends StatelessWidget {
  const CategorieFilter({
    super.key,
    required this.categoriesAsync,
    required this.categorieId,
    required this.onCategorieSelected,
  });

  final AsyncValue<List<CategorieModel>> categoriesAsync;
  final String? categorieId;
  final ValueChanged<String?> onCategorieSelected;

  @override
  Widget build(BuildContext context) {
    return categoriesAsync.when(
      loading: () => const SizedBox(
        height: 45,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Text(
        'Impossible de charger les catégories.',
        style: TextStyle(color: context.textMuted),
      ),
      data: (categories) {
        return SizedBox(
          height: 45,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CategoryChip(
                label: 'Toutes',
                selected: categorieId == null,
                onTap: () {
                  onCategorieSelected(null);
                },
              ),

              ...categories.map((categorie) {
                return CategoryChip(
                  label: categorie.nom,
                  selected: categorieId == categorie.id,
                  onTap: () {
                    onCategorieSelected(categorie.id);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
