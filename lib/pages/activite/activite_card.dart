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
        decoration: BoxDecoration(
          color: AppStyles.boxSurfaceLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppStyles.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: activite.image != null && activite.image!.isNotEmpty
                    ? Image.network(
                        activite.image!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _imagePlaceholder();
                        },
                      )
                    : _imagePlaceholder(),
              ),
            ),

            Expanded(
              flex: 4,
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppStyles.textDark,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      activite.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: AppStyles.textMuted),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: AppStyles.textMuted,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          '${activite.dureeMinutes} min',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppStyles.textMuted,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          '${activite.ageMin}-${activite.ageMax} ans',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppStyles.textMuted,
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

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      color: AppStyles.boxSurfaceLight,
      child: Center(
        child: Icon(Icons.image_outlined, size: 45, color: AppStyles.textMuted),
      ),
    );
  }
}