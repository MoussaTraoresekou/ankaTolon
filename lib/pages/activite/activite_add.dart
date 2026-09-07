import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tolon/commun_widget/custom_text_field.dart';
import 'package:tolon/controller/activite_controller/activite_controller.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/async_value_ui.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/models/activites/activite_model.dart';
import 'package:tolon/models/categorie/categorie_model.dart';
import 'package:tolon/repository/categorie_repo/category_repository.dart';

class AddActiviteScreen extends ConsumerStatefulWidget {
  const AddActiviteScreen({super.key});

  @override
  ConsumerState<AddActiviteScreen> createState() => _AddActiviteScreenState();
}

class _AddActiviteScreenState extends ConsumerState<AddActiviteScreen> {
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dureeController = TextEditingController();
  final _ageMinController = TextEditingController();
  final _ageMaxController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  CategorieModel? _categorieSelectionnee;

  File? _selectedImage;
  File? _selectedVideo;

  int _currentPage = 0;

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    _dureeController.dispose();
    _ageMinController.dispose();
    _ageMaxController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

    if (video == null) return;

    setState(() {
      _selectedVideo = File(video.path);
    });
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _removeVideo() {
    setState(() {
      _selectedVideo = null;
    });
  }

  bool _validerPage1() {
    return ref
        .read(activiteControllerProvider.notifier)
        .validerActivite(
          titre: _titreController.text,
          description: _descriptionController.text,
          ageMinText: _ageMinController.text,
          ageMaxText: _ageMaxController.text,
          dureeText: _dureeController.text,
          categorie: _categorieSelectionnee,
        );
  }

  void _goToNextPage() {
    if (!_validerPage1()) {
      return;
    }

    setState(() {
      _currentPage = 1;
    });
  }

  void _goToPreviousPage() {
    setState(() {
      _currentPage = 0;
    });
  }

  Future<void> _ajouterActivite() async {
    final controller = ref.read(activiteControllerProvider.notifier);

    final validation = controller.validerActivite(
      titre: _titreController.text,
      description: _descriptionController.text,
      ageMinText: _ageMinController.text,
      ageMaxText: _ageMaxController.text,
      dureeText: _dureeController.text,
      categorie: _categorieSelectionnee,
    );

    if (!validation) {
      setState(() {
        _currentPage = 0;
      });
      return;
    }

    final categorie = _categorieSelectionnee!;

    final activite = ActiviteModel(
      id: '',
      titre: _titreController.text.trim(),
      description: _descriptionController.text.trim(),
      categorieId: FirebaseFirestore.instance
          .collection('categories')
          .doc(categorie.id),
      image: null,
      videoUrl: null,
      dureeMinutes: int.parse(_dureeController.text.trim()),
      ageMin: int.parse(_ageMinController.text.trim()),
      ageMax: int.parse(_ageMaxController.text.trim()),
      dateCreation: DateTime.now(),
    );

    final success = await controller.ajouterActivite(
      activite,
      image: _selectedImage,
      video: _selectedVideo,
    );

    if (!mounted) return;

    if (success) {
      final state = ref.read(activiteControllerProvider);

      state.showSuccessDialog(context, 'Activité ajoutée avec succès !', () {
        context.pop();
      });
    }
  }

  Widget _buildFormImage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 15),
        child: Image.asset(
          'assets/images/activite_form.png',
          height: 120,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildPage1InfosGenerales() {
    final categoriesAsync = ref.watch(listeCategoryByTypeProvider('activite'));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormImage(),

          SizedBox(height: SizeConfig.getProportionateHeight(10)),

          CustomTextField(
            label: 'Titre',
            hintText: 'Ex : Apprendre les couleurs',
            controller: _titreController,
            prefixIcon: Icons.title_rounded,
          ),

          SizedBox(height: SizeConfig.getProportionateHeight(15)),

          CustomTextField(
            label: 'Description',
            hintText: 'Décrivez l’activité',
            controller: _descriptionController,
            maxLines: 4,
            prefixIcon: Icons.description_outlined,
          ),

          SizedBox(height: SizeConfig.getProportionateHeight(15)),

          Text('Catégorie', style: context.normalTextStyle),

          SizedBox(height: SizeConfig.getProportionateHeight(8)),

          categoriesAsync.when(
            loading: () => Container(
              height: 55,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.boxSurfaceLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: context.primaryOrange,
                ),
              ),
            ),
            error: (error, stack) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Erreur lors du chargement des catégories.'),
            ),
            data: (categories) {
              if (categories.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: context.boxSurfaceLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Aucune catégorie disponible.',
                    style: TextStyle(color: context.textMuted, fontSize: 13),
                  ),
                );
              }

              return DropdownButtonFormField<CategorieModel>(
                value: _categorieSelectionnee,
                decoration: InputDecoration(
                  hintText: 'Sélectionnez une catégorie',
                  prefixIcon: Icon(
                    Icons.category_outlined,
                    color: context.iconColor,
                  ),
                  filled: true,
                  fillColor: context.boxSurfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: context.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: context.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: context.primaryOrange,
                      width: 1.5,
                    ),
                  ),
                ),
                items: categories.map((categorie) {
                  return DropdownMenuItem<CategorieModel>(
                    value: categorie,
                    child: Text(
                      categorie.nom,
                      style: TextStyle(color: context.textDark),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categorieSelectionnee = value;
                  });
                },
              );
            },
          ),

          SizedBox(height: SizeConfig.getProportionateHeight(15)),
          SizedBox(height: SizeConfig.getProportionateHeight(8)),

          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Âge minimum',
                  hintText: 'Ex : 3',
                  controller: _ageMinController,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: SizeConfig.getProportionateWidth(12)),
              Expanded(
                child: CustomTextField(
                  label: 'Âge maximum',
                  hintText: 'Ex : 6',
                  controller: _ageMaxController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.getProportionateHeight(15)),

          CustomTextField(
            label: 'Durée en minutes',
            hintText: 'Ex : 15',
            controller: _dureeController,
            keyboardType: TextInputType.number,
            prefixIcon: Icons.timer_outlined,
          ),

          SizedBox(height: SizeConfig.getProportionateHeight(20)),
        ],
      ),
    );
  }

  Widget _buildPage2Medias() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormImage(),

          SizedBox(height: SizeConfig.getProportionateHeight(25)),

          Text(
            'Image',
            style: TextStyle(
              color: context.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: SizeConfig.getProportionateHeight(8)),

          _buildImagePicker(),

          SizedBox(height: SizeConfig.getProportionateHeight(22)),

          Text(
            'Vidéo',
            style: TextStyle(
              color: context.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: SizeConfig.getProportionateHeight(8)),

          _buildVideoPicker(),

          SizedBox(height: SizeConfig.getProportionateHeight(20)),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    if (_selectedImage != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.file(
              _selectedImage!,
              width: double.infinity,
              height: 210,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            left: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Image sélectionnée',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 10,
            right: 10,
            child: _buildRemoveButton(onTap: _removeImage),
          ),
        ],
      );
    }

    return _buildMediaEmptyCard(
      icon: Icons.image_outlined,
      title: 'Ajouter une image',
      subtitle: 'Choisissez une image pour illustrer l’activité',
      onTap: _pickImage,
    );
  }

  Widget _buildVideoPicker() {
    if (_selectedVideo != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.boxSurfaceLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: context.borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: context.avatarOrangeBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                Icons.video_file_rounded,
                color: context.primaryOrange,
                size: 27,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vidéo sélectionnée',
                    style: TextStyle(
                      color: context.textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    _selectedVideo!.path.split('/').last,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),

            _buildRemoveButton(onTap: _removeVideo),
          ],
        ),
      );
    }

    return _buildMediaEmptyCard(
      icon: Icons.video_library_outlined,
      title: 'Ajouter une vidéo',
      subtitle: 'Choisissez une vidéo pour enrichir l’activité',
      onTap: _pickVideo,
    );
  }

  Widget _buildMediaEmptyCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: context.boxSurfaceLight,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.borderColor),
          ),
          child: Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: context.avatarOrangeBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 29, color: context.primaryOrange),
              ),

              const SizedBox(height: 14),

              Text(
                title,
                style: TextStyle(
                  color: context.textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.textMuted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: context.primaryOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Choisir',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveButton({required VoidCallback onTap}) {
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.close_rounded, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons({required bool isLoading}) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 54,
            child: OutlinedButton(
              onPressed: isLoading
                  ? null
                  : _currentPage == 0
                  ? () => context.pop()
                  : _goToPreviousPage,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: BorderSide(color: context.borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Annuler',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: SizeConfig.getProportionateWidth(12)),

        Expanded(
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : _currentPage == 0
                  ? _goToNextPage
                  : _ajouterActivite,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryOrange,
                foregroundColor: Colors.white,
                disabledBackgroundColor: context.textMuted.withValues(
                  alpha: 0.35,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _currentPage == 0 ? 'Suivant' : 'Ajouter',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final state = ref.watch(activiteControllerProvider);

    ref.listen<AsyncValue>(activiteControllerProvider, (_, state) {
      state.showErrorDialog(context);
    });

    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: const Text('Ajouter une activité'),
        backgroundColor: context.bgColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionateWidth(20),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _currentPage == 0
                      ? _buildPage1InfosGenerales()
                      : _buildPage2Medias(),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.getProportionateWidth(20),
                8,
                SizeConfig.getProportionateWidth(20),
                16,
              ),
              child: _buildNavigationButtons(isLoading: state.isLoading),
            ),
          ],
        ),
      ),
    );
  }
}
