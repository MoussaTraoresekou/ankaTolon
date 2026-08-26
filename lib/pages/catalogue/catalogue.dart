import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/commun_widget/favoris/bouton_favori.dart';
import 'package:tolon/controller/catalogue/catalogue_controller.dart';
import 'package:tolon/controller/panier/panier_controller.dart';
import 'package:tolon/models/jouets/jouet_models.dart';
import 'package:tolon/firebase_options.dart';
import 'package:tolon/pages/page_to_delete.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

class CataloguePage extends ConsumerStatefulWidget {
  const CataloguePage({super.key});

  @override
  ConsumerState<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends ConsumerState<CataloguePage> {
  final CatalogueController _catalogueController = CatalogueController();

  String selectedAge = 'Tous';
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final panierState = ref.watch(panierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAF8),
        elevation: 0,
        title: const Text(
          'Catalogue de jouets',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF171717),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {
                    context.push('/cart');
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Color(0xFF171717),
                    size: 27,
                  ),
                ),
                if (panierState.totalQuantity > 0)
                  Positioned(
                    right: 2,
                    top: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${panierState.totalQuantity}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // TITRE
            // ==================================================
            // const Padding(
            //   padding: EdgeInsets.only(left: 20, right: 20, top: 18),
            //   child: Text(
            //     'Catalogue de jouets',
            //     style: TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.w700,
            //       color: Color(0xFF171717),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 15),

            // ==================================================
            // BARRE DE RECHERCHE
            // ==================================================
            _buildSearchBar(),

            const SizedBox(height: 17),

            // ==================================================
            // FILTRES ÂGE
            // ==================================================
            _buildAgeFilters(),

            const SizedBox(height: 24),

            // ==================================================
            // LISTE DES JOUETS
            // ==================================================
            Expanded(
              child: StreamBuilder<List<JouetModel>>(
                stream: _catalogueController.getJouets(),

                builder: (context, snapshot) {
                  // ==================================================
                  // CHARGEMENT
                  // ==================================================

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0AA361),
                      ),
                    );
                  }

                  // ==================================================
                  // ERREUR
                  // ==================================================

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Erreur : ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  }

                  // ==================================================
                  // DONNÉES
                  // ==================================================

                  final jouets = snapshot.data ?? [];

                  // ==================================================
                  // FILTRAGE
                  // ==================================================

                  final filteredJouets = _filterJouets(jouets);

                  // ==================================================
                  // AUCUN RÉSULTAT
                  // ==================================================

                  if (filteredJouets.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aucun jouet trouvé',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    );
                  }

                  // ==================================================
                  // GRILLE
                  // ==================================================

                  return _buildProductGrid(filteredJouets);
                },
              ),
            ),
          ],
        ),
      ),

      // ==================================================
      // BOTTOM NAVIGATION
      // ==================================================

      // bottomNavigationBar: AppBottomNavigationBar(),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 36,
        child: TextField(
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
          },

          decoration: InputDecoration(
            hintText: 'Rechercher un jouet',

            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF999999)),

            prefixIcon: const Icon(Icons.search, size: 21, color: Colors.black),

            filled: true,

            fillColor: Colors.white,

            contentPadding: EdgeInsets.zero,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

              borderSide: const BorderSide(color: Color(0xFFD8D8D8)),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

              borderSide: const BorderSide(color: Color(0xFFD8D8D8)),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

              borderSide: const BorderSide(color: Color(0xFF0AA361)),
            ),
          ),
        ),
      ),
    );
  }

  // ==================================================
  // FILTRES ÂGE
  // ==================================================

  Widget _buildAgeFilters() {
    final ages = ['Tous', '4-6 ans', '7-9 ans', '10-12 ans'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      padding: const EdgeInsets.symmetric(horizontal: 35),

      child: Row(
        children: ages.map((age) {
          final selected = selectedAge == age;

          return Padding(
            padding: const EdgeInsets.only(right: 6),

            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedAge = age;
                });
              },

              child: Container(
                height: 33,

                padding: const EdgeInsets.symmetric(horizontal: 17),

                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF0AA361)
                      : const Color(0xFFE0F0E5),

                  borderRadius: BorderRadius.circular(20),
                ),

                alignment: Alignment.center,

                child: Text(
                  age,

                  style: TextStyle(
                    fontSize: 11,

                    fontWeight: selected ? FontWeight.w500 : FontWeight.w400,

                    color: selected ? Colors.white : const Color(0xFF222222),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<JouetModel> _filterJouets(List<JouetModel> jouets) {
    return jouets.where((jouet) {
      bool matchesAge = true;

      // ==================================================
      // FILTRE PAR ÂGE
      // ==================================================

      if (selectedAge != 'Tous') {
        switch (selectedAge) {
          case '4-6 ans':
            matchesAge = jouet.ageMin <= 6 && jouet.ageMax >= 4;
            break;

          case '7-9 ans':
            matchesAge = jouet.ageMin <= 9 && jouet.ageMax >= 7;
            break;

          case '10-12 ans':
            matchesAge = jouet.ageMin <= 12 && jouet.ageMax >= 10;
            break;
        }
      }

      // ==================================================
      // RECHERCHE
      // ==================================================

      final matchesSearch = jouet.nomJouet.toLowerCase().contains(
        searchText.toLowerCase(),
      );

      return matchesAge && matchesSearch;
    }).toList();
  }

  Widget _buildProductGrid(List<JouetModel> jouets) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),

      itemCount: jouets.length,

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,

        crossAxisSpacing: 20,

        mainAxisSpacing: 24,

        childAspectRatio: 0.62,
      ),

      itemBuilder: (context, index) {
        return _buildProductCard(jouets[index]);
      },
    );
  }

  Widget _buildProductCard(JouetModel jouet) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),

      onTap: () {
        context.pushNamed(AppRoutes.jouetDetail.name, extra: jouet);
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(10),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),

              blurRadius: 5,

              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            // ==================================================
            // IMAGE
            // ==================================================
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),

              child: AspectRatio(
                aspectRatio: 1.15,

                child: jouet.image.isNotEmpty
                    ? Image.network(
                        jouet.image.first,

                        fit: BoxFit.cover,

                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0AA361),
                            ),
                          );
                        },

                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFEAF5ED),

                            child: const Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: const Color(0xFFEAF5ED),

                        child: const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 3),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),

              child: Text(
                jouet.nomJouet,

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 12,

                  fontWeight: FontWeight.w500,

                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 3),

            // ==================================================
            // ÂGE
            // ==================================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),

              decoration: BoxDecoration(
                color: const Color(0xFFE5F2E8),

                borderRadius: BorderRadius.circular(10),
              ),

              child: Text(
                '${jouet.ageMin}-${jouet.ageMax} ans',

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(fontSize: 9, color: Color(0xFF4B6A52)),
              ),
            ),

            const SizedBox(height: 4),

            // ==================================================
            // NOTE + PRIX + FAVORIS
            // ==================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),

              child: Row(
                children: [
                  // NOTE
                  const Icon(Icons.star, color: Color(0xFFFFC400), size: 16),

                  const SizedBox(width: 2),

                  Text(
                    jouet.noteMoyen.toStringAsFixed(1),

                    style: const TextStyle(
                      fontSize: 10,

                      color: Color(0xFF777777),
                    ),
                  ),

                  const Spacer(),

                  // PRIX
                  Flexible(
                    child: Text(
                      '${jouet.prix.toStringAsFixed(0)} FCFA',

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      textAlign: TextAlign.right,

                      style: const TextStyle(
                        fontSize: 10,

                        fontWeight: FontWeight.w500,

                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(width: 2),

                  BoutonFavori(jouetId: jouet.id),
                ],
              ),
            ),

            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// MAIN
// ============================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ==========================================================
  // FIREBASE
  // ==========================================================

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ==========================================================
  // SUPABASE
  // ==========================================================

  await Supabase.initialize(
    url: 'https://zoagjvcjrolrrlhdkhob.supabase.co',
    anonKey: 'sb_publishable_KDK3Dxx_1XfarmHK1CI5YA_c4aRncjy',
  );

  // ==========================================================
  // APPLICATION
  // ==========================================================

  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Page1()));
}
