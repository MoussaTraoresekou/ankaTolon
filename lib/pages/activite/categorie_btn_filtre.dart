import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppStyles.primaryOrange : AppStyles.boxSurfaceLight,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: selected ? AppStyles.primaryOrange : AppStyles.borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppStyles.textInverse : AppStyles.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}