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
import 'package:tolon/repository/activite_repository/activite_repository.dart';

class AddActiviteScreen extends ConsumerStatefulWidget {
  const AddActiviteScreen({super.key});

  @override
  ConsumerState<AddActiviteScreen> createState() =>
      _AddActiviteScreenState();
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

    if (image == null) {
      return;
    }

    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> _pickVideo() async {
    final video = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (video == null) {
      return;
    }

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
      dureeMinutes:
          int.tryParse(_dureeController.text.trim()) ?? 0,
      ageMin:
          int.tryParse(_ageMinController.text.trim()) ?? 0,
      ageMax:
          int.tryParse(_ageMaxController.text.trim()) ?? 0,
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
        .ajouterActivite(
          activite,
          image: imageFile,
          video: videoFile,
        );

    if (!mounted) {
      return;
    }

    final state = ref.read(activiteControllerProvider);

    if (succes) {
      state.showSuccessDialog(
        context,
        'Activité ajoutée avec succès !',
        () {
          context.pop();
        },
      );
    } else {
      state.showErrorDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final state = ref.watch(activiteControllerProvider);

    final categoriesAsync = ref.watch(
      watchCategoriesProvider,
    );

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.getProportionateWidth(16),
            SizeConfig.getProportionateHeight(30),
            SizeConfig.getProportionateWidth(16),
            SizeConfig.getProportionateHeight(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    ),
                    onPressed: state.isLoading
                        ? null
                        : () => context.pop(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ajouter une activité',
                          style:
                              AppStyles.headingTextStyle.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Renseignez les informations de l’activité',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(
                height:
                    SizeConfig.getProportionateHeight(20),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations de l’activité',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const Divider(
                      color: Colors.black12,
                    ),

                    const SizedBox(height: 12),

                    CustomTextField(
                      label: 'Titre',
                      hintText:
                          'Ex : Peinture avec les doigts',
                      controller: _titreController,
                      prefixIcon: Icons.title,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label: 'Description',
                      hintText:
                          'Entrez une description détaillée...',
                      controller: _descriptionController,
                      prefixIcon:
                          Icons.description_outlined,
                    ),

                    const SizedBox(height: 16),

                    categoriesAsync.when(
                      loading: () =>
                          const LinearProgressIndicator(),

                      error: (error, stackTrace) =>
                          const Text(
                        'Erreur lors du chargement des catégories.',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),

                      data: (categories) {
                        if (categories.isEmpty) {
                          return const Text(
                            'Aucune catégorie disponible.',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          );
                        }

                        return CustomDropdown<CategorieModel>(
                          label: 'Catégorie',
                          hintText:
                              'Choisir une catégorie',
                          value: _categorieSelectionnee,
                          prefixIcon:
                              Icons.category_outlined,
                          items: categories.map((categorie) {
                            return DropdownMenuItem<
                                CategorieModel>(
                              value: categorie,
                              child: Text(
                                categorie.nom,
                              ),
                            );
                          }).toList(),
                          onChanged: state.isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _categorieSelectionnee =
                                        value;
                                  });
                                },
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Âge minimum',
                            hintText: 'Ex : 3',
                            controller:
                                _ageMinController,
                            keyboardType:
                                TextInputType.number,
                            prefixIcon:
                                Icons.child_care,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: CustomTextField(
                            label: 'Âge maximum',
                            hintText: 'Ex : 6',
                            controller:
                                _ageMaxController,
                            keyboardType:
                                TextInputType.number,
                            prefixIcon:
                                Icons.child_friendly,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label: 'Durée en minutes',
                      hintText: 'Ex : 30',
                      controller: _dureeController,
                      keyboardType:
                          TextInputType.number,
                      prefixIcon:
                          Icons.timer_outlined,
                    ),

                    const SizedBox(height: 20),

                    _buildImageSection(
                      isLoading: state.isLoading,
                    ),

                    const SizedBox(height: 20),

                    _buildVideoSection(
                      isLoading: state.isLoading,
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : _ajouterActivite,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppStyles.primaryOrange,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                        child: state.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Ajouter l’activité',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: state.isLoading
                            ? null
                            : () => context.pop(),
                        style:
                            OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            const Text('Annuler'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection({
    required bool isLoading,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Image de l’activité',
          style: AppStyles.normalTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        if (_selectedImage == null)
          GestureDetector(
            onTap:
                isLoading ? null : _pickImage,
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                vertical: 25,
              ),
              decoration: BoxDecoration(
                color:
                    const Color(0xFFF9F9F6),
                borderRadius:
                    BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons
                        .add_photo_alternate_outlined,
                    size: 40,
                    color: Colors.black45,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sélectionner une image',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(10),
                child: Image.file(
                  File(_selectedImage!.path),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: isLoading
                      ? null
                      : _removeImage,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration:
                        const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildVideoSection({
    required bool isLoading,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Vidéo de l’activité',
          style: AppStyles.normalTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        if (_selectedVideo == null)
          GestureDetector(
            onTap:
                isLoading ? null : _pickVideo,
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                vertical: 25,
              ),
              decoration: BoxDecoration(
                color:
                    const Color(0xFFF9F9F6),
                borderRadius:
                    BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons
                        .video_library_outlined,
                    size: 40,
                    color: Colors.black45,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sélectionner une vidéo',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color:
                  const Color(0xFFF9F9F6),
              borderRadius:
                  BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black12,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.video_file_outlined,
                  size: 32,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    _selectedVideo!.name,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                ),

                IconButton(
                  onPressed: isLoading
                      ? null
                      : _removeVideo,
                  icon:
                      const Icon(Icons.close),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
