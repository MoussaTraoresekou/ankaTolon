import 'package:flutter/material.dart';

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

  String? categorieIdSelectionnee;

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

    categorieIdSelectionnee =
        widget.jouet.categorieId;

    anciennesImages =
    List<String>.from(
      widget.jouet.images,
    );

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
        nom: nomController.text.trim(),
        categorieId:
        categorieIdSelectionnee!,
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
    final double largeurEcran =
        MediaQuery.of(context).size.width;

    final double largeurContenu =
    largeurEcran > 1200
        ? 1100
        : largeurEcran - 40;

    return Scaffold(
      backgroundColor:
      const Color(0xFFFAFFFB),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: largeurContenu,
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),

                child: Form(
                  key: formKey,

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                    children: [
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,

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

                          const SizedBox(
                            width: 8,
                          ),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [
                                Text(
                                  'Modifier un jouet',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                SizedBox(
                                  height: 5,
                                ),

                                Text(
                                  'Modifiez les informations du jouet',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            width: 130,
                            height: 90,

                            child: Image.asset(
                              'assets/images/JouetHeader.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      Container(
                        width: double.infinity,

                        padding:
                        const EdgeInsets.all(24),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                          BorderRadius.circular(14),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.10),

                              blurRadius: 10,

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

                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(
                              height: 18,
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

                            const SizedBox(
                              height: 25,
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
                              height: 25,
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
                        height: 18,
                      ),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.end,

                        children: [
                          SizedBox(
                            width: 130,
                            height: 45,

                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
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
                                    10,
                                  ),
                                ),
                              ),

                              child: const Text(
                                'Annuler',

                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 15,
                          ),

                          SizedBox(
                            width: 130,
                            height: 45,

                            child: ElevatedButton(
                              onPressed:
                              modifierJouet,

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
                                    10,
                                  ),
                                ),
                              ),

                              child: const Text(
                                'Modifier',

                                style: TextStyle(
                                  fontSize: 14,
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