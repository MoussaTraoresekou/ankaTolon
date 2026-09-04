import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class Baniere extends StatelessWidget {
  const Baniere({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        //color: Color(0x7674A56E),
        gradient: LinearGradient(
                    colors: [const Color(0x76C2E8BC).withOpacity(0.08), const Color(
                        0x7642DD2D).withOpacity(0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Color(0x7677AF6F), width: 1),

      ),
      child: Column(
        children: [
          Image.asset("assets/images/coupe.PNG",
            width: MediaQuery.of(context).size.width * 0.28,
            height: MediaQuery.of(context).size.height * 0.18,

          ),
          const SizedBox(height: 12),
          const Text(
            "Apprends en t'amusant",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A202C)),
          ),
          const SizedBox(height: 6),
          const Text(
            "Réponds aux quiz et gagne\ndes étoiles !",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF718096), height: 1.4),
          ),
        ],
      ),
    );
  }
}
