import 'package:flutter/material.dart';
import '../../cor/theme/app_theme.dart';
import '../../cor/utils/size_config.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.primaryOrange,
          foregroundColor: context.textInverse,
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionateHeight(16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: context.textInverse,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: context.titleTextStyle.copyWith(color: Colors.white),
              ),
      ),
    );
  }
}
