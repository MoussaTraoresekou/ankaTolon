import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class ModifierImages extends StatelessWidget {
  // Anciennes images venant de Firestore
  final List<String> anciennesImages;

  // Nouvelles images sélectionnées
  final List<XFile> nouvellesImages;

  // Fonction pour choisir des images
  final VoidCallback ajouterImages;

  // Supprimer une ancienne image
  final Function(int) supprimerAncienneImage;

  // Supprimer une nouvelle image
  final Function(int) supprimerNouvelleImage;

  const ModifierImages({
    super.key,

    required this.anciennesImages,
    required this.nouvellesImages,

    required this.ajouterImages,

    required this.supprimerAncienneImage,
    required this.supprimerNouvelleImage,
  });

  Widget boutonCroix({required VoidCallback onPressed}) {
    return Positioned(
      top: 2,
      right: 2,

      child: Container(
        width: 24,
        height: 24,

        decoration: BoxDecoration(
          color: AppStyles.textInverse,
          shape: BoxShape.circle,
        ),

        child: IconButton(
          padding: EdgeInsets.zero,

          onPressed: onPressed,

          icon: Icon(Icons.close, color: AppStyles.badgeRed, size: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Text(
          'Images du jouet',

          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        if (anciennesImages.isEmpty && nouvellesImages.isEmpty)
          Container(
            width: double.infinity,

            height: 80,

            color: Colors.grey[100],

            child: const Center(
              child: Text('Aucune image', style: TextStyle(color: Colors.grey)),
            ),
          ),

        if (anciennesImages.isNotEmpty)
          SizedBox(
            height: 100,

            child: ListView.builder(
              scrollDirection: Axis.horizontal,

              itemCount: anciennesImages.length,

              itemBuilder: (context, index) {
                return Container(
                  width: 80,

                  margin: const EdgeInsets.only(right: 8),

                  child: Stack(
                    children: [
                      // IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),

                        child: Image.network(
                          anciennesImages[index],

                          width: 80,

                          height: 90,

                          fit: BoxFit.contain,

                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,

                              height: 90,

                              color: Colors.grey[200],

                              child: Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),

                      // CROIX ROUGE
                      boutonCroix(
                        onPressed: () {
                          supprimerAncienneImage(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        const SizedBox(height: 10),

        ElevatedButton.icon(
          onPressed: ajouterImages,

          icon: Icon(Icons.image, size: 18),

          label: const Text('Ajouter des images'),
        ),

        if (nouvellesImages.isNotEmpty) ...[
          const SizedBox(height: 10),

          const Text(
            'Nouvelles images',

            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          SizedBox(
            height: 100,

            child: ListView.builder(
              scrollDirection: Axis.horizontal,

              itemCount: nouvellesImages.length,

              itemBuilder: (context, index) {
                XFile image = nouvellesImages[index];

                return Container(
                  width: 80,

                  margin: const EdgeInsets.only(right: 8),

                  child: Stack(
                    children: [
                      FutureBuilder(
                        future: image.readAsBytes(),

                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox(
                              width: 80,

                              height: 90,

                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(6),

                            child: Image.memory(
                              snapshot.data!,

                              width: 80,

                              height: 90,

                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),

                      boutonCroix(
                        onPressed: () {
                          supprimerNouvelleImage(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
