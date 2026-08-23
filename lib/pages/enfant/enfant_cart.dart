import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';

class EnfantCard extends StatelessWidget {
  final EnfantModel enfant;
  final VoidCallback? onTap;

  const EnfantCard({
    super.key,
    required this.enfant,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2EFE7),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ??
              () {
                context.pushNamed(
                  AppRoutes.profileEnfant.name,
                  extra: enfant,
                );
              },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                _buildAvatar(),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${enfant.prenom} ${enfant.nom}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.titleTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF6EE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _calculerAge(enfant.naissance),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.black38,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: SizeConfig.getProportionateWidth(56),
      height: SizeConfig.getProportionateHeight(56),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF4F6F5),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildAvatarContent(),
    );
  }

  Widget _buildAvatarContent() {
    if (enfant.avatarUrl == null ||
        enfant.avatarUrl!.trim().isEmpty) {
      return const Icon(
        Icons.face_retouching_natural_outlined,
        color: Colors.black26,
        size: 28,
      );
    }

    return Image.network(
      enfant.avatarUrl!,
      fit: BoxFit.cover,
      loadingBuilder: (
        context,
        child,
        loadingProgress,
      ) {
        if (loadingProgress == null) {
          return child;
        }

        return const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return const Icon(
          Icons.face_retouching_natural_outlined,
          color: Colors.black26,
          size: 28,
        );
      },
    );
  }

  String _calculerAge(DateTime naissance) {
    final maintenant = DateTime.now();

    int age = maintenant.year - naissance.year;

    if (maintenant.month < naissance.month ||
        (maintenant.month == naissance.month &&
            maintenant.day < naissance.day)) {
      age--;
    }

    return '$age ans';
  }
}