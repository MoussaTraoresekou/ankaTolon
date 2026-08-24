import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/router/routes.dart';

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

    final enfantsAsync = ref.watch(enfantsStreamProvider);

    final jouetsAsync = ref.watch(streamJouetLesplusNotesProvider);

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppStyles.primaryOrange,
          onRefresh: () async {
            ref.invalidate(enfantsStreamProvider);
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

                   TitreSection(title: 'Mes enfants',onVoirTout:(){
                    context.pushNamed(AppRoutes.mesenfants.name);

                  },),

                  SizedBox(height: SizeConfig.getProportionateHeight(8)),

                  SectionEnfant(),

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
      bottomNavigationBar: const Barrenavigation(),
    );
  }
<<<<<<< HEAD
}
=======

  // ============================================
  // HEADER
  // ============================================
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/placeholder.jpg'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour Hamidou ! 👋',
                  style: AppStyles.titleTextStyle
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Heureux de vous retrouver',
                  style: TextStyle(color: Colors.black45, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, size: 28),
              onPressed: () {},
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '10',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================
  // TITRE DE SECTION
  // ============================================
  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyles.titleTextStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Voir tout',
            style: TextStyle(color: Color(0xFF6FB565)),
          ),
        ),
      ],
    );
  }

  // ============================================
  // SECTION ENFANTS
  // ============================================
  Widget _buildChildrenSection() {
    return SizedBox(
      height: SizeConfig.getProportionateHeight(75),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildChildCard('Adama', '10 ans', const Color(0xFFE8F5E9)),
          _buildChildCard('Aïcha', '8 ans', const Color(0xFFFFF3E0)),
          GestureDetector(
  onTap: () => context.goNamed(AppRoutes.addEnfant.name),
  child: Container(
    width: SizeConfig.getProportionateWidth(100),
    margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black12, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_circle_outline, color: Colors.green, size: 26),
        SizedBox(height: 4),
        Text('Ajouter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    ),
  ),
),
        ],
      ),
    );
  }

  Widget _buildChildCard(String name, String age, Color bgColor) {
    return Container(
      width: SizeConfig.getProportionateWidth(140),
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppStyles.normalTextStyle
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                age,
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================
  // SECTION JEUX
  // ============================================
  Widget _buildGamesSection() {
    return SizedBox(
      height: SizeConfig.getProportionateHeight(150),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildItemCard('Puzzle pour enfants', '4.8', null),
          _buildItemCard('Association des lettres', '4.8', null),
        ],
      ),
    );
  }

  // ============================================
  // SECTION BOUTIQUE
  // ============================================
  Widget _buildToysShopSection() {
    return SizedBox(
      height: SizeConfig.getProportionateHeight(240),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildItemCard(
            'Tours colorées',
            '4.8',
            '6 000 FCFA',
            ageLabel: '4 - 6 ans',
          ),
          _buildItemCard(
            'Mémoire animaux',
            '4.8',
            '10 000 FCFA',
            ageLabel: '4 - 6 ans',
          ),
        ],
      ),
    );
  }

  // ============================================
  // SHIMMER LOADING
  // ============================================
  Widget _buildShimmerHorizontalList(double height) {
    return SizedBox(
      height: SizeConfig.getProportionateHeight(height),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 14.0),
         
        ),
      ),
    );
  }

  // ============================================
  // CARTE ITEM (jeu ou jouet)
  // ============================================
  Widget _buildItemCard(
    String title,
    String rating,
    String? price, {
    String? ageLabel,
  }) {
    return Container(
      width: SizeConfig.getProportionateWidth(160),
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              clipBehavior: Clip.antiAlias,
              child: const Center(
                child: Icon(Icons.image, color: Colors.black26, size: 40),
              ),
            ),
          ),

          // Infos
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),

                // Label âge
                if (ageLabel != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      ageLabel,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 6),

                // Note + Prix
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Note
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // Prix
                    if (price != null)
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6FB565),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // BOTTOM NAVIGATION BAR
  // ============================================
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF6FB565),
      unselectedItemColor: Colors.black38,
      currentIndex: 0,
      onTap: (index) {},
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.toys_outlined),
          activeIcon: Icon(Icons.toys),
          label: 'Catalogue',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: 'Panier',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          activeIcon: Icon(Icons.favorite),
          label: 'Favoris',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
>>>>>>> parent of e431d00 (derniere modif vendredi)
