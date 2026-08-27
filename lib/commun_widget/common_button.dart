import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';
class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.title,
    required this.isLoading,
  });

  final VoidCallback onTap;
  final String title;
  final bool isLoading;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return InkWell(
      onTap: widget.isLoading ? null : widget.onTap,
      borderRadius: BorderRadius.circular(10), // Coins arrondis selon notre Figma
      child: Container(
        alignment: Alignment.center,
        height: SizeConfig.getProportionateHeight(48),
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: widget.isLoading ? const Color.fromRGBO(230, 126, 34, 1).withValues(alpha: 0.7) : AppStyles.primaryOrange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: widget.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                widget.title, 
                style: AppStyles.titleTextStyle.copyWith(color: Colors.white),
              ),
      ),
    );
  }
}
