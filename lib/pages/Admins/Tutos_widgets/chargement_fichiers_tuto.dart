import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tolon/cor/app_colors.dart';
import 'package:dashed_border/dashed_border.dart';

class ChargementFichiersTuto extends StatelessWidget {
  final File? videoFile;
  final File? imageFile;
  final String? existingVideoUrl;
  final String? existingImageUrl;
  final bool isEdition;
  final VoidCallback onChoisirVideo;
  final VoidCallback onChoisirImage;
  final VoidCallback onAjouter;

  const ChargementFichiersTuto({
    required this.videoFile,
    required this.imageFile,
    this.existingVideoUrl,
    this.existingImageUrl,
    this.isEdition = false,
    required this.onChoisirVideo,
    required this.onChoisirImage,
    required this.onAjouter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    // Variable pour afficher la date automatique du jour
    final String dateDuJour =
        "${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Affichage de la Date d'ajout fixe
        _buildLabel('Date'),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              style: BorderStyle.solid,
              color: AppColors.greenPrimary,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateDuJour,
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.calendar_month_rounded,
                color: AppColors.textDark,
                size: 20,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildLabel('Video'),
        _buildFileZonePointillee(
          file: videoFile,
          existingUrl: existingVideoUrl,
          hint:
              'Choisissez la vidéo à envoyer au utilisateurs\nMaximum 200 MB tail du fichier',
          onTap: onChoisirVideo,
          icon: Icons.upload_file_rounded,
        ),
        const SizedBox(height: 16),

        _buildLabel('Image de couverture'),
        _buildFileZonePointillee(
          file: imageFile,
          existingUrl: existingImageUrl,
          hint:
              'Choisissez la photo d\'illustration du cours\nFormat accepté : JPG, PNG',
          onTap: onChoisirImage,
          icon: Icons.image_outlined,
        ),
        const SizedBox(height: 32),

        // LE BOUTON PASSE EN DYNAMIQUE ("Modifier" ou "Ajouter")
        _buildBottomButtons(
          context,
          labelSuivant: isEdition ? 'Modifier' : 'Ajouter',
          onPressed: onAjouter,
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

  Widget _buildFileZonePointillee({
    required File? file,
    required String? existingUrl,
    required String hint,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    // Variable pour savoir si un fichier est déjà dispo en ligne
    final bool hasOnlineFile = existingUrl != null && existingUrl.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBF9),
        borderRadius: BorderRadius.circular(16),
        border: DashedBorder(color: AppColors.greenPrimary),
      ),
      child: Column(
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.textDark,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            icon: Icon(icon, size: 16, color: AppColors.textDark),
            label: const Text(
              'Charger',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            onPressed: onTap,
          ),
          const SizedBox(height: 12),

          // AFICHAGE INTELLIGENT : Indique si le fichier est chargé ou déjà existant sur le serveur
          if (file != null)
            Text(
              'Nouveau fichier sélectionné : ${file.path.split('/').last}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.greenPrimary,
                fontWeight: FontWeight.bold,
              ),
            )
          else if (hasOnlineFile)
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.green, size: 14),
                SizedBox(width: 6),
                Text(
                  'Fichier actuel conservé en ligne',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          else
            Text(
              hint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
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
