import 'package:flutter/material.dart';

import 'package:tolon/controller/categorieAdmin/categorie_controller.dart';
import 'package:tolon/controller/jouetsAdmin/jouets_controller.dart';

import 'package:tolon/models/JouetsAdmin/jouet_list_model.dart';
import 'package:tolon/models/categorieAdmin/categorie_model.dart';

import 'package:tolon/repository/JouetsAdmin/JouetsRepository.dart';

import 'package:tolon/pages/JouetsAdmin/Edit/widgets/modifier_informations.dart';
import 'package:tolon/pages/JouetsAdmin/Edit/widgets/modifier_images.dart';
import 'package:tolon/pages/JouetsAdmin/Edit/widgets/modifier_benefices.dart';

class ModifierJouetPage extends StatefulWidget {
  final Jouet jouet;

  const ModifierJouetPage({
    super.key,
    required this.jouet,
  });

  @override
  State<ModifierJouetPage> createState() =>
      _ModifierJouetPageState();
}

class _ModifierJouetPageState
    extends State<ModifierJouetPage> {
  late JouetController controller;

  final CategorieController categorieController =
  CategorieController();

  final GlobalKey<FormState> formKey =
  GlobalKey<FormState>();

  final TextEditingController nomController =
  TextEditingController();

  final TextEditingController ageMinimumController =
  TextEditingController();

  final TextEditingController ageMaximumController =
  TextEditingController();

  final TextEditingController prixController =
  TextEditingController();

  final TextEditingController stockController =
  TextEditingController();

  final TextEditingController descriptionController =
  TextEditingController();

  String? categorieIdSelectionnee;

  List<Categorie> categories = [];

  bool chargementCategories = true;

  List<TextEditingController>
  beneficesControllers = [];

  List<String> anciennesImages = [];

  @override
  void initState() {
    super.initState();

    controller = JouetController(
      repository: JouetRepository(),
    );



    nomController.text =
        widget.jouet.nom;

    ageMinimumController.text =
        widget.jouet.ageMinimum.toString();

    ageMaximumController.text =
        widget.jouet.ageMaximum.toString();

    prixController.text =
        widget.jouet.prix.toString();

    stockController.text =
        widget.jouet.stock.toString();

    descriptionController.text =
        widget.jouet.description;

    categorieIdSelectionnee =
        widget.jouet.categorieId;

    anciennesImages =
    List<String>.from(
      widget.jouet.images,
    );



    for (
    String benefice
    in widget.jouet.benefices
    ) {
      beneficesControllers.add(
        TextEditingController(
          text: benefice,
        ),
      );
    }

    if (beneficesControllers.isEmpty) {
      beneficesControllers.add(
        TextEditingController(),
      );
    }

    chargerCategories();
  }


  Future<void> chargerCategories() async {
    try {
      final List<Categorie> resultat =
      await categorieController
          .afficherCategories();

      if (!mounted) return;

      setState(() {
        categories = resultat;
        chargementCategories = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        chargementCategories = false;
      });

      afficherMessage(
        'Erreur catégories : $e',
      );
    }
  }


  void ajouterChampBenefice() {
    setState(() {
      beneficesControllers.add(
        TextEditingController(),
      );
    });
  }

  void supprimerBenefice(
      int index,
      ) {
    setState(() {
      beneficesControllers[index]
          .dispose();

      beneficesControllers
          .removeAt(index);
    });
  }


  Future<void> selectionnerImages() async {
    await controller.selectionnerImages();

    if (!mounted) return;

    setState(() {});
  }

  void supprimerImage(int index) {
    setState(() {
      controller.supprimerImage(index);
    });
  }

  void supprimerAncienneImage(
      int index,
      ) {
    setState(() {
      anciennesImages.removeAt(index);
    });
  }


  Future<void> modifierJouet() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (categorieIdSelectionnee == null) {
      afficherMessage(
        'Veuillez sélectionner une catégorie',
      );

      return;
    }

    final int ageMinimum =
    int.parse(
      ageMinimumController.text.trim(),
    );

    final int ageMaximum =
    int.parse(
      ageMaximumController.text.trim(),
    );

    final double prix =
    double.parse(
      prixController.text.trim(),
    );

    final int stock =
    int.parse(
      stockController.text.trim(),
    );

    List<String> benefices = [];

    for (
    TextEditingController beneficeController
    in beneficesControllers
    ) {
      if (beneficeController.text
          .trim()
          .isNotEmpty) {
        benefices.add(
          beneficeController.text.trim(),
        );
      }
    }

    if (benefices.isEmpty) {
      afficherMessage(
        'Veuillez ajouter au moins un bénéfice',
      );

      return;
    }

    try {
      await controller.modifierJouet(
        id: widget.jouet.id,

        nom:
        nomController.text.trim(),

        categorieId:
        categorieIdSelectionnee!,

        ageMinimum:
        ageMinimum,

        ageMaximum:
        ageMaximum,

        prix:
        prix,

        stock:
        stock,

        description:
        descriptionController.text.trim(),

        benefices:
        benefices,

        anciennesImages:
        anciennesImages,

        nouvellesImages:
        controller.imagesSelectionnees,
      );

      if (!mounted) return;

      afficherMessage(
        'Jouet modifié avec succès',
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      afficherMessage(
        'Erreur : $e',
      );
    }
  }



  void afficherMessage(
      String message,
      ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFFAFFFB),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),

          child: Form(
            key: formKey,

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,

              children: [


                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 18,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'Modifier un jouet',

                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Modifiez les informations du jouet',

                            style: TextStyle(
                              fontSize: 11,
                              color:
                              Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: 70,
                      height: 60,

                      child: Image.asset(
                        'assets/images/JouetHeader.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),



                Container(
                  width: double.infinity,

                  padding:
                  const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius:
                    BorderRadius.circular(10),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: 0.10),

                        blurRadius: 8,

                        offset:
                        const Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      const Text(
                        'Informations du jouet',

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),



                      if (chargementCategories)
                        const Center(
                          child:
                          CircularProgressIndicator(),
                        )
                      else
                        ModifierInformations(
                          nomController:
                          nomController,

                          ageMinimumController:
                          ageMinimumController,

                          ageMaximumController:
                          ageMaximumController,

                          prixController:
                          prixController,

                          stockController:
                          stockController,

                          descriptionController:
                          descriptionController,

                          categorieIdSelectionnee:
                          categorieIdSelectionnee,

                          categories:
                          categories,

                          onCategorieChanged:
                              (value) {
                            setState(() {
                              categorieIdSelectionnee =
                                  value;
                            });
                          },
                        ),

                      const SizedBox(height: 20),



                      ModifierImages(
                        anciennesImages:
                        anciennesImages,

                        nouvellesImages:
                        controller
                            .imagesSelectionnees,

                        ajouterImages:
                        selectionnerImages,

                        supprimerAncienneImage:
                        supprimerAncienneImage,

                        supprimerNouvelleImage:
                        supprimerImage,
                      ),

                      const SizedBox(height: 20),



                      ModifierBenefices(
                        controllers:
                        beneficesControllers,

                        ajouterBenefice:
                        ajouterChampBenefice,

                        supprimerBenefice:
                        supprimerBenefice,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),



                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,

                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                            );
                          },

                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(
                              0xFFF0F0F0,
                            ),

                            foregroundColor:
                            Colors.black,

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                            ),
                          ),

                          child: const Text(
                            'Annuler',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: SizedBox(
                        height: 45,

                        child: ElevatedButton(
                          onPressed:
                          chargementCategories
                              ? null
                              : modifierJouet,

                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(
                              0xFFE98219,
                            ),

                            foregroundColor:
                            Colors.white,

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                            ),
                          ),

                          child: const Text(
                            'Modifier',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nomController.dispose();

    ageMinimumController.dispose();

    ageMaximumController.dispose();

    prixController.dispose();

    stockController.dispose();

    descriptionController.dispose();

    for (
    TextEditingController controller
    in beneficesControllers
    ) {
      controller.dispose();
    }

    super.dispose();
  }
}