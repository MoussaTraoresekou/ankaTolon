import 'package:flutter/material.dart';
import 'package:tolon/cor/utils/size_config.dart';

class SectionFavoris extends StatelessWidget {
  const SectionFavoris({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.getProportionateHeight(150),

      child: const Center(
        child: Text(
          'Aucun favoris disponible.',
          style: TextStyle(color: Colors.black45),
        ),
      ),
    );
  }
}
