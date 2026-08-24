import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/commun_widget/bottom_navigation_bar.dart';

import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';

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

    final enfantsAsync = ref.watch(enfantsProvider);

    final jouetsAsync = ref.watch(streamJouetLesplusNotesProvider);

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppStyles.primaryOrange,
          onRefresh: () async {
            ref.invalidate(enfantsProvider);
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

                  const TitreSection(title: 'Mes enfants'),

                  SizedBox(height: SizeConfig.getProportionateHeight(8)),

                  SectionEnfant(enfantsAsync: enfantsAsync),

                  SizedBox(height: SizeConfig.getProportionateHeight(24)),

                  const TitreSection(title: 'Jeux les plus notés'),

                  SizedBox(height: SizeConfig.getProportionateHeight(8)),

                  BoutiquejouetSection(jouetsAsync: jouetsAsync),

                  SizedBox(height: SizeConfig.getProportionateHeight(24)),

                  const TitreSection(title: 'Mes favoris'),

                  SizedBox(height: SizeConfig.getProportionateHeight(8)),

                  const SectionFavoris(),

                  SizedBox(height: SizeConfig.getProportionateHeight(24)),
                ],
              ),
            ),
          ),
        ),
      ),
      //bottomNavigationBar: const AppBottomNavigationBar(),
      //bottomNavigationBar: const Barrenavigation(),
    );
  }
}
