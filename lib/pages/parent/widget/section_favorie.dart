import 'package:flutter/material.dart';

import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';

class SectionFavoris extends StatelessWidget {
  const SectionFavoris({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.getProportionateHeight(120),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              color: context.navbarColor,
              size: SizeConfig.getProportionateWidth(32),
            ),
            SizedBox(height: SizeConfig.getProportionateHeight(6)),
            Text(
              'Aucun favori disponible.',
              style: context.normalTextStyle.copyWith(
                color: Colors.black45,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
