import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tolon/cor/app_colors.dart';
import 'package:tolon/models/admin_model/tutoriel_model.dart';
import 'package:tolon/repository/adminRepository/tutoriel_repository.dart';
import 'package:tolon/pages/Admins/Tutos_widgets/chargement_fichiers_tuto.dart';
import 'package:tolon/pages/Admins/Tutos_widgets/formulaire_text_tuto.dart';

class AjoutTuto extends ConsumerStatefulWidget {
  final TutorielModel? tutoriel;
  const AjoutTuto({this.tutoriel, super.key});

  @override
  ConsumerState<AjoutTuto> createState() => _AjoutTutoState();
}

class _AjoutTutoState extends ConsumerState<AjoutTuto> {
  int _currentStep = 0;
  bool _isLoading = false;

  late TextEditingController _titreController;
  late TextEditingController _ageMinController;
  late TextEditingController _ageMaxController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    // On pré-remplit les champs si on est en mode Modification
    _titreController = TextEditingController(
      text: widget.tutoriel?.titre ?? '',
    );
    _ageMinController = TextEditingController(
      text: widget.tutoriel?.ageMin.toString() ?? '',
    );
    _ageMaxController = TextEditingController(
      text: widget.tutoriel?.ageMax.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.tutoriel?.description ?? '',
    );
  }

  File? _videoFile;
  File? _imageFile;

  Future<void> _choisirVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.single.path != null) {
      setState(() => _videoFile = File(result.files.single.path!));
    }
  }

  Future<void> _choisirImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() => _imageFile = File(result.files.single.path!));
    }
  }

  // L'AIGUILLAGE PARFAIT ENTRE AJOUT ET MODIFICATION
  Future<void> _soumettreFormulaire() async {

     //VÉRIFICATION DES FICHIERS (Uniquement en mode création)
  if (widget.tutoriel == null) {
    if (_videoFile == null) {
      _afficherAlerte('Veuillez sélectionner un fichier vidéo MP4.');
      return;
    }
    if (_imageFile == null) {
      _afficherAlerte('Veuillez sélectionner une image de couverture.');
      return;
    }
  }
    setState(() => _isLoading = true);

    try {
      if (widget.tutoriel != null) {
        // MODE MODIFICATION (L'objet existe déjà)
        final tutoMisAJour = TutorielModel(
          id: widget.tutoriel!.id, //
          titre: _titreController.text.trim(),
          description: _descriptionController.text.trim(),
          ageMin: int.tryParse(_ageMinController.text) ?? 0,
          ageMax: int.tryParse(_ageMaxController.text) ?? 0,
          dateCreation: widget.tutoriel!.dateCreation,
          videoUrl: widget.tutoriel!.videoUrl,
          imageVideoUrl: widget.tutoriel!.imageVideoUrl,
          categorieId: widget.tutoriel!.categorieId,
        );

        // Appel de la méthode de mise à jour de votre Repository
        await ref
            .read(tutorielRepositoryProvider)
            .modifierTutoriel(tuto: tutoMisAJour);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tutoriel modifié avec succès'),
              backgroundColor: AppColors.greenPrimary,
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        // MODE NOUVEL AJOUT (Code Supabase initial)
        if (_videoFile == null || _imageFile == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Veuillez charger tous les fichiers.'),
            ),
          );
          return;
        }

        final dummyTuto = TutorielModel(
          id: '',
          titre: _titreController.text.trim(),
          description: _descriptionController.text.trim(),
          ageMin: int.tryParse(_ageMinController.text) ?? 0,
          ageMax: int.tryParse(_ageMaxController.text) ?? 0,
          dateCreation: DateTime.now(),
          videoUrl: '',
          imageVideoUrl: '',
          categorieId: 'cat_eveil_1',
        );

        await ref
            .read(tutorielRepositoryProvider)
            .ajouterTutoriel(
              tuto: dummyTuto,
              videoFile: _videoFile!,
              imageVideoFile: _imageFile!,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tutoriel publié avec succès !'),
              backgroundColor: AppColors.greenPrimary,
            ),
          );
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Fonctions d'aide pour alléger le code
void _afficherAlerte(String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.greenPrimary));
}


  @override
  Widget build(BuildContext context) {
    final bool isEdition = widget.tutoriel != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.textDark,
          ),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          isEdition ? 'Modifier un tutoriel' : 'Ajouter un tutoriel',
          style: const TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.greenPrimary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  _buildHeaderIllustration(),
                  const SizedBox(height: 24),

                  // SWITCH DES WIDGETS DÉCOUPÉS ET ÉPURÉS
                  _currentStep == 0
                      ? FormulaireTexteTuto(
                          titreController: _titreController,
                          ageMinController: _ageMinController,
                          ageMaxController: _ageMaxController,
                          descriptionController: _descriptionController,
                          onSuivant: () => setState(() => _currentStep = 1),
                        )
                      : ChargementFichiersTuto(
                          videoFile: _videoFile,
                          imageFile: _imageFile,
                          existingVideoUrl: widget.tutoriel?.videoUrl,
                          existingImageUrl: widget.tutoriel?.imageVideoUrl,
                          isEdition:
                              widget.tutoriel !=
                              null, // Passe à true si on modifie, false si c'est un ajout
                          onChoisirVideo: _choisirVideo,
                          onChoisirImage: _choisirImage,
                          onAjouter: _soumettreFormulaire,
                        ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderIllustration() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/imageAjoutTuto.png',
            height: 120,
            fit: BoxFit.contain,
            errorBuilder: (c, e, s) => const Icon(
              Icons.laptop_chromebook_rounded,
              size: 100,
              color: AppColors.greenPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Partagez un nouveau tutoriel éducatif avec les utilisateurs',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 14,
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titreController.dispose();
    _ageMinController.dispose();
    _ageMaxController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
