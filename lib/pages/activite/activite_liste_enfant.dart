import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/models/activites/activite_model.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';
import 'package:tolon/pages/activite/activite_card.dart';
import 'package:tolon/pages/activite/categorie_filtre.dart';
import 'package:tolon/repository/activite_repository/activite_repository.dart';
import 'package:tolon/repository/categorie_repo/category_repository.dart';

class ActivitesPage extends ConsumerStatefulWidget {
  final EnfantModel enfant;

  const ActivitesPage({super.key, required this.enfant});

  @override
  ConsumerState<ActivitesPage> createState() => _ActivitesPageState();
}

class _ActivitesPageState extends ConsumerState<ActivitesPage> {
  String? _categorieId;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // Calcul de l'âge de l'enfant
    final age = _calculerAge(widget.enfant.naissance);

    // Récupération des activités correspondant à l'âge
    final activitesAsync = ref.watch(activitesParAgeStreamProvider(age));

    // Récupération des catégories
    final categoriesAsync = ref.watch(listeCategoryByTypeProvider('activite'));

    return Scaffold(
      backgroundColor: context.bgColor,
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
              _buildHeader(context),

              const SizedBox(height: 20),

              Text(
                'Catégories',
                style: context.normalTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textDark,
                ),
              ),

              const SizedBox(height: 10),

              CategorieFilter(
                categoriesAsync: categoriesAsync,
                categorieId: _categorieId,
                onCategorieSelected: (id) {
                  setState(() {
                    _categorieId = id;
                  });
                },
              ),

              const SizedBox(height: 20),

              Expanded(
                child: activitesAsync.when(
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

                  data: (activites) {
                    // Filtrer les activités selon la catégorie sélectionnée
                    final activitesFiltrees = _filtrerActivites(activites);

                    // Aucune activité
                    if (activitesFiltrees.isEmpty) {
                      return Center(
                        child: Text(
                          'Aucune activité disponible.',
                          style: TextStyle(
                            color: context.textMuted,
                            fontSize: 15,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),

                      // Une activité après l'autre
                      itemCount: activitesFiltrees.length,

                      itemBuilder: (context, index) {
                        final activite = activitesFiltrees[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: ActiviteCard(
                            activite: activite,

                            // Navigation vers le détail
                            onTap: () {
                              context.pushNamed(
                                AppRoutes.detailactive.name,
                                extra: {
                                  'activite': activite,
                                  'enfant': widget.enfant,
                                },
                              );
                            },
                          ),
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios, size: 20, color: context.textDark),
        ),

        Expanded(
          child: Text(
            'Activités',
            textAlign: TextAlign.center,
            style: context.headingTextStyle.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: context.textDark,
            ),
          ),
        ),

        // Permet de garder le titre centré
        const SizedBox(width: 48),
      ],
    );
  }

  int _calculerAge(DateTime naissance) {
    final maintenant = DateTime.now();

    int age = maintenant.year - naissance.year;

    if (maintenant.month < naissance.month ||
        (maintenant.month == naissance.month &&
            maintenant.day < naissance.day)) {
      age--;
    }

    return age < 0 ? 0 : age;
  }

  List<ActiviteModel> _filtrerActivites(List<ActiviteModel> activites) {
    // Aucune catégorie sélectionnée
    // => afficher toutes les activités
    if (_categorieId == null) {
      return activites;
    }

    // Sinon, afficher uniquement les activités
    // appartenant à la catégorie sélectionnée
    return activites.where((activite) {
      return activite.categorieId?.id == _categorieId;
    }).toList();
  }
}
