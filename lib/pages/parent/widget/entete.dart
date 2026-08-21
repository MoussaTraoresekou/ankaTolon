import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class Entete extends StatelessWidget {
  const Entete({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(Icons.person, color: Colors.grey),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Bonjour 👋',
                  style: AppStyles.titleTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(
                  'Heureux de vous retrouver',
                  style: TextStyle(color: Colors.black45, fontSize: 13),
                ),
              ],
            ),
          ],
        ),

        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, size: 28),
              onPressed: () {},
            ),

            Positioned(
              right: 6,
              top: 6,

              child: Container(
                padding: const EdgeInsets.all(4),

                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),

                child: const Text(
                  '10',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
