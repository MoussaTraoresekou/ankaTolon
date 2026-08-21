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
        color: AppStyles.onboading13,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: SizeConfig.getProportionateWidth(40),
            height: SizeConfig.getProportionateWidth(40),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: Colors.black45,
              size: SizeConfig.getProportionateWidth(22),
            ),
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
                  style: AppStyles.normalTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(3)),
                Text(
                  _calculerAge(enfant.naissance),
                  style: AppStyles.normalTextStyle.copyWith(
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
