import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tolon/commun_widget/common_button.dart';
import 'package:tolon/commun_widget/common_container_widget.dart';
import 'package:tolon/commun_widget/custom_text_field.dart';
import 'package:tolon/controller/jouet_coontroller/jouet_controller.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/async_value_ui.dart';
import 'package:tolon/cor/utils/size_config.dart';

class JouetForm extends ConsumerStatefulWidget {
  const JouetForm({super.key});

  @override
  ConsumerState<JouetForm> createState() => _JouetFormState();
}

class _JouetFormState extends ConsumerState<JouetForm> {
  // ============================================================
  // CONTROLLERS DU FORMULAIRE
  // ============================================================

  final _nomController = TextEditingController();
  final _ageMinController = TextEditingController();
  final _ageMaxController = TextEditingController();
  final _prixController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _beneficesController = TextEditingController();

  // ============================================================
  // CATÉGORIE
  // ============================================================

  DocumentReference? _selectedCategory;

  // ============================================================
  // IMAGES
  // ============================================================

  final ImagePicker _picker = ImagePicker();

  final List<XFile> _selectedImages = [];

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _nomController.dispose();
    _ageMinController.dispose();
    _ageMaxController.dispose();
    _prixController.dispose();
    _descriptionController.dispose();
    _beneficesController.dispose();

    super.dispose();
  }

  // ============================================================
  // SÉLECTIONNER PLUSIEURS IMAGES
  // ============================================================

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage(imageQuality: 80);

    if (images.isEmpty) {
      return;
    }

    setState(() {
      _selectedImages.addAll(images);
    });
  }

  // ============================================================
  // SUPPRIMER UNE IMAGE DE LA SÉLECTION
  // ============================================================

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // ============================================================
  // AJOUTER LE JOUET
  // ============================================================

  Future<void> _ajouterJouet() async {
    final succes = await ref
        .read(jouetControllerProvider.notifier)
        .ajouterJouet(
          nom: _nomController.text,
          ageMin: _ageMinController.text,
          ageMax: _ageMaxController.text,
          prix: _prixController.text,
          description: _descriptionController.text,
          benefices: _beneficesController.text,
          categorieId: _selectedCategory,
          images: _selectedImages.map((image) => File(image.path)).toList(),
        );

    if (!mounted) return;

    final state = ref.read(jouetControllerProvider);

    // ==========================================================
    // SUCCÈS
    // ==========================================================

    if (succes) {
      state.showSuccessDialog(context, 'Jouet ajouté avec succès !', () {
        context.goNamed(AppRoutes.home.name);
      });
    }
    // ==========================================================
    // ERREUR
    // ==========================================================
    else {
      state.showErrorDialog(context);
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final state = ref.watch(jouetControllerProvider);

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
              // ==================================================
              // HEADER
              // ==================================================
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: state.isLoading ? null : () => context.pop(),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ajouter un jouet',
                          style: AppStyles.headingTextStyle.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'Renseignez les informations du nouveau jouet',
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  Image.asset(
                    'assets/images/bear_illustration.png',
                    height: SizeConfig.getProportionateHeight(60),
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(width: 40);
                    },
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.getProportionateHeight(20)),

              // ==================================================
              // CONTENEUR DU FORMULAIRE
              // ==================================================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ==================================================
                    // TITRE
                    // ==================================================
                    const Text(
                      'Informations du jouet',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const Divider(color: Colors.black12),

                    const SizedBox(height: 12),

                    // ==================================================
                    // NOM
                    // ==================================================
                    CustomTextField(
                      label: 'Nom du jouet',
                      hintText: 'Ex : Kit Éveil Robotique',
                      controller: _nomController,
                    ),

                    const SizedBox(height: 16),

                    // ==================================================
                    // CATÉGORIE
                    // ==================================================
                    _buildCategoryDropdown(isLoading: state.isLoading),

                    const SizedBox(height: 16),

                    // ==================================================
                    // ÂGES
                    // ==================================================
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Âge minimum',
                            hintText: '4',
                            keyboardType: TextInputType.number,
                            controller: _ageMinController,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: CustomTextField(
                            label: 'Âge maximum',
                            hintText: '12',
                            keyboardType: TextInputType.number,
                            controller: _ageMaxController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ==================================================
                    // PRIX
                    // ==================================================
                    CustomTextField(
                      label: 'Prix (FCFA)',
                      hintText: '10000',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      controller: _prixController,
                    ),

                    const SizedBox(height: 16),

                    // ==================================================
                    // DESCRIPTION
                    // ==================================================
                    CustomTextField(
                      label: 'Description',
                      hintText: 'Entrez une description détaillée...',
                      controller: _descriptionController,
                    ),

                    const SizedBox(height: 16),

                    // ==================================================
                    // BÉNÉFICES
                    // ==================================================
                    CustomTextField(
                      label: 'Bénéfices',
                      hintText: 'Créativité, Concentration, Logique',
                      controller: _beneficesController,
                    ),

                    const SizedBox(height: 16),

                    // ==================================================
                    // IMAGES
                    // ==================================================
                    _buildImagesSection(isLoading: state.isLoading),

                    const SizedBox(height: 24),

                    // ==================================================
                    // BOUTON AJOUTER
                    // ==================================================
                    CustomButton(
                      onTap: _ajouterJouet,
                      title: 'Ajouter le jouet',
                      isLoading: state.isLoading,
                    ),

                    const SizedBox(height: 12),

                    // ==================================================
                    // BOUTON ANNULER
                    // ==================================================
                    CommonContainer(
                      onTap: state.isLoading
                          ? () {}
                          : () {
                              context.goNamed(AppRoutes.home.name);
                            },
                      text: 'Annuler',
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

  // ============================================================
  // DROPDOWN CATÉGORIE
  // ============================================================

  Widget _buildCategoryDropdown({required bool isLoading}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catégorie',
          style: AppStyles.normalTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('categories')
              .snapshots(),

          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text(
                'Erreur lors du chargement des catégories.',
                style: TextStyle(color: Colors.red),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }

            final categories = snapshot.data?.docs ?? [];

            if (categories.isEmpty) {
              return const Text(
                'Aucune catégorie disponible.',
                style: TextStyle(color: Colors.black45),
              );
            }

            return DropdownButtonFormField<DocumentReference>(
              initialValue: _selectedCategory,

              hint: const Text(
                'Choisir une catégorie',
                style: TextStyle(color: Colors.black38, fontSize: 14),
              ),

              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF9F9F6),

                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
              ),

              items: categories.map((doc) {
                final data = doc.data();

                return DropdownMenuItem<DocumentReference>(
                  value: doc.reference,
                  child: Text(data['nom'] ?? 'Sans nom'),
                );
              }).toList(),

              onChanged: isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // SECTION IMAGES
  // ============================================================

  Widget _buildImagesSection({required bool isLoading}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Images du jouet',
          style: AppStyles.normalTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        // ========================================================
        // BOUTON AJOUTER DES IMAGES
        // ========================================================
        GestureDetector(
          onTap: isLoading ? null : _pickImages,

          child: Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),

            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F6),

              borderRadius: BorderRadius.circular(10),

              border: Border.all(color: Colors.black12),
            ),

            child: Column(
              children: [
                const Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 40,
                  color: Colors.black45,
                ),

                const SizedBox(height: 8),

                const Text(
                  'Sélectionner des images',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 4),

                Text(
                  _selectedImages.isEmpty
                      ? 'Vous pouvez sélectionner plusieurs images'
                      : '${_selectedImages.length} image(s) sélectionnée(s)',

                  textAlign: TextAlign.center,

                  style: const TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
        ),

        // ========================================================
        // APERÇU DES IMAGES
        // ========================================================
        if (_selectedImages.isNotEmpty) ...[
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,

            physics: const NeverScrollableScrollPhysics(),

            itemCount: _selectedImages.length,

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),

            itemBuilder: (context, index) {
              final image = _selectedImages[index];

              return Stack(
                children: [
                  // IMAGE
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),

                      child: Image.file(File(image.path), fit: BoxFit.cover),
                    ),
                  ),

                  // SUPPRIMER
                  Positioned(
                    top: 5,
                    right: 5,

                    child: GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                              _removeImage(index);
                            },

                      child: Container(
                        width: 26,
                        height: 26,

                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}
