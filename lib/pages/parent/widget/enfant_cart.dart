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

      margin: const EdgeInsets.only(right: 12),

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,

            child: Icon(Icons.person, color: Colors.grey),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  '${enfant.prenom} ${enfant.nom}',

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: AppStyles.normalTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  _calculerAge(enfant.naissance),

                  style: const TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
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
