import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/activites/activite_model.dart';

class ActiviteCard extends StatelessWidget {
  const ActiviteCard({super.key, required this.activite, required this.onTap});

  final ActiviteModel activite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.boxSurfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 135,
              child: ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
                child: activite.image != null && activite.image!.isNotEmpty
                    ? Image.network(
                        activite.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _imagePlaceholder(context: context);
                        },
                      )
                    : _imagePlaceholder(context: context),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activite.titre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.textDark,
                      ),
                    ),

                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        activite.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: context.textMuted,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Durée
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: context.textMuted,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          '${activite.dureeMinutes} min',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: context.textMuted,
                          ),
                        ),

                        const Spacer(),

                        // Âge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: context.avatarOrangeBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${activite.ageMin}-${activite.ageMax} ans',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: context.primaryOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder({required BuildContext context}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: context.boxSurfaceLight,
      child: Center(
        child: Icon(Icons.image_outlined, size: 45, color: context.textMuted),
      ),
    );
  }
}
