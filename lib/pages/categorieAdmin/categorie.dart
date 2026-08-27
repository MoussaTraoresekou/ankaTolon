import 'package:flutter/material.dart';

import 'package:tolon/controller/categorieAdmin/categorie_controller.dart';
import 'package:tolon/models/categorieAdmin/categorie_model.dart';

import 'package:tolon/pages/categorieAdmin/ajouter_categorie_page.dart';
import 'package:tolon/pages/categorieAdmin/modifier_categorie_page.dart';

class CategoriePage extends StatefulWidget {
  const CategoriePage({
    super.key,
  });

  @override
  State<CategoriePage> createState() =>
      _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {
  final CategorieController controller =
  CategorieController();

  List<Categorie> categories = [];

  bool chargement = true;

  @override
  void initState() {
    super.initState();

    afficherCategories();
  }

  Future<void> afficherCategories() async {
    try {
      List<Categorie> resultat =
      await controller.afficherCategories();

      if (!mounted) {
        return;
      }

      setState(() {
        categories = resultat;
        chargement = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        chargement = false;
      });

      afficherMessage(
        'Erreur : $e',
      );
    }
  }

  Future<void> supprimerCategorie(
      Categorie categorie,
      ) async {
    try {
      await controller.supprimerCategorie(
        categorie.id,
      );

      await afficherCategories();

      if (!mounted) {
        return;
      }

      afficherMessage(
        'Catégorie supprimée avec succès',
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      afficherMessage(
        'Erreur : $e',
      );
    }
  }

  void afficherMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFFFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 18,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                    ),
                  ),

                  const SizedBox(
                    width: 5,
                  ),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catégories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(
                          height: 4,
                        ),

                        Text(
                          'Gérez les catégories de vos jouets',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const AjouterCategoriePage(),
                        ),
                      ).then((value) {
                        afficherCategories();
                      });
                    },
                    icon: const Icon(
                      Icons.add,
                      size: 18,
                    ),
                    label: const Text(
                      'Ajouter',
                    ),
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFFE98219),
                      foregroundColor:
                      Colors.white,
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.10),
                        blurRadius: 6,
                        offset:
                        const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.category_outlined,
                            size: 20,
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          const Text(
                            'Liste des catégories',
                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const Spacer(),
                        ],
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      if (chargement)
                        const Expanded(
                          child: Center(
                            child:
                            CircularProgressIndicator(),
                          ),
                        )
                      else if (categories.isEmpty)
                        const Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                              children: [
                                Icon(
                                  Icons
                                      .category_outlined,
                                  size: 50,
                                  color: Colors.grey,
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                Text(
                                  'Aucune catégorie',
                                  style: TextStyle(
                                    color:
                                    Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child:
                          ListView.builder(
                            itemCount:
                            categories.length,
                            itemBuilder:
                                (context, index) {
                              Categorie categorie =
                              categories[index];

                              return Container(
                                margin:
                                const EdgeInsets
                                    .only(
                                  bottom: 10,
                                ),
                                padding:
                                const EdgeInsets
                                    .all(12),
                                decoration:
                                BoxDecoration(
                                  color:
                                  const Color(
                                    0xFFFAFFFB,
                                  ),
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                    10,
                                  ),
                                  border:
                                  Border.all(
                                    color: Colors.grey
                                        .withOpacity(
                                      0.20,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      alignment:
                                      Alignment
                                          .center,
                                      decoration:
                                      BoxDecoration(
                                        color:
                                        const Color(
                                          0xFFFFF0E0,
                                        ),
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                          8,
                                        ),
                                      ),
                                      child: Text(
                                        '${index + 1}',
                                        style:
                                        const TextStyle(
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                          color:
                                          Color(
                                            0xFFE98219,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 12,
                                    ),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            categorie
                                                .nom,
                                            style:
                                            const TextStyle(
                                              fontSize:
                                              15,
                                              fontWeight:
                                              FontWeight
                                                  .bold,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 4,
                                          ),

                                          Text(
                                            'ID : ${categorie.id}',
                                            style:
                                            const TextStyle(
                                              fontSize:
                                              11,
                                              color:
                                              Colors
                                                  .grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                ModifierCategoriePage(
                                                  categorie:
                                                  categorie,
                                                ),
                                          ),
                                        ).then((value) {
                                          afficherCategories();
                                        });
                                      },
                                      icon:
                                      const Icon(
                                        Icons
                                            .edit_outlined,
                                        size: 20,
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        supprimerCategorie(
                                          categorie,
                                        );
                                      },
                                      icon:
                                      const Icon(
                                        Icons
                                            .delete_outline,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}