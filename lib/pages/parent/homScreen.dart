import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';

import 'package:tolon/models/enfant/enfant_modal.dart';
import 'package:tolon/models/jouets/jouet_models.dart';

import 'package:tolon/repository/enfant/enfant_repository.dart';
import 'package:tolon/repository/jouets_reposotory/jouet_repository.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // Enfants depuis Firestore
    final enfantsAsync = ref.watch(enfantsProvider);

    // Jouets depuis Firestore
    final jouetsAsync = ref.watch(watchJouetsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF9),

      body: SafeArea(
        child: RefreshIndicator(
          color: AppStyles.primaryOrange,
          onRefresh: () async {
            ref.invalidate(enfantsProvider);
            ref.invalidate(watchJouetsProvider);
          },

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // =====================================================
                  // HEADER
                  // =====================================================

                  _buildHeaderSection(),

                  SizedBox(
                    height:
                        SizeConfig.getProportionateHeight(24),
                  ),

                  // =====================================================
                  // ENFANTS
                  // =====================================================

                  _buildSectionTitle(
                    'Mes enfants',
                  ),

                  SizedBox(
                    height:
                        SizeConfig.getProportionateHeight(12),
                  ),

                  _buildChildrenSection(
                    enfantsAsync,
                  ),

                  SizedBox(
                    height:
                        SizeConfig.getProportionateHeight(24),
                  ),

                  // =====================================================
                  // JEUX
                  // =====================================================

                  _buildSectionTitle(
                    'Jeux les plus notés',
                  ),

                  SizedBox(
                    height:
                        SizeConfig.getProportionateHeight(12),
                  ),

                  _buildGamesSection(),

                  SizedBox(
                    height:
                        SizeConfig.getProportionateHeight(24),
                  ),

                  // =====================================================
                  // BOUTIQUE
                  // =====================================================

                  _buildSectionTitle(
                    'Boutique des jouets',
                  ),

                  SizedBox(
                    height:
                        SizeConfig.getProportionateHeight(12),
                  ),

                  _buildToysShopSection(
                    jouetsAsync,
                  ),

                  SizedBox(
                    height:
                        SizeConfig.getProportionateHeight(24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar:
          _buildBottomNavigationBar(),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor:
                  Color(0xFFE8F5E9),
              child: Icon(
                Icons.person,
                color: Colors.grey,
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  'Bonjour 👋',
                  style: AppStyles.titleTextStyle
                      .copyWith(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const Text(
                  'Heureux de vous retrouver',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),

        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_outlined,
                size: 28,
              ),
              onPressed: () {},
            ),

            Positioned(
              right: 6,
              top: 6,

              child: Container(
                padding:
                    const EdgeInsets.all(4),

                decoration:
                    const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),

                child: const Text(
                  '10',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // TITRE SECTION
  // ============================================================

  Widget _buildSectionTitle(
    String title,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,
          style: AppStyles.titleTextStyle
              .copyWith(
            fontSize: 16,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        TextButton(
          onPressed: () {},
          child: const Text(
            'Voir tout',
            style: TextStyle(
              color: Color(0xFF6FB565),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ENFANTS
  // ============================================================

  Widget _buildChildrenSection(
    AsyncValue<List<EnfantModel>>
        enfantsAsync,
  ) {
    return enfantsAsync.when(

      // ----------------------------------------------------------
      // LOADING
      // ----------------------------------------------------------

      loading: () {
        return const SizedBox(
          height: 75,
          child: Center(
            child:
                CircularProgressIndicator(),
          ),
        );
      },

      // ----------------------------------------------------------
      // ERREUR
      // ----------------------------------------------------------

      error: (error, stack) {
        return SizedBox(
          height: 75,

          child: Center(
            child: Text(
              'Impossible de charger les enfants.',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        );
      },

      // ----------------------------------------------------------
      // DONNÉES
      // ----------------------------------------------------------

      data: (enfants) {
        return SizedBox(
          height:
              SizeConfig.getProportionateHeight(
            75,
          ),

          child: ListView(
            scrollDirection:
                Axis.horizontal,

            children: [
              // -----------------------------------------------
              // ENFANTS FIRESTORE
              // -----------------------------------------------

              ...enfants.map(
                (enfant) {
                  return _buildChildCard(
                    enfant,
                  );
                },
              ),

              // -----------------------------------------------
              // AJOUTER UN ENFANT
              // -----------------------------------------------

              GestureDetector(
                onTap: () {
                  context.goNamed(
                    AppRoutes.addEnfant.name,
                  );
                },

                child: Container(
                  width: SizeConfig
                      .getProportionateWidth(
                    100,
                  ),

                  margin:
                      const EdgeInsets.only(
                    right: 12,
                  ),

                  decoration:
                      BoxDecoration(
                    border:
                        Border.all(
                      color:
                          Colors.black12,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),

                  child:
                      const Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [
                      Icon(
                        Icons
                            .add_circle_outline,
                        color:
                            Colors.green,
                        size: 26,
                      ),

                      SizedBox(height: 4),

                      Text(
                        'Ajouter',
                        style:
                            TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.goNamed(
                    AppRoutes.addjouet.name,
                  );
                },

                child: Container(
                  width: SizeConfig
                      .getProportionateWidth(
                    100,
                  ),

                  margin:
                      const EdgeInsets.only(
                    right: 12,
                  ),

                  decoration:
                      BoxDecoration(
                    border:
                        Border.all(
                      color:
                          Colors.black12,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),

                  child:
                      const Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,

                    children: [
                      Icon(
                        Icons
                            .add_circle_outline,
                        color:
                            Colors.green,
                        size: 26,
                      ),

                      SizedBox(height: 4),

                      Text(
                        'joutes',
                        style:
                            TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight
                                  .bold,
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
  }

  // ============================================================
  // CARTE ENFANT
  // ============================================================

  Widget _buildChildCard(
    EnfantModel enfant,
  ) {
    return Container(
      width: SizeConfig
          .getProportionateWidth(
        140,
      ),

      margin:
          const EdgeInsets.only(
        right: 12,
      ),

      padding:
          const EdgeInsets.all(10),

      decoration:
          BoxDecoration(
        color:
            const Color(0xFFE8F5E9),

        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),

      child: Row(
        children: [
          // -----------------------------------------------
          // ICÔNE — PAS D'AVATAR
          // -----------------------------------------------

          const CircleAvatar(
            radius: 20,
            backgroundColor:
                Colors.white,

            child: Icon(
              Icons.person,
              color: Colors.grey,
            ),
          ),

          const SizedBox(width: 10),

          // -----------------------------------------------
          // NOM + ÂGE
          // -----------------------------------------------

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  '${enfant.prenom} ${enfant.nom}',
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,

                  style: AppStyles
                      .normalTextStyle
                      .copyWith(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  _calculerAge(
                    enfant.naissance,
                  ),

                  style:
                      const TextStyle(
                    color:
                        Colors.black45,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CALCUL ÂGE
  // ============================================================

  String _calculerAge(
    DateTime naissance,
  ) {
    final maintenant =
        DateTime.now();

    int age =
        maintenant.year -
            naissance.year;

    if (maintenant.month <
            naissance.month ||
        (maintenant.month ==
                naissance.month &&
            maintenant.day <
                naissance.day)) {
      age--;
    }

    return '$age ans';
  }

  // ============================================================
  // JEUX
  // ============================================================

  Widget _buildGamesSection() {
    return SizedBox(
      height:
          SizeConfig.getProportionateHeight(
        150,
      ),

      child: const Center(
        child: Text(
          'Aucun jeu disponible.',
          style: TextStyle(
            color: Colors.black45,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOUTIQUE JOUETS
  // ============================================================

  Widget _buildToysShopSection(
    AsyncValue<List<JouetModel>>
        jouetsAsync,
  ) {
    return jouetsAsync.when(

      // ----------------------------------------------------------
      // LOADING
      // ----------------------------------------------------------

      loading: () {
        return SizedBox(
          height:
              SizeConfig
                  .getProportionateHeight(
            240,
          ),

          child: const Center(
            child:
                CircularProgressIndicator(),
          ),
        );
      },

      // ----------------------------------------------------------
      // ERREUR
      // ----------------------------------------------------------

      error: (error, stack) {
        return SizedBox(
          height:
              SizeConfig
                  .getProportionateHeight(
            100,
          ),

          child: const Center(
            child: Text(
              'Impossible de charger les jouets.',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        );
      },

      // ----------------------------------------------------------
      // DONNÉES
      // ----------------------------------------------------------

      data: (jouets) {
        if (jouets.isEmpty) {
          return SizedBox(
            height:
                SizeConfig
                    .getProportionateHeight(
              100,
            ),

            child: const Center(
              child: Text(
                'Aucun jouet disponible.',
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
            ),
          );
        }

        return SizedBox(
          height:
              SizeConfig
                  .getProportionateHeight(
            240,
          ),

          child: ListView.builder(
            scrollDirection:
                Axis.horizontal,

            itemCount:
                jouets.length,

            itemBuilder:
                (context, index) {
              final jouet =
                  jouets[index];

              return _buildItemCard(
                jouet,
              );
            },
          ),
        );
      },
    );
  }

  // ============================================================
  // CARTE JOUET
  // ============================================================

  Widget _buildItemCard(
    JouetModel jouet,
  ) {
    return Container(
      width: SizeConfig
          .getProportionateWidth(
        160,
      ),

      margin:
          const EdgeInsets.only(
        right: 14,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          16,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.05,
            ),

            blurRadius: 6,

            offset:
                const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ====================================================
          // IMAGE
          // ====================================================

          Expanded(
            child: Container(
              width: double.infinity,

              decoration:
                  const BoxDecoration(
                color:
                    Color(0xFFF0F0F0),

                borderRadius:
                    BorderRadius.vertical(
                  top:
                      Radius.circular(
                    16,
                  ),
                ),
              ),

              clipBehavior:
                  Clip.antiAlias,

              child:
                  jouet.image.isNotEmpty
                      ? Image.network(
                          jouet.image.first,
                          fit:
                              BoxFit.cover,

                          width:
                              double.infinity,

                          errorBuilder:
                              (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return const Icon(
                              Icons
                                  .image_not_supported,
                              color:
                                  Colors.black26,
                              size: 40,
                            );
                          },
                        )
                      : const Icon(
                          Icons.image,
                          color:
                              Colors.black26,
                          size: 40,
                        ),
            ),
          ),

          // ====================================================
          // INFORMATIONS
          // ====================================================

          Padding(
            padding:
                const EdgeInsets.all(
              10,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  jouet.nomJouet,

                  maxLines: 1,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                // AGE
                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFFE8F5E9,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      4,
                    ),
                  ),

                  child: Text(
                    '${jouet.ageMin} - ${jouet.ageMax} ans',

                    style:
                        const TextStyle(
                      color:
                          Colors.green,
                      fontSize: 10,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // NOTE + PRIX
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color:
                              Colors.amber,
                          size: 14,
                        ),

                        const SizedBox(
                          width: 2,
                        ),

                        Text(
                          jouet.noteMoyen
                              .toStringAsFixed(
                            1,
                          ),

                          style:
                              const TextStyle(
                            fontSize: 12,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      '${jouet.prix.toStringAsFixed(0)} FCFA',

                      style:
                          const TextStyle(
                        fontSize: 11,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Color(
                          0xFF6FB565,
                        ),
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

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type:
          BottomNavigationBarType.fixed,

      selectedItemColor:
          const Color(
        0xFF6FB565,
      ),

      unselectedItemColor:
          Colors.black38,

      currentIndex: 0,

      onTap: (index) {},

      items: const [
        BottomNavigationBarItem(
          icon:
              Icon(Icons.home_outlined),
          activeIcon:
              Icon(Icons.home),
          label: 'Accueil',
        ),

        BottomNavigationBarItem(
          icon:
              Icon(Icons.toys_outlined),
          activeIcon:
              Icon(Icons.toys),
          label: 'Catalogue',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_cart_outlined,
          ),
          activeIcon: Icon(
            Icons.shopping_cart,
          ),
          label: 'Panier',
        ),

        BottomNavigationBarItem(
          icon:
              Icon(Icons.favorite_outline),
          activeIcon:
              Icon(Icons.favorite),
          label: 'Favoris',
        ),

        BottomNavigationBarItem(
          icon:
              Icon(Icons.person_outline),
          activeIcon:
              Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}