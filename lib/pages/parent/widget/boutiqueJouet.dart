import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/models/jouets/jouet_models.dart';
import 'package:tolon/pages/parent/widget/jouetCart.dart';

class BoutiquejouetSection extends StatelessWidget {
  final AsyncValue<List<JouetModel>> jouetsAsync;

  const BoutiquejouetSection({super.key, required this.jouetsAsync});

  @override
  Widget build(BuildContext context) {
    return jouetsAsync.when(
      loading: () {
        return SizedBox(
          height: SizeConfig.getProportionateHeight(240),
          child: Center(
            child: CircularProgressIndicator(color: context.navbarColor),
          ),
        );
      },
      error: (error, stack) {
        return SizedBox(
          height: SizeConfig.getProportionateHeight(100),
          child: Center(
            child: Text(
              'Impossible de charger les jouets.',
              style: context.normalTextStyle.copyWith(
                color: context.badgeRed,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
      data: (jouets) {
        if (jouets.isEmpty) {
          return SizedBox(
            height: SizeConfig.getProportionateHeight(100),
            child: Center(
              child: Text(
                'Aucun jouet disponible.',
                style: context.normalTextStyle.copyWith(
                  color: Colors.black45,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }

        return SizedBox(
          height: SizeConfig.getProportionateHeight(240),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: jouets.length,
            itemBuilder: (context, index) {
              return Jouetcart(jouet: jouets[index]);
            },
          ),
        );
      },
    );
  }
}
