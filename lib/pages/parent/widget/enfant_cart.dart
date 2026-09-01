import 'package:flutter/material.dart';

import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';

class EnfantCart extends StatelessWidget {
  final EnfantModel enfant;

  const EnfantCart({super.key, required this.enfant});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getProportionateWidth(140),
      margin: EdgeInsets.only(right: SizeConfig.getProportionateWidth(12)),
      padding: EdgeInsets.all(SizeConfig.getProportionateWidth(10)),
      decoration: BoxDecoration(
        color: context.primarySoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: SizeConfig.getProportionateWidth(40),
            height: SizeConfig.getProportionateWidth(40),
            decoration: BoxDecoration(
              color: context.textInverse,
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: _buildAvatar(),
          ),

          SizedBox(width: SizeConfig.getProportionateWidth(8)),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${enfant.prenom} ${enfant.nom}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.normalTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: SizeConfig.getProportionateHeight(3)),

                Text(
                  _calculerAge(enfant.naissance),
                  style: context.normalTextStyle.copyWith(
                    fontSize: 11,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (enfant.avatarUrl == null || enfant.avatarUrl!.trim().isEmpty) {
      return Icon(
        Icons.person,
        color: Colors.black45,
        size: SizeConfig.getProportionateWidth(22),
      );
    }

    return Image.network(
      enfant.avatarUrl!,
      fit: BoxFit.cover,

      // Pendant le chargement
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },

      // Si l'URL est invalide ou l'image ne charge pas
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.person,
          color: Colors.black45,
          size: SizeConfig.getProportionateWidth(22),
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
