import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';

import 'package:tolon/models/enfant/enfant_modal.dart';
import 'package:tolon/pages/parent/widget/enfant_cart.dart';

class SectionEnfant extends StatelessWidget {
  final AsyncValue<List<EnfantModel>> enfantsAsync;

  const SectionEnfant({super.key, required this.enfantsAsync});

  @override
  Widget build(BuildContext context) {
    return enfantsAsync.when(
      loading: () {
        return SizedBox(
          height: SizeConfig.getProportionateHeight(75),
          child: Center(
            child: CircularProgressIndicator(color: AppStyles.navbarColor),
          ),
        );
      },
      error: (error, stack) {
        return SizedBox(
          height: SizeConfig.getProportionateHeight(75),
          child: Center(
            child: Text(
              'Impossible de charger les enfants.',
              style: AppStyles.normalTextStyle.copyWith(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ),
        );
      },
      data: (enfants) {
        return SizedBox(
          height: SizeConfig.getProportionateHeight(75),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...enfants.map((enfant) => EnfantCart(enfant: enfant)),
              _buildAddChildButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddChildButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(AppRoutes.addEnfant.name);
      },
      child: Container(
        width: SizeConfig.getProportionateWidth(100),
        margin: EdgeInsets.only(right: SizeConfig.getProportionateWidth(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppStyles.onboading13),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_alt_1,
              color: AppStyles.navbarColor,
              size: SizeConfig.getProportionateWidth(25),
            ),
            SizedBox(height: SizeConfig.getProportionateHeight(4)),
            Text(
              'Ajouter',
              style: AppStyles.normalTextStyle.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
