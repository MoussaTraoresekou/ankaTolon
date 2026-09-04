import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class Entete extends StatelessWidget {
  const Entete({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back_ios, size: 20, color: context.textDark),
            ),
            Row(
              children: const [
                Text("Quiz, ", style: TextStyle(fontSize: 22, color: Color(0xFF718096), fontWeight: FontWeight.w500)),
                Text("👋", style: TextStyle(fontSize: 22)),
              ],
            ),
            const Text(
              "Petit(e) champion(ne) !",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A202C)),
            ),
          ],
        ),
        /*Container(
          width: 55,
          height: 55,
          child: Center(
            child: Image.asset("assets/images/avatars/avatar1.png"),
          ),
        ),*/
      ],
    );
  }
}
