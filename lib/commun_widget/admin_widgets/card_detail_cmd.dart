import 'package:flutter/material.dart';

class CardDetailCmd extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget child;

  const CardDetailCmd({
    required BuildContext context,
    required this.title,
    this.icon,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 14,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon ?? Icons.widgets_outlined,
                color: Color(0xFF34713A),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF34713A),
                  fontFamily: 'Quicksand',
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(color: Color(0xFFF5F5F5), height: 1),
          ),
          child,
        ],
      ),
    );
  }
}
