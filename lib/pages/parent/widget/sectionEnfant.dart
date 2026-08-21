import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tolon/cor/router/routes.dart';
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
        return const SizedBox(
          height: 75,
          child: Center(child: CircularProgressIndicator()),
        );
      },

      error: (error, stack) {
        return SizedBox(
          height: 75,

          child: Center(
            child: Text(
              'Impossible de charger les enfants.',
              style: const TextStyle(color: Colors.red, fontSize: 12),
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

              _buildAddButton(
                context,
                icon: Icons.person_add_alt_1,
                text: 'Ajouter',
                onTap: () {
                  context.goNamed(AppRoutes.addEnfant.name);
                },
              ),

              _buildAddButton(
                context,
                icon: Icons.toys_outlined,
                text: 'Jouets',
                onTap: () {
                  context.goNamed(AppRoutes.addjouet.name);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: SizeConfig.getProportionateWidth(100),

        margin: const EdgeInsets.only(right: 12),

        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),

          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, color: Colors.green, size: 26),

            const SizedBox(height: 4),

            Text(
              text,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
