import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';

class CommonContainer extends StatelessWidget {
  const CommonContainer({super.key, required this.onTap, required this.text});

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: SizeConfig.screenWidth,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ), // Arrondi de 10 conforme à votre Figma
          border: Border.all(
            color: Colors
                .black26, // Bordure plus douce pour correspondre aux maquettes
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Text(
          text,
          style: context.normalTextStyle.copyWith(color: context.textDark),
        ),
      ),
    );
  }
}
