import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/router/routes.dart';

import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/models/activites/activite_model.dart';
import 'package:tolon/models/categorie/categorie_model.dart';
import 'package:tolon/repository/activite_repository/activite_repository.dart';

class ActivitesPage extends ConsumerStatefulWidget {
  const ActivitesPage({super.key});

  @override
  ConsumerState<ActivitesPage> createState() =>
      _ActivitesScreenState();
}

class _ActivitesScreenState
    extends ConsumerState<ActivitesPage> {
  String? _categorieId;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final activitesAsync =
        ref.watch(watchActivitesProvider);

    final categoriesAsync =
        ref.watch(watchCategoriesProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.getProportionateWidth(16),
            SizeConfig.getProportionateHeight(20),
            SizeConfig.getProportionateWidth(16),
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Activités',
                      textAlign: TextAlign.center,
                      style: AppStyles.headingTextStyle.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppStyles.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              SizedBox(
                height:
                    SizeConfig.getProportionateHeight(20),
              ),

              Text(
                'Catégories',
                style: AppStyles.normalTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              categoriesAsync.when(
                loading: () => const SizedBox(
                  height: 45,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stackTrace) => const Text(
                  'Impossible de charger les catégories.',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                data: (categories) {
                  return _buildCategoryFilter(
                    categories,
                  );
                },
              ),

              const SizedBox(height: 20),

              Expanded(
                child: activitesAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stackTrace) => Center(
                    child: Text(
                      'Erreur : $error',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  data: (activites) {
                    final activitesFiltrees =
                        _filtrerActivites(activites);

                    if (activitesFiltrees.isEmpty) {
                      return const Center(
                        child: Text(
                          'Aucune activité disponible.',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemCount:
                          activitesFiltrees.length,
                      itemBuilder: (context, index) {
                        final activite =
                            activitesFiltrees[index];

                        return _ActiviteCard(
                          activite: activite,
                          onTap: () {
                            context.pushNamed(
                              AppRoutes.detailactive.name,
                              extra: activite,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ActiviteModel> _filtrerActivites(
    List<ActiviteModel> activites,
  ) {
    if (_categorieId == null) {
      return activites;
    }

    return activites.where((activite) {
      return activite.categorieId?.id ==
          _categorieId;
    }).toList();
  }

  Widget _buildCategoryFilter(
    List<CategorieModel> categories,
  ) {
    return SizedBox(
      height: 45,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _CategoryChip(
            label: 'Toutes',
            selected: _categorieId == null,
            onTap: () {
              setState(() {
                _categorieId = null;
              });
            },
          ),

          ...categories.map(
            (categorie) {
              return _CategoryChip(
                label: categorie.nom,
                selected:
                    _categorieId == categorie.id,
                onTap: () {
                  setState(() {
                    _categorieId = categorie.id;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppStyles.primaryOrange
              : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: selected
                ? AppStyles.primaryOrange
                : Colors.black12,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ActiviteCard extends StatelessWidget {
  const _ActiviteCard({
    required this.activite,
    required this.onTap,
  });

  final ActiviteModel activite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.04,
              ),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: activite.image != null &&
                        activite.image!.isNotEmpty
                    ? Image.network(
                        activite.image!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return _imagePlaceholder();
                        },
                      )
                    : _imagePlaceholder(),
              ),
            ),

            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      activite.titre,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style:  TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppStyles.textDark,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      activite.description,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style:  TextStyle(
                        fontSize: 12,
                        color: AppStyles.textDark,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: Colors.black45,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${activite.dureeMinutes} min',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          '${activite.ageMin}-${activite.ageMax} ans',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF1F1ED),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 45,
          color: Colors.black26,
        ),
      ),
    );
  }
}
