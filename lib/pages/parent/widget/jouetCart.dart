import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/models/jouets/jouet_models.dart';

class Jouetcart extends StatelessWidget {
  final JouetModel jouet;

  const Jouetcart({super.key, required this.jouet});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.jouetDetail.name, extra: jouet);
      },

      child: Container(
        width: SizeConfig.getProportionateWidth(160),

        margin: const EdgeInsets.only(right: 14),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Expanded(
              child: Container(
                width: double.infinity,

                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0),

                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),

                clipBehavior: Clip.antiAlias,

                child: jouet.image.isNotEmpty
                    ? Image.network(
                        jouet.image.first,

                        fit: BoxFit.cover,

                        width: double.infinity,

                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            color: Colors.black26,
                            size: 40,
                          );
                        },
                      )
                    : const Icon(Icons.image, color: Colors.black26, size: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    jouet.nomJouet,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),

                   

                    
                  ),

                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),

                          const SizedBox(width: 2),

                          Text(
                            jouet.noteMoyen.toStringAsFixed(1),

                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                       const Icon(Icons.favorite_border)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
