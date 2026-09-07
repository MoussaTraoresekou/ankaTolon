import 'package:flutter/material.dart';

import 'package:tolon/controller/defis/defi_controller.dart';
import 'package:tolon/models/defis/defi_model.dart';

import 'package:tolon/pages/DefisAdmin/widgets/champ_defi.dart';
import 'package:tolon/pages/DefisAdmin/widgets/tache_form_widget.dart';

class ModifierDefiPage extends StatefulWidget {
  final Defi defi;

  const ModifierDefiPage({
    super.key,
    required this.defi,
  });

  @override
  State<ModifierDefiPage> createState() =>
      _ModifierDefiPageState();
}

class _ModifierDefiPageState extends State<ModifierDefiPage> {


  final DefiController controller =
  DefiController();


  final TextEditingController titreController =
  TextEditingController();

  final TextEditingController descriptionController =
  TextEditingController();



  final TextEditingController dureeController =
  TextEditingController();



  int ageMin = 4;

  int ageMax = 12;


  List<Map<String, dynamic>> taches = [];



  @override
  void initState() {
    super.initState();



    titreController.text =
        widget.defi.titre;



    descriptionController.text =
        widget.defi.description;



    ageMin =
        widget.defi.ageMin.clamp(4, 12);



    ageMax =
        widget.defi.ageMax.clamp(4, 12);



    dureeController.text =
        widget.defi.dureeValidite.toString();



    for (final activite
    in widget.defi.activites) {

      taches.add({
        'type': 'activité',
        'categorie': activite.categorieId,
        'nombre': activite.nombre.toString(),
      });
    }



    for (final quiz
    in widget.defi.quiz) {

      taches.add({
        'type': 'quiz',
        'categorie': quiz.categorieId,
        'nombre': quiz.nombre.toString(),
      });
    }



    if (taches.isEmpty) {

      taches.add({
        'type': null,
        'categorie': null,
        'nombre': '1',
      });
    }


    controller.chargerCategories();
  }


  @override
  void dispose() {

    titreController.dispose();

    descriptionController.dispose();

    dureeController.dispose();

    controller.dispose();

    super.dispose();
  }


  void afficherMessage(String message) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }



  void ajouterTache() {

    setState(() {

      taches.add({
        'type': null,
        'categorie': null,
        'nombre': '1',
      });
    });
  }



  void supprimerTache(int index) {

    setState(() {

      taches.removeAt(index);

      if (taches.isEmpty) {

        taches.add({
          'type': null,
          'categorie': null,
          'nombre': '1',
        });
      }
    });
  }


  Future<void> enregistrerModification() async {

    if (titreController.text
        .trim()
        .isEmpty) {

      afficherMessage(
        "Veuillez saisir le titre du défi",
      );

      return;
    }



    if (descriptionController.text
        .trim()
        .isEmpty) {

      afficherMessage(
        "Veuillez saisir la description du défi",
      );

      return;
    }



    if (ageMin < 4 ||
        ageMin > 12 ||
        ageMax < 4 ||
        ageMax > 12) {

      afficherMessage(
        "Les âges doivent être compris entre 4 et 12 ans",
      );

      return;
    }

    if (ageMin > ageMax) {

      afficherMessage(
        "L'âge minimum doit être inférieur à l'âge maximum",
      );

      return;
    }

    final int? duree =
    int.tryParse(
      dureeController.text.trim(),
    );

    if (duree == null ||
        duree <= 0) {

      afficherMessage(
        "Veuillez saisir une durée valide en heures",
      );

      return;
    }



    List<TacheDefi> activites = [];

    List<TacheDefi> quiz = [];



    for (
    int i = 0;
    i < taches.length;
    i++
    ) {

      final tache =
      taches[i];



      String? type;

      if (tache['type'] != null) {

        type =
            tache['type'].toString();
      }



      String? categorieId;

      if (tache['categorie'] != null) {

        categorieId =
            tache['categorie'].toString();
      }



      int nombre =
          int.tryParse(
            tache['nombre']
                ?.toString() ??
                '1',
          ) ??
              1;


      if (type == null ||
          type.isEmpty) {

        afficherMessage(
          "Veuillez sélectionner le type de la tâche ${i + 1}",
        );

        return;
      }



      if (categorieId == null ||
          categorieId.isEmpty) {

        afficherMessage(
          "Veuillez sélectionner la catégorie de la tâche ${i + 1}",
        );

        return;
      }


      if (nombre <= 0) {

        afficherMessage(
          "Le nombre doit être supérieur à 0",
        );

        return;
      }



      final nouvelleTache =
      TacheDefi(
        categorieId: categorieId,
        nombre: nombre,
      );



      if (type == "activité" ||
          type == "activite") {

        activites.add(
          nouvelleTache,
        );
      }



      else if (type == "quiz") {

        quiz.add(
          nouvelleTache,
        );
      }
    }



    final Defi defiModifie =
    Defi(
      id: widget.defi.id,

      titre:
      titreController.text.trim(),

      description:
      descriptionController.text.trim(),

      dateAjout:
      widget.defi.dateAjout,

      ageMin:
      ageMin,

      ageMax:
      ageMax,

      dureeValidite:
      duree,

      activites:
      activites,

      quiz:
      quiz,
    );



    try {

      await controller.modifierDefi(
        defiModifie,
      );

      if (!mounted) {
        return;
      }



      if (controller.erreur != null) {

        afficherMessage(
          controller.erreur!,
        );

        return;
      }


      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Défi modifié avec succès",
          ),
        ),
      );

      Navigator.pop(
        context,
        true,
      );

    } catch (e) {

      if (!mounted) {
        return;
      }

      afficherMessage(
        "Erreur lors de la modification : $e",
      );
    }
  }



  @override
  Widget build(
      BuildContext context) {

    return Scaffold(



      backgroundColor:
      const Color(0xFFF7FAF8),


      appBar: AppBar(

        backgroundColor:
        Colors.white,

        elevation: 0,

        centerTitle: true,

        leading: IconButton(

          onPressed: () {

            Navigator.pop(
              context,
            );
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF263746),
          ),
        ),

        title: const Text(
          "Modifier un défi",

          style: TextStyle(
            color: Color(0xFF263746),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),


      body: SafeArea(

        child: AnimatedBuilder(

          animation:
          controller,

          builder:
              (context, child) {

            if (controller.isLoading &&
                controller.categories.isEmpty) {

              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(

              padding:
              const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                30,
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [


                  Center(

                    child: Container(

                      height: 100,

                      width: 150,

                      padding:
                      const EdgeInsets.all(8),

                      decoration: BoxDecoration(

                        color:
                        Colors.white,

                        borderRadius:
                        BorderRadius.circular(16),

                        border: Border.all(
                          color:
                          const Color(0xFFE1EEE5),
                        ),
                      ),

                      child: Image.asset(
                        "assets/images/header_Defis.png",

                        fit:
                        BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),


                  const Center(

                    child: Text(
                      "Modifiez les informations de votre défi",

                      textAlign:
                      TextAlign.center,

                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF68757D),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 22,
                  ),



                  Container(

                    width:
                    double.infinity,

                    padding:
                    const EdgeInsets.all(18),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white,

                      borderRadius:
                      BorderRadius.circular(14),

                      border:
                      Border.all(
                        color:
                        const Color(0xFFDCEBE0),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.black
                              .withValues(alpha: 0.04),

                          blurRadius:
                          8,

                          offset:
                          const Offset(
                            0,
                            3,
                          ),
                        ),
                      ],
                    ),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [



                        Row(

                          children: [

                            Container(

                              padding:
                              const EdgeInsets.all(8),

                              decoration:
                              BoxDecoration(

                                color:
                                const Color(
                                  0xFFFFF1E3,
                                ),

                                borderRadius:
                                BorderRadius.circular(
                                  8,
                                ),
                              ),

                              child:
                              const Icon(
                                Icons.edit_note,

                                color:
                                Color(0xFFE98219),

                                size:
                                22,
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            const Expanded(

                              child: Text(
                                "Informations du défi",

                                style: TextStyle(
                                  fontSize: 17,

                                  fontWeight:
                                  FontWeight.bold,

                                  color:
                                  Color(0xFF263746),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        const Text(
                          "Modifiez les informations principales du défi.",

                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7A8791),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),


                        const Text(
                          "Titre du défi",

                          style: TextStyle(
                            fontSize: 14,

                            fontWeight:
                            FontWeight.w600,

                            color:
                            Color(0xFF263746),
                          ),
                        ),

                        const SizedBox(
                          height: 7,
                        ),

                        ChampDefi(
                          label: "",
                          hint:
                          "Ex : Dessiner une maison",
                          controller:
                          titreController,
                        ),

                        const SizedBox(
                          height: 18,
                        ),



                        const Text(
                          "Description du défi",

                          style: TextStyle(
                            fontSize: 14,

                            fontWeight:
                            FontWeight.w600,

                            color:
                            Color(0xFF263746),
                          ),
                        ),

                        const SizedBox(
                          height: 7,
                        ),

                        ChampDefi(
                          label: "",
                          hint:
                          "Décrivez ce que l'enfant doit réaliser...",
                          controller:
                          descriptionController,
                          maxLines: 4,
                        ),

                        const SizedBox(
                          height: 20,
                        ),


                        const Text(
                          "Tranche d'âge",

                          style: TextStyle(
                            fontSize: 14,

                            fontWeight:
                            FontWeight.w600,

                            color:
                            Color(0xFF263746),
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        const Text(
                          "Choisissez l'âge minimum et maximum des enfants.",

                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7A8791),
                          ),
                        ),

                        const SizedBox(
                          height: 9,
                        ),

                        Row(

                          children: [

                            Expanded(

                              child:
                              DropdownButtonFormField<int>(

                                initialValue:
                                ageMin,

                                decoration:
                                InputDecoration(

                                  labelText:
                                  "Âge minimum",

                                  filled:
                                  true,

                                  fillColor:
                                  const Color(
                                    0xFFFAFFFB,
                                  ),

                                  labelStyle:
                                  const TextStyle(
                                    color:
                                    Color(
                                      0xFF52606D,
                                    ),
                                  ),

                                  border:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                      8,
                                    ),
                                  ),

                                  enabledBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                      8,
                                    ),

                                    borderSide:
                                    const BorderSide(
                                      color:
                                      Color(
                                        0xFFA8D5B5,
                                      ),
                                    ),
                                  ),

                                  focusedBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                      8,
                                    ),

                                    borderSide:
                                    const BorderSide(
                                      color:
                                      Color(
                                        0xFFE98219,
                                      ),

                                      width:
                                      1.5,
                                    ),
                                  ),

                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                    horizontal:
                                    12,

                                    vertical:
                                    12,
                                  ),
                                ),

                                items:
                                List.generate(
                                  9,
                                      (index) {

                                    final age =
                                        index + 4;

                                    return DropdownMenuItem<int>(
                                      value:
                                      age,

                                      child:
                                      Text(
                                        "$age ans",

                                        style:
                                        const TextStyle(
                                          color:
                                          Color(
                                            0xFF263746,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                onChanged:
                                    (value) {

                                  if (value ==
                                      null) {
                                    return;
                                  }

                                  setState(() {
                                    ageMin =
                                        value;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(
                              width: 12,
                            ),

                            // AGE MAXIMUM
                            Expanded(

                              child:
                              DropdownButtonFormField<int>(

                                initialValue:
                                ageMax,

                                decoration:
                                InputDecoration(

                                  labelText:
                                  "Âge maximum",

                                  filled:
                                  true,

                                  fillColor:
                                  const Color(
                                    0xFFFAFFFB,
                                  ),

                                  labelStyle:
                                  const TextStyle(
                                    color:
                                    Color(
                                      0xFF52606D,
                                    ),
                                  ),

                                  border:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                      8,
                                    ),
                                  ),

                                  enabledBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                      8,
                                    ),

                                    borderSide:
                                    const BorderSide(
                                      color:
                                      Color(
                                        0xFFA8D5B5,
                                      ),
                                    ),
                                  ),

                                  focusedBorder:
                                  OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(
                                      8,
                                    ),

                                    borderSide:
                                    const BorderSide(
                                      color:
                                      Color(
                                        0xFFE98219,
                                      ),

                                      width:
                                      1.5,
                                    ),
                                  ),

                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                    horizontal:
                                    12,

                                    vertical:
                                    12,
                                  ),
                                ),

                                items:
                                List.generate(
                                  9,
                                      (index) {

                                    final age =
                                        index + 4;

                                    return DropdownMenuItem<int>(
                                      value:
                                      age,

                                      child:
                                      Text(
                                        "$age ans",

                                        style:
                                        const TextStyle(
                                          color:
                                          Color(
                                            0xFF263746,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                onChanged:
                                    (value) {

                                  if (value ==
                                      null) {
                                    return;
                                  }

                                  setState(() {
                                    ageMax =
                                        value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),


                        const Text(
                          "Durée de validité",

                          style: TextStyle(
                            fontSize: 14,

                            fontWeight:
                            FontWeight.w600,

                            color:
                            Color(0xFF263746),
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        const Text(
                          "Indiquez pendant combien d'heures le défi reste disponible.",

                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7A8791),
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        TextField(

                          controller:
                          dureeController,

                          keyboardType:
                          TextInputType.number,

                          style:
                          const TextStyle(
                            color:
                            Color(0xFF263746),

                            fontSize:
                            14,

                            fontWeight:
                            FontWeight.w500,
                          ),

                          decoration:
                          InputDecoration(

                            hintText:
                            "Exemple : 24",

                            suffixText:
                            "heures",

                            hintStyle:
                            const TextStyle(
                              color:
                              Colors.grey,

                              fontSize:
                              13,
                            ),

                            suffixStyle:
                            const TextStyle(
                              color:
                              Color(
                                0xFF52606D,
                              ),

                              fontSize:
                              13,

                              fontWeight:
                              FontWeight.w600,
                            ),

                            filled:
                            true,

                            fillColor:
                            const Color(
                              0xFFFAFFFB,
                            ),

                            border:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(
                                8,
                              ),
                            ),

                            enabledBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(
                                8,
                              ),

                              borderSide:
                              const BorderSide(
                                color:
                                Color(
                                  0xFFA8D5B5,
                                ),
                              ),
                            ),

                            focusedBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(
                                8,
                              ),

                              borderSide:
                              const BorderSide(
                                color:
                                Color(
                                  0xFFE98219,
                                ),

                                width:
                                1.5,
                              ),
                            ),

                            contentPadding:
                            const EdgeInsets.symmetric(
                              horizontal:
                              12,

                              vertical:
                              12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),



                  Container(

                    width:
                    double.infinity,

                    padding:
                    const EdgeInsets.all(18),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white,

                      borderRadius:
                      BorderRadius.circular(14),

                      border:
                      Border.all(
                        color:
                        const Color(0xFFDCEBE0),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.black
                              .withValues(alpha: 0.04),

                          blurRadius:
                          8,

                          offset:
                          const Offset(
                            0,
                            3,
                          ),
                        ),
                      ],
                    ),

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [


                        Row(

                          children: [

                            Container(

                              padding:
                              const EdgeInsets.all(8),

                              decoration:
                              BoxDecoration(

                                color:
                                const Color(
                                  0xFFEAF7EE,
                                ),

                                borderRadius:
                                BorderRadius.circular(
                                  8,
                                ),
                              ),

                              child:
                              const Icon(
                                Icons.checklist,

                                color:
                                Color(
                                  0xFF4CAF50,
                                ),

                                size:
                                22,
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            const Expanded(

                              child: Text(
                                "Liste des tâches",

                                style: TextStyle(
                                  fontSize: 17,

                                  fontWeight:
                                  FontWeight.bold,

                                  color:
                                  Color(
                                    0xFF263746,
                                  ),
                                ),
                              ),
                            ),

                            OutlinedButton.icon(

                              onPressed:
                              ajouterTache,

                              icon:
                              const Icon(
                                Icons.add,

                                size:
                                17,

                                color:
                                Color(
                                  0xFFE98219,
                                ),
                              ),

                              label:
                              const Text(
                                "Ajouter",

                                style:
                                TextStyle(
                                  fontSize:
                                  12,

                                  color:
                                  Color(
                                    0xFFE98219,
                                  ),

                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),

                              style:
                              OutlinedButton.styleFrom(

                                minimumSize:
                                const Size(
                                  0,
                                  36,
                                ),

                                padding:
                                const EdgeInsets.symmetric(
                                  horizontal:
                                  10,
                                ),

                                side:
                                const BorderSide(
                                  color:
                                  Color(
                                    0xFFE98219,
                                  ),
                                ),

                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    7,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 7,
                        ),

                        const Text(
                          "Ajoutez les activités et les quiz qui composent ce défi.",

                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7A8791),
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),


                        Column(

                          children: [

                            for (
                            int i = 0;
                            i < taches.length;
                            i++
                            )

                              Container(

                                width:
                                double.infinity,

                                margin:
                                const EdgeInsets.only(
                                  bottom:
                                  12,
                                ),

                                padding:
                                const EdgeInsets.all(
                                  13,
                                ),

                                decoration:
                                BoxDecoration(

                                  color:
                                  const Color(
                                    0xFFFAFFFB,
                                  ),

                                  borderRadius:
                                  BorderRadius.circular(
                                    10,
                                  ),

                                  border:
                                  Border.all(
                                    color:
                                    const Color(
                                      0xFFE1EEE5,
                                    ),
                                  ),
                                ),

                                child:
                                Column(

                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: [


                                    Row(

                                      children: [

                                        Container(

                                          height:
                                          30,

                                          width:
                                          30,

                                          alignment:
                                          Alignment.center,

                                          decoration:
                                          BoxDecoration(

                                            color:
                                            const Color(
                                              0xFFE98219,
                                            ),

                                            borderRadius:
                                            BorderRadius.circular(
                                              50,
                                            ),
                                          ),

                                          child:
                                          Text(
                                            "${i + 1}",

                                            style:
                                            const TextStyle(
                                              color:
                                              Colors.white,

                                              fontWeight:
                                              FontWeight.bold,

                                              fontSize:
                                              13,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(
                                          width: 9,
                                        ),

                                        Text(
                                          "Tâche ${i + 1}",

                                          style:
                                          const TextStyle(
                                            fontSize:
                                            14,

                                            fontWeight:
                                            FontWeight.w600,

                                            color:
                                            Color(
                                              0xFF263746,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 12,
                                    ),



                                    TacheFormWidget(

                                      type:
                                      taches[i]
                                      ['type'],

                                      categorie:
                                      taches[i]
                                      ['categorie'],

                                      nombre:
                                      taches[i]
                                      ['nombre']
                                          .toString(),

                                      categories:
                                      controller
                                          .categories,

                                      onTypeChanged:
                                          (value) {

                                        setState(() {

                                          taches[i]
                                          ['type'] =
                                              value;

                                          taches[i]
                                          ['categorie'] =
                                          null;
                                        });
                                      },

                                      onCategorieChanged:
                                          (value) {

                                        setState(() {

                                          taches[i]
                                          ['categorie'] =
                                              value;
                                        });
                                      },

                                      onNombreChanged:
                                          (value) {

                                        setState(() {

                                          taches[i]
                                          ['nombre'] =
                                              value;
                                        });
                                      },

                                      onSupprimer:
                                          () {

                                        supprimerTache(
                                          i,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),



                  Center(

                    child:
                    SizedBox(

                      width:
                      double.infinity,

                      height:
                      50,

                      child:
                      ElevatedButton.icon(

                        onPressed:
                        controller.isLoading
                            ? null
                            : enregistrerModification,

                        icon:
                        controller.isLoading

                            ? const SizedBox(
                          height: 20,
                          width: 20,

                          child:
                          CircularProgressIndicator(
                            strokeWidth:
                            2,

                            color:
                            Colors.white,
                          ),
                        )

                            : const Icon(
                          Icons.save_outlined,
                        ),

                        label:
                        Text(
                          controller.isLoading
                              ? "Modification en cours..."
                              : "Enregistrer les modifications",

                          style:
                          const TextStyle(
                            fontSize:
                            15,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        style:
                        ElevatedButton.styleFrom(

                          backgroundColor:
                          const Color(
                            0xFFE98219,
                          ),

                          foregroundColor:
                          Colors.white,

                          elevation:
                          1,

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),



                  const Center(

                    child: Text(
                      "Vérifiez les informations avant d'enregistrer.",

                      textAlign:
                      TextAlign.center,

                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF89959D),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}