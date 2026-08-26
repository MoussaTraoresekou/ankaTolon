import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tolon/controller/panier/panier_controller.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/jouets/jouet_models.dart';
import 'package:tolon/models/avis/avis_model.dart';
import 'package:tolon/repository/avis/avis_repository.dart';
import 'package:tolon/cor/router/routes.dart';

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

class _JouetdetailState extends ConsumerState<Jouetdetail> {

  final AvisRepository _avisRepository =
      AvisRepository();

  @override
  Widget build(BuildContext context) {
    final jouet = widget.jouet;

    final panier = ref.watch(panierProvider);

    return Scaffold(
      backgroundColor: AppStyles.bgColor,

      appBar: AppBar(
        backgroundColor: AppStyles.bgColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppStyles.textDark,
          ),
        ),

        title: const Text(
          'Détail du jouet',
          style: AppStyles.titleTextStyle,
        ),

        actions: [
          _buildCartIcon(panier.totalQuantity),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          bottom: 110,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            
            // IMAGE
           

            _buildImage(jouet),

            const SizedBox(height: 20),

            
            // INFORMATIONS
            

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    jouet.nomJouet,
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textDark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFC400),
                        size: 22,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        jouet.noteMoyen
                            .toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppStyles.primarySoft,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${jouet.ageMin}-${jouet.ageMax} ans',
                          style: const TextStyle(
                            color: AppStyles.primary,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    '${jouet.prix.toStringAsFixed(0)} FCFA',
                    style: const TextStyle(
                      color: AppStyles.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  
                  // DESCRIPTION
                  

                  const Text(
                    'Description',
                    style: AppStyles.headingTextStyle,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    jouet.description.isNotEmpty
                        ? jouet.description
                        : 'Aucune description disponible.',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: AppStyles.textMuted,
                    ),
                  ),

                  const SizedBox(height: 25),

                  
                  // BENEFICES
                  

                  if (jouet.benefices.isNotEmpty) ...[
                    const Text(
                      'Bénéfices pédagogiques',
                      style: AppStyles.headingTextStyle,
                    ),

                    const SizedBox(height: 10),

                    ...jouet.benefices.map(
                      (benefice) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 8,
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color:
                                    AppStyles.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  benefice,
                                  style:
                                      const TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 30),

                  
                  // AVIS
                  

                  _buildReviewsSection(
                    jouet,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      
      // BOUTON PANIER
      

      bottomNavigationBar: _buildAddToCartButton(
        jouet,
      ),
    );
  }

  
  // IMAGE
  

  Widget _buildImage(JouetModel jouet) {
    if (jouet.image.isEmpty) {
      return Container(
        height: 280,
        width: double.infinity,
        color: AppStyles.primarySoft,
        child: const Icon(
          Icons.image_not_supported,
          size: 80,
          color: Colors.grey,
        ),
      );
    }

    return Container(
      height: 280,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: AppStyles.primarySoft,
        borderRadius: BorderRadius.circular(25),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        jouet.image.first,
        fit: BoxFit.cover,

        loadingBuilder:
            (context, child, progress) {
          if (progress == null) {
            return child;
          }

          return const Center(
            child: CircularProgressIndicator(
              color: AppStyles.primary,
            ),
          );
        },

        errorBuilder:
            (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 70,
              color: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  
  // ICONE PANIER
  

  Widget _buildCartIcon(int quantity) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 15,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [

          IconButton(
            onPressed: () {
              context.push('/cart');
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppStyles.textDark,
              size: 27,
            ),
          ),

          if (quantity > 0)
            Positioned(
              right: 2,
              top: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration:
                    const BoxDecoration(
                  color: AppStyles.badgeRed,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$quantity',
                    style:
                        const TextStyle(
                      color: Colors.white,
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
    );
  }

  
  // AVIS
  

  Widget _buildReviewsSection(
  JouetModel jouet,
) {
  return StreamBuilder<List<AvisModel>>(
    stream: _avisRepository.recupererAvis(
      jouet.id,
    ),

    builder: (context, snapshot) {

      // ==================================================
      // CHARGEMENT
      // ==================================================

      if (snapshot.connectionState ==
          ConnectionState.waiting) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              color: AppStyles.primary,
            ),
          ),
        );
      }

      
      // ERREUR
      

      if (snapshot.hasError) {
        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Text(
              'Avis',
              style: AppStyles.headingTextStyle,
            ),

            const SizedBox(height: 15),

            Text(
              'Impossible de charger les avis.',
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 15),

            _buildWriteReviewButton(jouet),
          ],
        );
      }

      
      // RÉCUPÉRATION DES AVIS
      

      final avis = snapshot.data ?? [];

    
      // CALCUL DE LA MOYENNE
      

      double moyenne = jouet.noteMoyen;

      if (avis.isNotEmpty) {
        final total = avis.fold<int>(
          0,
          (sum, item) => sum + item.note,
        );

        moyenne = total / avis.length;
      }

      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

         
          // TITRE AVIS
          

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [

              const Text(
                'Avis',
                style:
                    AppStyles.headingTextStyle,
              ),

              Row(
                children: [

                  const Icon(
                    Icons.star,
                    color: Color(0xFFFFC400),
                    size: 20,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    moyenne.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      color:
                          AppStyles.textDark,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 5),

          
          // NOMBRE D'AVIS
          

          Text(
            avis.isEmpty
                ? 'Aucun avis pour le moment'
                : '${avis.length} avis',

            style: const TextStyle(
              color: AppStyles.textMuted,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 15),

          
          // LISTE DES AVIS
          

          if (avis.isEmpty)

            Container(
              width: double.infinity,

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(15),
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
                    'Soyez le premier à donner votre avis !',
                    textAlign:
                        TextAlign.center,

                    style: TextStyle(
                      color:
                          AppStyles.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )

          else

            ...avis.map(
              (avisItem) {
                return _buildReviewCard(
                  avis: avisItem,
                );
              },
            ),

          const SizedBox(height: 10),

          // ==================================================
          // BOUTON RÉDIGER UN AVIS
          // ==================================================

          _buildWriteReviewButton(jouet),
        ],
      );
    },
  );
}


  // CARTE AVIS
  

  Widget _buildReviewCard({
  required AvisModel avis,
}) {
  return Container(
    width: double.infinity,

    margin: const EdgeInsets.only(
      bottom: 12,
    ),

    padding: const EdgeInsets.all(15),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),

      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: 0.05,
          ),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Row(
          children: [

            
            // AVATAR
            

            CircleAvatar(
              radius: 20,

              backgroundColor:
                  AppStyles.primarySoft,

              child: const Icon(
                Icons.person,
                color: AppStyles.primary,
              ),
            ),

            const SizedBox(width: 10),

            
            // NOM DE L'UTILISATEUR
            

            Expanded(
              child: FutureBuilder<
                  DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(avis.userId)
                    .get(),

                builder: (
                  context,
                  snapshot,
                ) {

                  // Pendant le chargement
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text(
                      'Chargement...',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    );
                  }

                  // Si erreur
                  if (snapshot.hasError) {
                    return const Text(
                      'Utilisateur',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    );
                  }

                  // Document utilisateur
                  final data =
                      snapshot.data?.data();

                  if (data == null) {
                    return const Text(
                      'Utilisateur',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    );
                  }

                  // ==================================
                  // RÉCUPÉRATION DU NOM
                  // ==================================

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

                  // Prénom + nom
                  if (prenom.isNotEmpty &&
                      nom.isNotEmpty) {
                    nomUtilisateur =
                        '$prenom $nom';
                  }

                  // Seulement prénom
                  else if (prenom.isNotEmpty) {
                    nomUtilisateur = prenom;
                  }

                  // Seulement nom
                  else if (nom.isNotEmpty) {
                    nomUtilisateur = nom;
                  }

                  // Sinon email
                  else if (email.isNotEmpty) {
                    nomUtilisateur = email;
                  }

                  // Aucun renseignement
                  else {
                    nomUtilisateur =
                        'Utilisateur';
                  }

                  return Text(
                    nomUtilisateur,

                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  );
                },
              ),
            ),

            // ==========================================
            // ÉTOILES
            // ==========================================

            Row(
              children: List.generate(
                5,
                (index) {
                  return Icon(
                    index < avis.note
                        ? Icons.star
                        : Icons.star_border,

                    size: 17,

                    color: const Color(
                      0xFFFFC400,
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // ==========================================
        // COMMENTAIRE
        // ==========================================

        Text(
          avis.commentaire,

          style: const TextStyle(
            color: AppStyles.textMuted,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}
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
      ),

      style: OutlinedButton.styleFrom(
        foregroundColor:
            AppStyles.primary,

        side: const BorderSide(
          color: AppStyles.primary,
        ),

        padding:
            const EdgeInsets.symmetric(
          vertical: 14,
        ),

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

  
  // AJOUTER AU PANIER
  

  Widget _buildAddToCartButton(
    JouetModel jouet,
  ) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {

              // Notre PanierNotifier existe déjà
              // dans ton projet.

              ref
                  .read(panierProvider.notifier)
                  .addToCart(jouet);

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    '${jouet.nomJouet} ajouté au panier',
                  ),
                  backgroundColor:
                      AppStyles.primary,
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
            ),
            label: const Text(
              'Ajouter au panier',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppStyles.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}