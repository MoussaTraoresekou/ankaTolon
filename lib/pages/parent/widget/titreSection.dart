import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class TitreSection extends StatelessWidget {
  final String title;

  const TitreSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,
          style: AppStyles.titleTextStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        TextButton(
          onPressed: () {},

          child: const Text(
            'Voir tout',
            style: TextStyle(color: Color(0xFF6FB565)),
          ),
        ),
      ],
    );
  }
}
