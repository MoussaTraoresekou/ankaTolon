import 'package:flutter/material.dart';

import 'package:tolon/controller/jouetsAdmin/jouets_controller.dart';
import 'package:tolon/models/JouetsAdmin/jouet_list_model.dart';
import 'package:tolon/models/categorieAdmin/categorie_model.dart';

import 'package:tolon/repository/JouetsAdmin/JouetsRepository.dart';
import 'package:tolon/repository/categorieAdminRepository/categorie_repository.dart';

import 'package:tolon/pages/JouetsAdmin/Edit/ModifierJouet.dart';
import 'package:tolon/pages/JouetsAdmin/AddJouets.dart';

class ListeJouetsPage extends StatefulWidget {
  const ListeJouetsPage({
    super.key,
  });

  @override
  State<ListeJouetsPage> createState() =>
      _ListeJouetsPageState();
}

class _ListeJouetsPageState
    extends State<ListeJouetsPage> {

  late JouetController controller;

  late CategorieRepository categorieRepository;

  List<Categorie> categories = [];

  bool chargement = true;

  String? erreur;

  final TextEditingController rechercheController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = JouetController(
      repository: JouetRepository(),
    );

    categorieRepository = CategorieRepository();

    chargerDonnees();
  }

  Future<void> chargerDonnees() async {
    try {
      setState(() {
        chargement = true;
        erreur = null;
      });

      await controller.chargerJouets();

      categories =
      await categorieRepository.recupererCategories();

      if (!mounted) {
        return;
      }

      setState(() {
        chargement = false;
      });
    } catch (e) {
      print('ERREUR : $e');

      if (!mounted) {
        return;
      }

      setState(() {
        chargement = false;
        erreur = 'Erreur lors du chargement des données';
      });
    }
  }

  String trouverNomCategorie(String categorieId) {
    for (Categorie categorie in categories) {
      if (categorie.id == categorieId) {
        return categorie.nom;
      }
    }

    return 'Catégorie inconnue';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFFFB),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 20,
          ),

          child: Column(
            children: [

              // EN-TÊTE

              Row(
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(
                          'Liste des jouets',

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        Text(
                          'Gérez tous les jouets ajoutés',

                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: 80,
                    height: 70,

                    child: Image.asset(
                      'assets/images/JouetHeader.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 12,
              ),

              // RECHERCHE + AJOUTER

              Row(
                children: [

                  Expanded(
                    child: SizedBox(
                      height: 38,

                      child: TextField(
                        controller:
                        rechercheController,

                        decoration:
                        InputDecoration(
                          hintText:
                          'Rechercher un jouet',

                          hintStyle:
                          const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),

                          prefixIcon:
                          const Icon(
                            Icons.search,
                            size: 17,
                          ),

                          contentPadding:
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),

                          border:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(6),

                            borderSide:
                            BorderSide(
                              color:
                              Colors.grey[300]!,
                            ),
                          ),

                          enabledBorder:
                          OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(6),

                            borderSide:
                            BorderSide(
                              color:
                              Colors.grey[300]!,
                            ),
                          ),
                        ),

                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  SizedBox(
                    height: 38,

                    child: ElevatedButton(
                      onPressed: () async {

                        await Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) =>
                            const AjouterJouetPage(),
                          ),
                        );

                        await chargerDonnees();
                      },

                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFFE98219),

                        foregroundColor:
                        Colors.white,

                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),

                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(6),
                        ),

                        elevation: 0,
                      ),

                      child: const Text(
                        'Ajouter',

                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 10,
              ),

              // LISTE

              Expanded(
                child: construireListe(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget construireListe() {

    if (chargement) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (erreur != null) {
      return Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.error,
              color: Colors.red,
              size: 40,
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              erreur!,

              style: const TextStyle(
                fontSize: 13,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            ElevatedButton(
              onPressed: chargerDonnees,

              child: const Text(
                'Réessayer',
              ),
            ),
          ],
        ),
      );
    }

    final String texteRecherche =
    rechercheController.text.toLowerCase();

    final List<Jouet> jouetsFiltres =
    controller.jouets.where((jouet) {

      final String nom =
      jouet.nom.toLowerCase();

      final String categorie =
      trouverNomCategorie(
        jouet.categorieId,
      ).toLowerCase();

      return nom.contains(
        texteRecherche,
      ) ||
          categorie.contains(
            texteRecherche,
          );
    }).toList();

    if (jouetsFiltres.isEmpty) {
      return const Center(
        child: Text(
          'Aucun jouet trouvé',

          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.10),

            blurRadius: 8,

            offset:
            const Offset(0, 3),
          ),
        ],

        borderRadius:
        BorderRadius.circular(8),
      ),

      child: Column(
        children: [

          // EN-TÊTE DU TABLEAU

          Container(
            height: 42,

            decoration:
            const BoxDecoration(
              color: Color(0xFF7FC28C),

              borderRadius:
              BorderRadius.only(
                topLeft:
                Radius.circular(8),

                topRight:
                Radius.circular(8),
              ),
            ),

            child: Row(
              children: [

                // IMAGE

                const SizedBox(
                  width: 65,
                ),

                // CATÉGORIE

                const Expanded(
                  flex: 3,

                  child: Center(
                    child: Text(
                      'Catégorie',

                      style: TextStyle(
                        color:
                        Colors.white,

                        fontSize: 11,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ÂGE

                const Expanded(
                  flex: 2,

                  child: Center(
                    child: Text(
                      'Âge',

                      style: TextStyle(
                        color:
                        Colors.white,

                        fontSize: 11,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // PRIX

                const Expanded(
                  flex: 2,

                  child: Center(
                    child: Text(
                      'Prix',

                      style: TextStyle(
                        color:
                        Colors.white,

                        fontSize: 11,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ACTIONS

                const SizedBox(
                  width: 90,

                  child: Center(
                    child: Text(
                      'Actions',

                      style: TextStyle(
                        color:
                        Colors.white,

                        fontSize: 11,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // CORPS DU TABLEAU

          Expanded(
            child: ListView.builder(
              itemCount:
              jouetsFiltres.length,

              itemBuilder:
                  (context, index) {

                final Jouet jouet =
                jouetsFiltres[index];

                return construireLigne(
                  jouet,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget construireLigne(Jouet jouet) {

    return Container(
      height: 85,

      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
      ),

      child: Row(
        children: [

          // IMAGE

          SizedBox(
            width: 65,

            child: Padding(
              padding:
              const EdgeInsets.all(5),

              child:
              construireImage(jouet),
            ),
          ),

          // CATÉGORIE

          Expanded(
            flex: 3,

            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 4,
              ),

              child: Center(
                child: Text(
                  trouverNomCategorie(
                    jouet.categorieId,
                  ),

                  textAlign:
                  TextAlign.center,

                  maxLines: 2,

                  overflow:
                  TextOverflow.ellipsis,

                  style:
                  const TextStyle(
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),

          // ÂGE

          Expanded(
            flex: 2,

            child: Center(
              child: Text(
                '${jouet.ageMinimum}-${jouet.ageMaximum} ans',

                textAlign:
                TextAlign.center,

                style:
                const TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
          ),

          // PRIX

          Expanded(
            flex: 2,

            child: Center(
              child: Text(
                '${jouet.prix.toInt()} FCFA',

                textAlign:
                TextAlign.center,

                maxLines: 1,

                overflow:
                TextOverflow.ellipsis,

                style:
                const TextStyle(
                  fontSize: 11,

                  fontWeight:
                  FontWeight.w500,
                ),
              ),
            ),
          ),

          // ACTIONS

          SizedBox(
            width: 90,

            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                IconButton(
                  padding:
                  EdgeInsets.zero,

                  constraints:
                  const BoxConstraints(
                    minWidth: 35,
                    minHeight: 35,
                  ),

                  onPressed: () async {

                    await Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder:
                            (context) =>
                            ModifierJouetPage(
                              jouet: jouet,
                            ),
                      ),
                    );

                    await chargerDonnees();
                  },

                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 19,
                  ),
                ),

                IconButton(
                  padding:
                  EdgeInsets.zero,

                  constraints:
                  const BoxConstraints(
                    minWidth: 35,
                    minHeight: 35,
                  ),

                  onPressed: () {

                    supprimerJouet(
                      jouet.id,
                    );
                  },

                  icon: const Icon(
                    Icons.delete_outline,
                    size: 19,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget construireImage(Jouet jouet) {

    if (jouet.images.isEmpty) {

      return Container(
        width: 45,
        height: 65,

        color:
        Colors.grey[200],

        child: const Icon(
          Icons.toys,
          size: 25,
        ),
      );
    }

    return ClipRRect(
      borderRadius:
      BorderRadius.circular(4),

      child: Image.network(
        jouet.images[0],

        width: 45,
        height: 65,

        fit: BoxFit.contain,

        errorBuilder:
            (context, error, stackTrace) {

          return Container(
            width: 45,
            height: 65,

            color:
            Colors.grey[200],

            child: const Icon(
              Icons.broken_image,
              size: 25,
            ),
          );
        },
      ),
    );
  }

  Future<void> supprimerJouet(
      String id) async {

    try {

      await controller.supprimerJouet(
        id,
      );

      if (!mounted) {
        return;
      }

      setState(() {});

    } catch (e) {

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Erreur : $e',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {

    rechercheController.dispose();

    super.dispose();
  }
}