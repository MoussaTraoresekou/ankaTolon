import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class ImagesJouet extends StatelessWidget {
  final List<XFile> images;
  final Future<void> Function() selectionnerImages;
  final Function(int) supprimerImage;

  const ImagesJouet({
    super.key,
    required this.images,
    required this.selectionnerImages,
    required this.supprimerImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Images du jouet',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),

        const SizedBox(height: 10),

        GestureDetector(
          onTap: selectionnerImages,
          child: Container(
            width: double.infinity,
            height: 160,

            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(10),
            ),

            child: images.isEmpty
                ? const Center(
                    child: Text(
                      'Appuyer pour sélectionner\n'
                      'plusieurs images',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: images.length,

                    itemBuilder: (context, index) {
                      final image = images[index];

                      return Padding(
                        padding: const EdgeInsets.all(8),

                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),

                              child: FutureBuilder<Uint8List>(
                                future: image.readAsBytes(),

                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      width: 120,
                                      height: 140,
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    return Container(
                                      width: 120,
                                      height: 140,
                                      color: Colors.grey.shade200,
                                      child: Icon(Icons.image_not_supported),
                                    );
                                  }

                                  return Image.memory(
                                    snapshot.data!,
                                    width: 120,
                                    height: 140,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),

                            Positioned(
                              top: 3,
                              right: 3,

                              child: GestureDetector(
                                onTap: () {
                                  supprimerImage(index);
                                },

                                child: Container(
                                  width: 25,
                                  height: 25,

                                  decoration: BoxDecoration(
                                    color: context.badgeRed,
                                    shape: BoxShape.circle,
                                  ),

                                  child: Icon(
                                    Icons.close,
                                    color: context.textInverse,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
