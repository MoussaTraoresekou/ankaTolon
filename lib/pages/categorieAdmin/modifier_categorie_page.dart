import 'package:flutter/material.dart';

import 'package:tolon/controller/categorieAdmin/categorie_controller.dart';
import 'package:tolon/models/categorieAdmin/categorie_model.dart';

class ModifierCategoriePage extends StatefulWidget {

  final Categorie categorie;

  const ModifierCategoriePage({
    super.key,
    required this.categorie,
  });

  @override
  State<ModifierCategoriePage> createState() =>
      _ModifierCategoriePageState();
}

class _ModifierCategoriePageState
    extends State<ModifierCategoriePage> {

  final CategorieController controller =
  CategorieController();

  final GlobalKey<FormState> formKey =
  GlobalKey<FormState>();

  late TextEditingController nomController;

  String? typeSelectionne;

  @override
  void initState() {
    super.initState();

    nomController = TextEditingController(
      text: widget.categorie.nom,
    );

    typeSelectionne =
        widget.categorie.type;
  }

  Future<void> modifierCategorie() async {

    if (!formKey.currentState!.validate()) {
      return;
    }

    try {

      await controller.modifierCategorie(
        widget.categorie.id,
        nomController.text.trim(),
        typeSelectionne!,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Catégorie modifiée avec succès',
          ),
        ),
      );

      Navigator.pop(context);

    } catch (e) {

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur : $e',
          ),
        ),
      );
    }
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
                              'Modifier la catégorie',

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
                                  'de la catégorie',

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
                          'Informations de la catégorie',

                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),



                        const Text(
                          'ID de la catégorie',

                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        Container(
                          width: double.infinity,

                          padding:
                          const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: Colors.grey[100],

                            borderRadius:
                            BorderRadius.circular(8),

                            border: Border.all(
                              color:
                              Colors.grey[300]!,
                            ),
                          ),

                          child: Text(
                            widget.categorie.id,
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),


                        TextFormField(
                          controller:
                          nomController,

                          decoration:
                          const InputDecoration(
                            labelText:
                            'Nom de la catégorie',

                            hintText:
                            'Exemple : Motricité',

                            border:
                            OutlineInputBorder(),
                          ),

                          validator: (value) {

                            if (value == null ||
                                value.trim().isEmpty) {

                              return
                                'Veuillez entrer le nom';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(
                          height: 15,
                        ),



                        DropdownButtonFormField<String>(
                          value: typeSelectionne,

                          decoration:
                          const InputDecoration(
                            labelText: 'Type',

                            border:
                            OutlineInputBorder(),
                          ),

                          items: const [

                            DropdownMenuItem(
                              value: 'Activité',

                              child: Text(
                                'Activité',
                              ),
                            ),

                            DropdownMenuItem(
                              value: 'Quiz',

                              child: Text(
                                'Quiz',
                              ),
                            ),
                          ],

                          onChanged: (value) {

                            setState(() {
                              typeSelectionne =
                                  value;
                            });
                          },

                          validator: (value) {

                            if (value == null ||
                                value.isEmpty) {

                              return
                                'Veuillez choisir le type';
                            }

                            return null;
                          },
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

                          child: const Text(
                            'Annuler',
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 120,
                        height: 42,

                        child: ElevatedButton(
                          onPressed:
                          modifierCategorie,

                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(
                              0xFFE98219,
                            ),

                            foregroundColor:
                            Colors.white,
                          ),

                          child: const Text(
                            'Modifier',
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

    super.dispose();
  }
}