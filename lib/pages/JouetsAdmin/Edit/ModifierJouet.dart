import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tolon/controller/jouetsAdmin/jouets_controller.dart';

import 'package:tolon/models/JouetsAdmin/jouet_list_model.dart';

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

  String? categorieSelectionnee;

  final List<String> categories = [
    'Éducatif',
    'Construction',
    'Puzzle',
    'Peluches',
    'Véhicules',
    'Jeux de société',
    'Créatif',
  ];

  List<TextEditingController> beneficesControllers = [];

  List<String> anciennesImages = [];

  @override
  void initState() {
    super.initState();

    controller = JouetController(
      repository: JouetRepository(),
    );

    nomController.text = widget.jouet.nom;

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

    if (categories.contains(widget.jouet.categorie)) {
      categorieSelectionnee =
          widget.jouet.categorie;
    } else {
      categorieSelectionnee = null;
    }

    anciennesImages =
    List<String>.from(widget.jouet.images);

    for (String benefice in widget.jouet.benefices) {
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
  }

  void ajouterChampBenefice() {
    setState(() {
      beneficesControllers.add(
        TextEditingController(),
      );
    });
  }

  void supprimerBenefice(int index) {
    setState(() {
      beneficesControllers[index].dispose();
      beneficesControllers.removeAt(index);
    });
  }

  Future<void> selectionnerImages() async {
    await controller.selectionnerImages();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  void supprimerImage(int index) {
    setState(() {
      controller.supprimerImage(index);
    });
  }

  void supprimerAncienneImage(int index) {
    setState(() {
      anciennesImages.removeAt(index);
    });
  }

  Future<void> modifierJouet() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (categorieSelectionnee == null) {
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
      if (beneficeController.text.trim().isNotEmpty) {
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
        nom: nomController.text.trim(),
        categorie: categorieSelectionnee!,
        ageMinimum: ageMinimum,
        ageMaximum: ageMaximum,
        prix: prix,
        stock: stock,
        description:
        descriptionController.text.trim(),
        benefices: benefices,
        anciennesImages: anciennesImages,
        nouvellesImages:
        controller.imagesSelectionnees,
      );

      if (!mounted) {
        return;
      }

      afficherMessage(
        'Jouet modifié avec succès',
      );

      Navigator.pop(context);

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
      backgroundColor:
      const Color(0xFFFAFFFB),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 18,
            ),

            child: Form(
              key: formKey,

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
                              'Modifier un jouet',

                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            SizedBox(
                              height: 4,
                            ),

                            Text(
                              'Modifiez les informations\n'
                                  'du jouet',

                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: 100,
                        height: 75,

                        child: Image.asset(
                          'assets/images/JouetHeader.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),

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
                              .withOpacity(0.15),

                          blurRadius: 7,

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
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

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

                          categorieSelectionnee:
                          categorieSelectionnee,

                          categories:
                          categories,

                          onCategorieChanged:
                              (value) {
                            setState(() {
                              categorieSelectionnee =
                                  value;
                            });
                          },
                        ),

                        const SizedBox(
                          height: 15,
                        ),

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

                        const SizedBox(
                          height: 15,
                        ),

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

                  const SizedBox(
                    height: 14,
                  ),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      SizedBox(
                        width: 120,
                        height: 42,

                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },

                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFFF0F0F0),

                            foregroundColor:
                            Colors.black,

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                          ),

                          child: const Text(
                            'Annuler',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        width: 35,
                      ),

                      SizedBox(
                        width: 120,
                        height: 42,

                        child: ElevatedButton(
                          onPressed:
                          modifierJouet,

                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFFE98219),

                            foregroundColor:
                            Colors.white,

                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                          ),

                          child: const Text(
                            'Modifier',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
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