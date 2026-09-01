import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.label,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.prefixIcon,
    this.prefixIconColor,
    this.validator,
  });

  final String label;
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;

  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final String? Function(T?)? validator;

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

        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          isExpanded: true,

          style: context.normalTextStyle.copyWith(color: context.textDark),

          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black45),

          dropdownColor: context.textInverse,

          borderRadius: BorderRadius.circular(10),

          decoration: InputDecoration(
            hintText: hintText,

            hintStyle: context.normalTextStyle.copyWith(color: Colors.black38),

            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: prefixIconColor ?? Colors.black45)
                : null,

            filled: true,
            fillColor: context.textInverse,

            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black12, width: 1),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 187, 245, 194),
                width: 1,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 35, 198, 54),
                width: 1.5,
              ),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFEF5350),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
