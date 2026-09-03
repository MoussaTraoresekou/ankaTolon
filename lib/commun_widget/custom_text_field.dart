import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;

  final IconData? prefixIcon;
  final Color? prefixIconColor;

  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.normalTextStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textDark,
          ),
        ),

        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,

          style: context.normalTextStyle.copyWith(color: context.textMuted),

          decoration: InputDecoration(
            hintText: hintText,

            hintStyle: context.normalTextStyle.copyWith(
              color: context.textMuted,
            ),

            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: prefixIconColor ?? context.textMuted)
                : null,

            suffixIcon: suffixIcon,

            filled: true,
            fillColor: context.textInverse,

            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.textMuted, width: 1),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.primarySoft, width: 1),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.primary, width: 1.5),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
