import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tolon/commun_widget/custom_text_field.dart';
import 'package:tolon/commun_widget/drop_down.dart';
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

  CategorieModel? _categorieSelectionnee;

  final ImagePicker _picker = ImagePicker();

  XFile? _selectedImage;
  XFile? _selectedVideo;

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
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> _pickVideo() async {
    final video = await _picker.pickVideo(source: ImageSource.gallery);

    if (video == null) return;

    setState(() {
      _selectedVideo = video;
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

  Future<void> _ajouterActivite() async {
    final activite = ActiviteModel(
      id: '',
      titre: _titreController.text.trim(),
      description: _descriptionController.text.trim(),
      categorieId: _categorieSelectionnee == null
          ? null
          : FirebaseFirestore.instance
                .collection('categories')
                .doc(_categorieSelectionnee!.id),
      image: null,
      videoUrl: null,
      dureeMinutes: int.tryParse(_dureeController.text.trim()) ?? 0,
      ageMin: int.tryParse(_ageMinController.text.trim()) ?? 0,
      ageMax: int.tryParse(_ageMaxController.text.trim()) ?? 0,
      dateCreation: DateTime.now(),
    );

    final imageFile = _selectedImage == null
        ? null
        : File(_selectedImage!.path);

    final videoFile = _selectedVideo == null
        ? null
        : File(_selectedVideo!.path);

    final succes = await ref
        .read(activiteControllerProvider.notifier)
        .ajouterActivite(activite, image: imageFile, video: videoFile);

    if (!mounted) return;

    final state = ref.read(activiteControllerProvider);

    if (succes) {
      state.showSuccessDialog(context, 'Activité ajoutée avec succès !', () {
        context.pop();
      });
    } else {
      state.showErrorDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final state = ref.watch(activiteControllerProvider);

    final categoriesAsync = ref.watch(listeCategoryByTypeProvider('activite'));

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isLoading: state.isLoading),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  SizeConfig.getProportionateWidth(20),
                  8,
                  SizeConfig.getProportionateWidth(20),
                  30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIntro(),

                    const SizedBox(height: 28),

                    _buildSectionTitle(
                      icon: Icons.info_outline_rounded,
                      title: 'Informations générales',
                      subtitle: 'Présentez votre activité',
                      context: context,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label: 'Titre de l’activité',
                      hintText: 'Ex : Peinture avec les doigts',
                      controller: _titreController,
                      prefixIcon: Icons.title_rounded,
                    ),

                    const SizedBox(height: 18),

                    CustomTextField(
                      label: 'Description',
                      hintText: 'Décrivez l’activité en quelques mots...',
                      controller: _descriptionController,
                      prefixIcon: Icons.notes_rounded,
                    ),

                    const SizedBox(height: 18),

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
                      error: (error, stackTrace) => _buildErrorMessage(context),
                      data: (categories) {
                        if (categories.isEmpty) {
                          return _buildEmptyCategoryMessage();
                        }

                        return CustomDropdown<CategorieModel>(
                          label: 'Catégorie',
                          hintText: 'Choisir une catégorie',
                          value: _categorieSelectionnee,
                          prefixIcon: Icons.category_rounded,
                          items: categories.map((categorie) {
                            return DropdownMenuItem<CategorieModel>(
                              value: categorie,
                              child: Text(
                                categorie.nom,
                                style: TextStyle(color: context.textDark),
                              ),
                            );
                          }).toList(),
                          onChanged: state.isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _categorieSelectionnee = value;
                                  });
                                },
                        );
                      },
                    ),

                    const SizedBox(height: 30),

                    _buildSectionTitle(
                      icon: Icons.tune_rounded,
                      title: 'Paramètres',
                      subtitle: 'Définissez l’âge et la durée',
                      context: context,
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Âge minimum',
                            hintText: 'Ex : 3',
                            controller: _ageMinController,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.child_care_rounded,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: CustomTextField(
                            label: 'Âge maximum',
                            hintText: 'Ex : 6',
                            controller: _ageMaxController,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.child_friendly_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    CustomTextField(
                      label: 'Durée',
                      hintText: 'Ex : 30 minutes',
                      controller: _dureeController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.timer_outlined,
                    ),

                    const SizedBox(height: 30),

                    _buildSectionTitle(
                      icon: Icons.perm_media_outlined,
                      title: 'Médias',
                      subtitle: 'Ajoutez une image et une vidéo',
                      context: context,
                    ),

                    const SizedBox(height: 16),

                    _buildImagePicker(isLoading: state.isLoading),

                    const SizedBox(height: 14),

                    _buildVideoPicker(
                      isLoading: state.isLoading,
                      context: context,
                    ),

                    const SizedBox(height: 32),

                    _buildSubmitButton(
                      isLoading: state.isLoading,
                      context: context,
                    ),

                    const SizedBox(height: 12),

                    _buildCancelButton(isLoading: state.isLoading),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({required bool isLoading}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 20, 8),
      child: Row(
        children: [
          Material(
            color: context.boxSurfaceLight,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: isLoading ? null : () => context.pop(),
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 19,
                  color: context.textDark,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              'Nouvelle activité',
              style: context.headingTextStyle.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 20,
              color: context.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntro() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: context.textInverse,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              'Créez une activité amusante et adaptée aux enfants.',
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: context.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
    required context,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: context.avatarOrangeBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: context.primaryOrange, size: 20),
        ),

        const SizedBox(width: 11),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: context.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: context.textMuted),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePicker({required bool isLoading}) {
    if (_selectedImage != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.file(
              File(_selectedImage!.path),
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
            child: _buildRemoveButton(onTap: isLoading ? null : _removeImage),
          ),
        ],
      );
    }

    return _buildMediaEmptyCard(
      icon: Icons.add_photo_alternate_outlined,
      title: 'Ajouter une image',
      subtitle: 'Une belle image pour présenter l’activité',
      onTap: isLoading ? null : _pickImage,
    );
  }

  Widget _buildVideoPicker({required bool isLoading, required context}) {
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.avatarOrangeBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                Icons.video_file_rounded,
                color: context.primaryOrange,
                size: 25,
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
                  const SizedBox(height: 3),
                  Text(
                    _selectedVideo!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),

            _buildRemoveButton(onTap: isLoading ? null : _removeVideo),
          ],
        ),
      );
    }

    return _buildMediaEmptyCard(
      icon: Icons.video_library_outlined,
      title: 'Ajouter une vidéo',
      subtitle: 'Montrez comment réaliser l’activité',
      onTap: isLoading ? null : _pickVideo,
    );
  }

  Widget _buildMediaEmptyCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.boxSurfaceLight,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: context.borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: context.primarySoft,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: context.primary, size: 27),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: context.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: context.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),

              Icon(Icons.chevron_right_rounded, color: context.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveButton({required VoidCallback? onTap}) {
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

  Widget _buildSubmitButton({required bool isLoading, required context}) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : _ajouterActivite,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.primaryOrange,
          foregroundColor: Colors.white,
          disabledBackgroundColor: context.textMuted.withValues(alpha: 0.35),
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
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, size: 21),
                  SizedBox(width: 8),
                  Text(
                    'Créer l’activité',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCancelButton({required bool isLoading}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: isLoading ? null : () => context.pop(),
        style: TextButton.styleFrom(
          foregroundColor: context.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Annuler',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: context.badgeRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: context.badgeRed, size: 20),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Erreur lors du chargement des catégories.',
              style: TextStyle(color: context.badgeRed, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCategoryMessage() {
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
}
