import 'package:flutter/material.dart';

import 'package:tolon/controller/jouetsAdmin/jouets_controller.dart';
import 'package:tolon/cor/theme/app_theme.dart';

import 'package:tolon/repository/JouetsAdmin/JouetsRepository.dart';

import 'package:tolon/pages/JouetsAdmin/Add/informations_jouets.dart';
import 'package:tolon/pages/JouetsAdmin/Add/images_jouet.dart';
import 'package:tolon/pages/JouetsAdmin/Add/benefices_jouet.dart';

class AjouterJouetPage extends StatefulWidget {
  const AjouterJouetPage({super.key});

  @override
  State<AjouterJouetPage> createState() => _AjouterJouetPageState();
}

class _AjouterJouetPageState extends State<AjouterJouetPage> {
  late JouetController controller;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nomController = TextEditingController();

  final TextEditingController ageMinimumController = TextEditingController();

  final TextEditingController ageMaximumController = TextEditingController();

  final TextEditingController prixController = TextEditingController();

  final TextEditingController stockController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

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

  List<TextEditingController> beneficesControllers = [TextEditingController()];

  @override
  void initState() {
    super.initState();

    controller = JouetController(repository: JouetRepository());
  }

  void ajouterChampBenefice() {
    setState(() {
      beneficesControllers.add(TextEditingController());
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

  Future<void> ajouterJouet() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (categorieSelectionnee == null) {
      afficherMessage('Veuillez sélectionner une catégorie');
      return;
    }

    if (controller.imagesSelectionnees.isEmpty) {
      afficherMessage('Veuillez sélectionner au moins une image');
      return;
    }

    final int ageMinimum = int.parse(ageMinimumController.text.trim());

    final int ageMaximum = int.parse(ageMaximumController.text.trim());

    final double prix = double.parse(prixController.text.trim());

    final int stock = int.parse(stockController.text.trim());

    List<String> benefices = [];

    for (TextEditingController beneficeController in beneficesControllers) {
      if (beneficeController.text.trim().isNotEmpty) {
        benefices.add(beneficeController.text.trim());
      }
    }

    if (benefices.isEmpty) {
      afficherMessage('Veuillez ajouter au moins un bénéfice');
      return;
    }

    try {
      await controller.ajouterJouet(
        nom: nomController.text.trim(),
        categorie: categorieSelectionnee!,
        ageMinimum: ageMinimum,
        ageMaximum: ageMaximum,
        prix: prix,
        stock: stock,
        description: descriptionController.text.trim(),
        benefices: benefices,
      );

      if (!mounted) {
        return;
      }

      afficherMessage('Jouet ajouté avec succès');

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }

      afficherMessage('Erreur : $e');
    }
  }

  void afficherMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFFFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
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
                        icon: Icon(Icons.arrow_back_ios, size: 16),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ajouter un jouet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Renseignez les informations\n'
                              'du nouveau jouet',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppStyles.textMuted,
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
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppStyles.textInverse,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppStyles.shadowColor,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informations du jouet',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        InformationsJouet(
                          nomController: nomController,
                          ageMinimumController: ageMinimumController,
                          ageMaximumController: ageMaximumController,
                          prixController: prixController,
                          stockController: stockController,
                          descriptionController: descriptionController,
                          categorieSelectionnee: categorieSelectionnee,
                          categories: categories,
                          onCategorieChanged: (value) {
                            setState(() {
                              categorieSelectionnee = value;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        ImagesJouet(
                          images: controller.imagesSelectionnees,
                          selectionnerImages: selectionnerImages,
                          supprimerImage: supprimerImage,
                        ),
                        const SizedBox(height: 12),
                        BeneficesJouet(
                          controllers: beneficesControllers,
                          ajouterBenefice: ajouterChampBenefice,
                          supprimerBenefice: supprimerBenefice,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Annuler'),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: ajouterJouet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE98219),
                            foregroundColor: AppStyles.textInverse,
                          ),
                          child: const Text('Ajouter'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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

    for (TextEditingController controller in beneficesControllers) {
      controller.dispose();
    }

    super.dispose();
  }
}
