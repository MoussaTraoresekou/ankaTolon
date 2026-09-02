import 'package:image_picker/image_picker.dart';

import 'package:tolon/models/JouetsAdmin/add_jouet_models.dart';
import 'package:tolon/models/JouetsAdmin/jouet_list_model.dart';

import 'package:tolon/repository/JouetsAdmin/JouetsRepository.dart';

class JouetController {
  final JouetRepository repository;

  JouetController({required this.repository});


  List<Jouet> jouets = [];
  List<XFile> imagesSelectionnees = [];

  // selection d'images


  Future<void> selectionnerImages() async {
    final ImagePicker picker = ImagePicker();

    final List<XFile> images = await picker.pickMultiImage();

    if (images.isEmpty) {
      return;
    }

    imagesSelectionnees.addAll(images);
  }


  void supprimerImage(int index) {
    imagesSelectionnees.removeAt(index);
  }

  void viderImages() {
    imagesSelectionnees.clear();
  }


  Future<void> ajouterJouet({
    required String nom,

    required String categorieId,

    required int ageMinimum,

    required int ageMaximum,

    required double prix,

    required int stock,

    required String description,

    required List<String> benefices,
  }) async {
    if (ageMinimum < 4 || ageMinimum > 12) {
      throw Exception('L’âge minimum doit être entre 4 et 12 ans');
    }

    if (ageMaximum < 4 || ageMaximum > 12) {
      throw Exception('L’âge maximum doit être entre 4 et 12 ans');
    }

    if (ageMinimum > ageMaximum) {
      throw Exception(
        'L’âge minimum ne peut pas être supérieur '
            'à l’âge maximum',
      );
    }


    List<String> imageUrls = [];

    for (XFile image in imagesSelectionnees) {
      final String url = await repository.uploadImage(image);

      imageUrls.add(url);
    }


    final JouetModel jouet = JouetModel(
      nom: nom,


      categorieId: categorieId,


      ageMinimum: ageMinimum,
      ageMaximum: ageMaximum,
      prix: prix,
      stock: stock,
      description: description,
      benefices: benefices,
      images: imageUrls,
    );


    await repository.ajouterJouet(
      jouet,
    );

    // enregistre un jouet

    await repository.ajouterJouet(jouet);


    imagesSelectionnees.clear();
  }


  Future<void> chargerJouets() async {
    jouets = await repository.getJouets();
  }


  Future<void> supprimerJouet(String id,) async {

      await repository.supprimerJouet(id);

      await chargerJouets();
    }


    Future<void> modifierJouet({
      required String id,
      required String nom,


      required String categorieId,




      required int ageMinimum,
      required int ageMaximum,
      required double prix,
      required int stock,
      required String description,
      required List<String> benefices,
      required List<String> anciennesImages,
      required List<XFile> nouvellesImages,
    }) async {
      if (ageMinimum < 4 || ageMinimum > 12) {
        throw Exception('L’âge minimum doit être entre 4 et 12 ans');
      }

      if (ageMaximum < 4 || ageMaximum > 12) {
        throw Exception('L’âge maximum doit être entre 4 et 12 ans');
      }

      if (ageMinimum > ageMaximum) {
        throw Exception(
          'L’âge minimum ne peut pas être supérieur '
              'à l’âge maximum',
        );
      }


      await repository.modifierJouet(
        id: id,
        nom: nom,

        categorieId: categorieId,


        ageMinimum: ageMinimum,
        ageMaximum: ageMaximum,
        prix: prix,
        stock: stock,
        description: description,
        benefices: benefices,
        anciennesImages: anciennesImages,
        nouvellesImages: nouvellesImages,
      );


      imagesSelectionnees.clear();

      await chargerJouets();
    }
  }
