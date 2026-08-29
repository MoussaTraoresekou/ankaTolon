import 'package:flutter/material.dart';
import 'package:tolon/cor/app_colors.dart';

class FormulaireTexteTuto extends StatelessWidget {
  final TextEditingController titreController;
  final TextEditingController ageMinController;
  final TextEditingController ageMaxController;
  final TextEditingController descriptionController;
  final VoidCallback onSuivant;

  const FormulaireTexteTuto({
    required this.titreController,
    required this.ageMinController,
    required this.ageMaxController,
    required this.descriptionController,
    required this.onSuivant,
    super.key,
  });

  void _afficherAlerte(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
      backgroundColor: AppColors.greenPrimary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Titre'),
        _buildTextField(
          titreController,
          'Titre du tuto',
          prefixIcon: Icons.abc_rounded,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Age min'),
                  _buildTextField(
                    ageMinController,
                    'Age minimal',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Age max'),
                  _buildTextField(
                    ageMaxController,
                    'Age maximal',
                    keyboardType: TextInputType.number,
                    suffixIcon: Icons.unfold_more_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildLabel('Description'),
        _buildTextField(
          descriptionController,
          'Description du tutoriel...',
          maxLines: 4,
        ),
        const SizedBox(height: 32),
        _buildBottomButtons(
          context,
          labelSuivant: 'Suivant',
          onPressed: (){

             // VÉRIFICATION STRICTE DES CHAMPS TEXTES
    if (titreController.text.trim().isEmpty) {
      _afficherAlerte(context, 'Le titre du tutoriel est obligatoire.');
      return;
    }
    if (ageMinController.text.trim().isEmpty) {
      _afficherAlerte(context, 'L\'âge minimal est obligatoire.');
      return;
    }
    if (ageMaxController.text.trim().isEmpty) {
      _afficherAlerte(context, 'L\'âge maximal est obligatoire.');
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      _afficherAlerte(context, 'La description est obligatoire.');
      return;
    }
    onSuivant();
          }
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Quicksand',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    IconData? prefixIcon,
    IconData? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(style: BorderStyle.solid,color: AppColors.greenPrimary),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenPrimary.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColors.textDark, size: 20)
              : null,
          suffixIcon: suffixIcon != null
              ? Icon(suffixIcon, color: AppColors.textDark, size: 20)
              : null,
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFECECEC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.greenPrimary),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(
    BuildContext context, {
    required String labelSuivant,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1F1F1),
                foregroundColor: AppColors.textDark,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Annuler',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orangeSecondary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                labelSuivant,
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
