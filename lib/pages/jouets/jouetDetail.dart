import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tolon/controller/favoris/favoris_controller.dart';
import 'package:tolon/controller/panier/panier_controller.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/avis/avis_model.dart';
import 'package:tolon/models/jouets/jouet_models.dart';
import 'package:tolon/repository/avis/avis_repository.dart';

class Jouetdetail extends ConsumerStatefulWidget {
  final JouetModel jouet;

  const Jouetdetail({
    super.key,
    required this.jouet,
  });

  @override
  ConsumerState<Jouetdetail> createState() =>
      _JouetdetailState();
}

class _JouetdetailState
    extends ConsumerState<Jouetdetail> {

  final AvisRepository _avisRepository =
      AvisRepository();

  int _selectedImage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final jouet = widget.jouet;

    final panier = ref.watch(panierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),

      body: Stack(
        children: [

          // ====================================================
          // CONTENU PRINCIPAL
          // ====================================================

          CustomScrollView(
            physics:
                const BouncingScrollPhysics(),

            slivers: [

              // ==================================================
              // GALERIE
              // ==================================================

              SliverToBoxAdapter(
                child: _buildProductHeader(
                  jouet,
                  panier.totalQuantity,
                ),
              ),

              // ==================================================
              // INFORMATIONS PRODUIT
              // ==================================================

              SliverToBoxAdapter(
                child: _buildProductInformation(
                  jouet,
                ),
              ),

              // ==================================================
              // DESCRIPTION / BENEFICES
              // ==================================================

              SliverToBoxAdapter(
                child: _buildDetailsSection(
                  jouet,
                ),
              ),

              // ==================================================
              // AVIS
              // ==================================================

              SliverToBoxAdapter(
                child: _buildReviewsSection(
                  jouet,
                ),
              ),

              // ==================================================
              // ESPACE POUR LA BARRE DU BAS
              // ==================================================

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 130,
                ),
              ),
            ],
          ),

          // ====================================================
          // BARRE D'ACHAT FIXE
          // ====================================================

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomPurchaseBar(
              jouet,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // HEADER / GALERIE
  // ==========================================================

  Widget _buildProductHeader(
    JouetModel jouet,
    int quantity,
  ) {
    return SizedBox(
      height: 410,
      child: Stack(
        children: [

          // ====================================================
          // IMAGE PRINCIPALE
          // ====================================================

          Container(
            height: 355,
            width: double.infinity,

            decoration: BoxDecoration(
              color: AppStyles.primarySoft,

              borderRadius:
                  const BorderRadius.only(
                bottomLeft:
                    Radius.circular(40),
                bottomRight:
                    Radius.circular(40),
              ),
            ),

            child: jouet.image.isEmpty
                ? const Center(
                    child: Icon(
                      Icons
                          .image_not_supported_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                  )
                : ClipRRect(
                    borderRadius:
                        const BorderRadius.only(
                      bottomLeft:
                          Radius.circular(40),
                      bottomRight:
                          Radius.circular(40),
                    ),

                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: jouet.image.length,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedImage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          jouet.image[index],
                          fit: BoxFit.cover,
                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 70,
                                color: Colors.grey,
                              ),
                            );
                          },
                          loadingBuilder: (
                            context,
                            child,
                            progress,
                          ) {
                            if (progress == null) {
                              return child;
                            }
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppStyles.primary,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),

          // ====================================================
          // GRADIENT PAR-DESSUS L'IMAGE
          // ====================================================

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,

              decoration:
                  const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(
                      0x66000000,
                    ),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ====================================================
          // BOUTON RETOUR
          // ====================================================

          Positioned(
            top: 48,
            left: 20,

            child: _buildCircleButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () {
                context.pop();
              },
            ),
          ),

          // ====================================================
          // FAVORIS
          // ====================================================

          Positioned(
            top: 48,
            right: 70,
            child: Builder(
              builder: (context) {
                final favorisIds = ref.watch(favorisControllerProvider);
                final isFavori = favorisIds.contains(jouet.id);

                return _buildCircleButton(
                  icon: isFavori ? Icons.favorite : Icons.favorite_border,
                  iconColor: isFavori
                      ? const Color.fromARGB(255, 214, 13, 13)
                      : AppStyles.textDark,
                  onTap: () {
                    ref
                        .read(favorisControllerProvider.notifier)
                        .toggleFavori(jouet.id);

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavori
                              ? '${jouet.nomJouet} retiré des favoris'
                              : '${jouet.nomJouet} ajouté aux favoris',
                        ),
                        backgroundColor: const Color.fromRGBO(230, 126, 34, 1),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ====================================================
          // PANIER
          // ====================================================

          Positioned(
            top: 48,
            right: 20,

            child: Stack(
              clipBehavior:
                  Clip.none,

              children: [

                _buildCircleButton(
                  icon:
                      Icons.shopping_bag_outlined,
                  onTap: () {
                    context.push('/cart');
                  },
                ),

                if (quantity > 0)
                  Positioned(
                    right: -2,
                    top: -4,

                    child: Container(
                      width: 20,
                      height: 20,

                      decoration:
                          const BoxDecoration(
                        color:
                            AppStyles.badgeRed,
                        shape:
                            BoxShape.circle,
                      ),

                      child: Center(
                        child: Text(
                          '$quantity',

                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ====================================================
          // MINIATURES + INDICATEURS
          // ====================================================

          if (jouet.image.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Miniatures
                  SizedBox(
                    height: 62,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: jouet.image.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final selected = _selectedImage == index;

                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 58,
                            height: 58,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected
                                    ? AppStyles.primary
                                    : Colors.white.withValues(alpha: 0.6),
                                width: selected ? 2.5 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                jouet.image[index],
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.image_not_supported,
                                  size: 22,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Points indicateurs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      jouet.image.length,
                      (index) {
                        final selected = _selectedImage == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: selected ? 18 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppStyles.primary
                                : Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: AppStyles.primary.withValues(alpha: 0.4),
                                      blurRadius: 4,
                                    ),
                                  ]
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // BOUTON CERCLE
  // ==========================================================

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.15),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            size: 21,
            color: iconColor ?? AppStyles.textDark,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // INFORMATIONS PRODUIT
  // ==========================================================

  Widget _buildProductInformation(
    JouetModel jouet,
  ) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        5,
        20,
        0,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // ====================================================
          // BADGE AGE
          // ====================================================

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),

            decoration: BoxDecoration(
              color:
                  AppStyles.primarySoft,

              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),

            child: Text(
              '${jouet.ageMin} - ${jouet.ageMax} ans',

              style: const TextStyle(
                color:
                    AppStyles.primary,
                fontWeight:
                    FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ====================================================
          // NOM
          // ====================================================

          Text(
            jouet.nomJouet,

            style: const TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 28,
              fontWeight:
                  FontWeight.w700,
              color:
                  AppStyles.textDark,
              height: 1.15,
            ),
          ),

          const SizedBox(height: 12),

          // ====================================================
          // NOTE
          // ====================================================

          Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),
  
),

          // ====================================================
          // PRIX
          // ====================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,

            children: [

              Text(
                jouet.prix
                    .toStringAsFixed(0),

                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      AppStyles.primary,
                ),
              ),

              const SizedBox(width: 7),

              const Padding(
                padding:
                    EdgeInsets.only(
                  bottom: 5,
                ),

                child: Text(
                  'FCFA',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        AppStyles.textMuted,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ====================================================
          // SÉPARATEUR
          // ====================================================

          Container(
            height: 1,
            color: Colors.black
                .withValues(alpha: 0.06),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DESCRIPTION / BENEFICES
  // ==========================================================

  Widget _buildDetailsSection(
    JouetModel jouet,
  ) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),

      child: Container(
        width: double.infinity,

        padding:
            const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(
                alpha: 0.04,
              ),

              blurRadius: 15,

              offset:
                  const Offset(0, 5),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ==================================================
            // TITRE
            // ==================================================

            const Row(
              children: [

                Icon(
                  Icons.auto_awesome,
                  color:
                      AppStyles.primary,
                  size: 22,
                ),

                SizedBox(width: 8),

                Text(
                  'À propos de ce jeu',
                  style: TextStyle(
                    fontFamily:
                        'Quicksand',
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        AppStyles.textDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ==================================================
            // DESCRIPTION
            // ==================================================

            Text(
              jouet.description.isNotEmpty
                  ? jouet.description
                  : 'Aucune description disponible pour le moment.',

              style: const TextStyle(
                fontSize: 14,
                height: 1.7,
                color:
                    AppStyles.textMuted,
              ),
            ),

            // ==================================================
            // BENEFICES
            // ==================================================

            if (jouet.benefices.isNotEmpty) ...[
              const SizedBox(height: 25),

              const Text(
                'Ce que votre enfant va développer',
                style: TextStyle(
                  fontFamily:
                      'Quicksand',
                  fontSize: 17,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      AppStyles.textDark,
                ),
              ),

              const SizedBox(height: 14),

              ...jouet.benefices
                  .asMap()
                  .entries
                  .map(
                (entry) {

                  return _buildBenefitItem(
                    entry.value,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // BENEFICE
  // ==========================================================

  Widget _buildBenefitItem(
    String text,
  ) {
    return Container(
      width: double.infinity,

      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),

      padding:
          const EdgeInsets.all(13),

      decoration: BoxDecoration(
        color:
            const Color(0xFFF8FAF7),

        borderRadius:
            BorderRadius.circular(
          15,
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(
            width: 30,
            height: 30,

            decoration:
                const BoxDecoration(
              color:
                  AppStyles.primarySoft,
              shape:
                  BoxShape.circle,
            ),

            child: const Icon(
              Icons.check,
              size: 17,
              color:
                  AppStyles.primary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,

              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color:
                    AppStyles.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // AVIS
  // ==========================================================

  Widget _buildReviewsSection(
    JouetModel jouet,
  ) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),

      child: StreamBuilder<List<AvisModel>>(
        stream:
            _avisRepository.recupererAvis(
          jouet.id,
        ),

        builder:
            (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return _buildReviewsLoading();
          }

          if (snapshot.hasError) {
            return _buildReviewsError(
              jouet,
            );
          }

          final avis =
              snapshot.data ?? [];

          double moyenne =
              jouet.noteMoyen;

          if (avis.isNotEmpty) {
            final total =
                avis.fold<int>(
              0,
              (sum, item) =>
                  sum + item.note,
            );

            moyenne =
                total / avis.length;
          }

          return Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // ==================================================
              // TITRE
              // ==================================================

              const Text(
                'Avis des parents',
                style: TextStyle(
                  fontFamily:
                      'Quicksand',
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      AppStyles.textDark,
                ),
              ),

              const SizedBox(height: 15),

              // ==================================================
              // RÉSUMÉ NOTE
              // ==================================================

              _buildRatingSummary(
                moyenne,
                avis.length,
              ),

              const SizedBox(height: 20),

              // ==================================================
              // AVIS
              // ==================================================

              if (avis.isEmpty)

                _buildEmptyReviews()

              else

                ...avis.map(
                  (avisItem) {
                    return _buildReviewCard(
                      avis: avisItem,
                    );
                  },
                ),

              const SizedBox(height: 5),

              // ==================================================
              // REDIGER UN AVIS
              // ==================================================

              _buildWriteReviewButton(
                jouet,
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================================
  // RÉSUMÉ NOTE
  // ==========================================================

  Widget _buildRatingSummary(
    double moyenne,
    int nombreAvis,
  ) {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: Colors.black
              .withValues(alpha: 0.05),
        ),
      ),

      child: Row(
        children: [

          // ==================================================
          // NOTE
          // ==================================================

          Column(
            children: [

              Text(
                moyenne.toStringAsFixed(1),

                style: const TextStyle(
                  fontFamily:
                      'Quicksand',
                  fontSize: 34,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      AppStyles.textDark,
                ),
              ),

              Row(
                children:
                    List.generate(
                  5,
                  (index) {
                    return Icon(
                      index <
                              moyenne.round()
                          ? Icons.star
                          : Icons.star_border,

                      size: 18,

                      color:
                          const Color(
                        0xFFFFC400,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 5),

              Text(
                '$nombreAvis avis',

                style: const TextStyle(
                  fontSize: 12,
                  color:
                      AppStyles.textMuted,
                ),
              ),
            ],
          ),

          const SizedBox(width: 25),

          // ==================================================
          // TEXTE
          // ==================================================

          const Expanded(
            child: Text(
              'Les parents partagent leur expérience pour vous aider à choisir les meilleurs jeux pour vos enfants.',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color:
                    AppStyles.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CARTE AVIS
  // ==========================================================

  Widget _buildReviewCard({
    required AvisModel avis,
  }) {
    return Container(
      width: double.infinity,

      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.black
              .withValues(alpha: 0.04),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              // ==================================================
              // AVATAR
              // ==================================================

              CircleAvatar(
                radius: 21,

                backgroundColor:
                    AppStyles.primarySoft,

                child: const Icon(
                  Icons.person,
                  color:
                      AppStyles.primary,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              // ==================================================
              // UTILISATEUR
              // ==================================================

              Expanded(
                child: FutureBuilder<
                    DocumentSnapshot<
                        Map<String,
                            dynamic>>>(
                  future:
                      FirebaseFirestore
                          .instance
                          .collection(
                              'users')
                          .doc(
                              avis.userId)
                          .get(),

                  builder:
                      (
                    context,
                    snapshot,
                  ) {

                    if (snapshot
                            .connectionState ==
                        ConnectionState
                            .waiting) {
                      return const Text(
                        'Chargement...',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      );
                    }

                    final data =
                        snapshot.data
                            ?.data();

                    if (data == null) {
                      return const Text(
                        'Utilisateur',
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      );
                    }

                    final prenom =
                        data['prenom']
                                ?.toString()
                                .trim() ??
                            '';

                    final nom =
                        data['nom']
                                ?.toString()
                                .trim() ??
                            '';

                    final email =
                        data['email']
                                ?.toString()
                                .trim() ??
                            '';

                    String nomUtilisateur;

                    if (prenom.isNotEmpty &&
                        nom.isNotEmpty) {
                      nomUtilisateur =
                          '$prenom $nom';
                    } else if (
                        prenom.isNotEmpty) {
                      nomUtilisateur =
                          prenom;
                    } else if (
                        nom.isNotEmpty) {
                      nomUtilisateur =
                          nom;
                    } else if (
                        email.isNotEmpty) {
                      nomUtilisateur =
                          email;
                    } else {
                      nomUtilisateur =
                          'Utilisateur';
                    }

                    return Text(
                      nomUtilisateur,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        color:
                            AppStyles.textDark,
                      ),
                    );
                  },
                ),
              ),

              // ==================================================
              // NOTE
              // ==================================================

              Row(
                children:
                    List.generate(
                  5,
                  (index) {
                    return Icon(
                      index < avis.note
                          ? Icons.star
                          : Icons.star_border,

                      size: 16,

                      color:
                          const Color(
                        0xFFFFC400,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            avis.commentaire,

            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color:
                  AppStyles.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // AUCUN AVIS
  // ==========================================================

  Widget _buildEmptyReviews() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.symmetric(
        vertical: 28,
        horizontal: 20,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: const Column(
        children: [

          Icon(
            Icons.rate_review_outlined,
            size: 45,
            color: Colors.grey,
          ),

          SizedBox(height: 10),

          Text(
            'Aucun avis pour le moment',

            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
              color:
                  AppStyles.textDark,
            ),
          ),

          SizedBox(height: 5),

          Text(
            'Soyez le premier parent à partager votre expérience.',
            textAlign:
                TextAlign.center,

            style: TextStyle(
              fontSize: 13,
              color:
                  AppStyles.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CHARGEMENT AVIS
  // ==========================================================

  Widget _buildReviewsLoading() {
    return const Padding(
      padding:
          EdgeInsets.symmetric(
        vertical: 40,
      ),

      child: Center(
        child:
            CircularProgressIndicator(
          color:
              AppStyles.primary,
        ),
      ),
    );
  }

  // ==========================================================
  // ERREUR AVIS
  // ==========================================================

  Widget _buildReviewsError(
    JouetModel jouet,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(
          'Avis des parents',

          style: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          'Impossible de charger les avis.',
          style: TextStyle(
            color:
                AppStyles.textMuted,
          ),
        ),

        const SizedBox(height: 15),

        _buildWriteReviewButton(
          jouet,
        ),
      ],
    );
  }

  // ==========================================================
  // BOUTON RÉDIGER UN AVIS
  // ==========================================================

  Widget _buildWriteReviewButton(
    JouetModel jouet,
  ) {
    return SizedBox(
      width: double.infinity,

      child: OutlinedButton.icon(
        onPressed: () {

          context.pushNamed(
            AppRoutes.redigerAvis.name,
            extra: jouet,
          );
        },

        icon: const Icon(
          Icons.edit_outlined,
        ),

        label: const Text(
          'Rédiger un avis',
          style: TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),

        style: OutlinedButton.styleFrom(
          foregroundColor: const Color.fromRGBO(230, 126, 34, 1),
          side: const BorderSide(
            color: Color.fromRGBO(230, 126, 34, 1),
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // BARRE ACHAT
  // ==========================================================

  Widget _buildBottomPurchaseBar(
    JouetModel jouet,
  ) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            const BorderRadius.only(
          topLeft:
              Radius.circular(25),
          topRight:
              Radius.circular(25),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.10,
            ),

            blurRadius: 20,

            offset:
                const Offset(0, -5),
          ),
        ],
      ),

      child: SafeArea(
        top: false,

        child: Row(
          children: [

            // ==================================================
            // PRIX
            // ==================================================

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              mainAxisSize:
                  MainAxisSize.min,

              children: [

                const Text(
                  'Prix',
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        AppStyles.textMuted,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  '${jouet.prix.toStringAsFixed(0)} FCFA',

                  style:
                      const TextStyle(
                    fontFamily:
                        'Quicksand',
                    fontSize: 17,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        AppStyles.textDark,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 15),

            // ==================================================
            // BOUTON
            // ==================================================

            Expanded(
              child: SizedBox(
                height: 54,

                child:
                    ElevatedButton.icon(
                  onPressed: () {

                    ref
                        .read(
                          panierProvider
                              .notifier,
                        )
                        .addToCart(
                          jouet,
                        );

                    ScaffoldMessenger
                            .of(context)
                        .hideCurrentSnackBar();

                    ScaffoldMessenger
                            .of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          '${jouet.nomJouet} ajouté au panier',
                        ),

                        backgroundColor:
                            const Color.fromRGBO(230, 126, 34, 1),

                        behavior:
                            SnackBarBehavior
                                .floating,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            15,
                          ),
                        ),
                      ),
                    );
                  },

                  icon: const Icon(
                    Icons
                        .shopping_bag_outlined,
                    size: 21,
                  ),

                  label: const Text(
                    'Ajouter au panier',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(230, 126, 34, 1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
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