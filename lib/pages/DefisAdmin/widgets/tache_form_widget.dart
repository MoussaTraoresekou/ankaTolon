import 'package:flutter/material.dart';

import 'package:tolon/models/categorieAdmin/categorie_model.dart';

class TacheFormWidget extends StatelessWidget {

  final String? type;
  final String? categorie;
  final String nombre;

  final List<Categorie> categories;

  final Function(String?) onTypeChanged;
  final Function(String?) onCategorieChanged;
  final Function(String) onNombreChanged;

  final VoidCallback onSupprimer;

  const TacheFormWidget({
    super.key,

    required this.type,
    required this.categorie,
    required this.nombre,

    required this.categories,

    required this.onTypeChanged,
    required this.onCategorieChanged,
    required this.onNombreChanged,

    required this.onSupprimer,
  });

  @override
  Widget build(BuildContext context) {

    // =====================================================
    // FILTRER LES CATEGORIES SELON LE TYPE
    // =====================================================

    List<Categorie> categoriesFiltrees = [];

    if (type != null) {

      String typeChoisi =
      type!.toLowerCase().trim();

      categoriesFiltrees =
          categories.where((categorie) {

            String typeCategorie =
            categorie.type
                .toLowerCase()
                .trim();

            // ACTIVITE
            if (typeChoisi == "activité" ||
                typeChoisi == "activite") {

              return typeCategorie == "activité" ||
                  typeCategorie == "activite";
            }

            // QUIZ
            if (typeChoisi == "quiz") {

              return typeCategorie == "quiz";
            }

            return false;

          }).toList();
    }

    // =====================================================
    // FORMULAIRE
    // =====================================================

    return Container(

      width:
      double.infinity,

      margin:
      const EdgeInsets.only(
        bottom:
        10,
      ),

      padding:
      const EdgeInsets.all(
        8,
      ),

      decoration:
      BoxDecoration(

        color:
        Colors.white,

        borderRadius:
        BorderRadius.circular(
          8,
        ),

        border:
        Border.all(
          color:
          const Color(0xFFA8D5B5),
        ),
      ),

      child: Row(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          // =================================================
          // CONTENU
          // =================================================

          Expanded(

            child: Column(

              children: [

                Row(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    // =======================================
                    // TYPE
                    // =======================================

                    Expanded(

                      flex:
                      3,

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Text(

                            "Type :",

                            style:
                            TextStyle(
                              fontSize:
                              11,

                              color:
                              Colors.grey,
                            ),
                          ),

                          const SizedBox(
                            height:
                            3,
                          ),

                          SizedBox(

                            height:
                            34,

                            child:
                            DropdownButtonFormField<String>(

                              value:
                              type,

                              isExpanded:
                              true,

                              decoration:
                              InputDecoration(

                                contentPadding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal:
                                  7,

                                  vertical:
                                  0,
                                ),

                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    6,
                                  ),
                                ),
                              ),

                              hint:
                              const Text(

                                "Type",

                                style:
                                TextStyle(
                                  fontSize:
                                  12,
                                ),
                              ),

                              items:
                              const [

                                DropdownMenuItem(

                                  value:
                                  "activité",

                                  child:
                                  Text(
                                    "Activité",

                                    style:
                                    TextStyle(
                                      fontSize:
                                      12,
                                    ),
                                  ),
                                ),

                                DropdownMenuItem(

                                  value:
                                  "quiz",

                                  child:
                                  Text(
                                    "Quiz",

                                    style:
                                    TextStyle(
                                      fontSize:
                                      12,
                                    ),
                                  ),
                                ),
                              ],

                              onChanged:
                              onTypeChanged,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      width:
                      5,
                    ),

                    // =======================================
                    // CATEGORIE
                    // =======================================

                    Expanded(

                      flex:
                      4,

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Text(

                            "Catégorie :",

                            style:
                            TextStyle(
                              fontSize:
                              11,

                              color:
                              Colors.grey,
                            ),
                          ),

                          const SizedBox(
                            height:
                            3,
                          ),

                          SizedBox(

                            height:
                            34,

                            child:
                            DropdownButtonFormField<String>(

                              value:
                              categoriesFiltrees.any(
                                    (c) =>
                                c.id ==
                                    categorie,
                              )
                                  ? categorie
                                  : null,

                              isExpanded:
                              true,

                              decoration:
                              InputDecoration(

                                contentPadding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal:
                                  7,

                                  vertical:
                                  0,
                                ),

                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    6,
                                  ),
                                ),
                              ),

                              hint:
                              Text(

                                type == null
                                    ? "Catégorie"
                                    : "Choisir",

                                style:
                                const TextStyle(
                                  fontSize:
                                  12,
                                ),
                              ),

                              items:
                              categoriesFiltrees
                                  .map(
                                    (categorie) {

                                  return
                                    DropdownMenuItem<String>(

                                      value:
                                      categorie.id,

                                      child:
                                      Text(

                                        categorie.nom,

                                        overflow:
                                        TextOverflow
                                            .ellipsis,

                                        style:
                                        const TextStyle(
                                          fontSize:
                                          12,
                                        ),
                                      ),
                                    );
                                },
                              ).toList(),

                              onChanged:
                              categoriesFiltrees
                                  .isEmpty
                                  ? null
                                  : onCategorieChanged,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      width:
                      5,
                    ),

                    // =======================================
                    // NOMBRE
                    // =======================================

                    SizedBox(

                      width:
                      60,

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Text(

                            "Nbre :",

                            style:
                            TextStyle(
                              fontSize:
                              11,

                              color:
                              Colors.grey,
                            ),
                          ),

                          const SizedBox(
                            height:
                            3,
                          ),

                          SizedBox(

                            height:
                            34,

                            child:
                            TextFormField(

                              initialValue:
                              nombre,

                              keyboardType:
                              TextInputType.number,

                              onChanged:
                              onNombreChanged,

                              decoration:
                              InputDecoration(

                                contentPadding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal:
                                  7,

                                  vertical:
                                  0,
                                ),

                                border:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    6,
                                  ),
                                ),
                              ),

                              style:
                              const TextStyle(
                                fontSize:
                                12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // =================================================
          // BOUTON SUPPRIMER
          // =================================================

          SizedBox(

            width:
            28,

            child:
            IconButton(

              onPressed:
              onSupprimer,

              padding:
              EdgeInsets.zero,

              constraints:
              const BoxConstraints(),

              icon:
              const Icon(

                Icons.close,

                color:
                Colors.red,

                size:
                21,
              ),
            ),
          ),
        ],
      ),
    );
  }
}