import 'package:flutter/material.dart';

import 'package:tolon/controller/categorieAdmin/categorie_controller.dart';

class AjouterCategoriePage extends StatefulWidget {
  const AjouterCategoriePage({
    super.key,
  });

  @override
  State<AjouterCategoriePage> createState() =>
      _AjouterCategoriePageState();
}

class _AjouterCategoriePageState
    extends State<AjouterCategoriePage> {

  // Controller
  final CategorieController controller =
  CategorieController();

  // Controller du champ nom
  final TextEditingController nomController =
  TextEditingController();

  final GlobalKey<FormState> formKey =
  GlobalKey<FormState>();

  // ajout d'une categorie

  Future<void> ajouterCategorie() async {

    if (!formKey.currentState!.validate()) {
      return;
    }

    try {

      await controller.ajouterCategorie(
        nomController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Catégorie ajoutée avec succès',
          ),
        ),
      );

      // redirection vers la liste
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

                      // Titre
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Text(
                              'Ajouter une catégorie',

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
                              'Renseignez les informations\n'
                                  'de la nouvelle catégorie',

                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Image
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

                        TextFormField(
                          controller:
                          nomController,

                          decoration:
                          const InputDecoration(
                            labelText:
                            'Nom de la catégorie',

                            hintText:
                            'Exemple : Éducatif',

                            border:
                            OutlineInputBorder(),
                          ),

                          validator: (value) {

                            if (value == null ||
                                value.trim().isEmpty) {

                              return
                                'Veuillez entrer le nom de la catégorie';
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
                          ajouterCategorie,

                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(
                                0xFFE98219),

                            foregroundColor:
                            Colors.white,
                          ),

                          child: const Text(
                            'Ajouter',
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