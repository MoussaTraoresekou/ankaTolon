import 'package:flutter/material.dart';
import 'package:tolon/models/auth/user_modal.dart';

class ProfilHeader extends StatelessWidget {
  final UserModel utilisateur;

  const ProfilHeader({
    super.key,
    required this.utilisateur,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // AVATAR STATIQUE
        Container(
          width: 90,
          height: 90,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 230, 241, 228), // Orange très clair en fond
          ),
          child: const Icon(
            Icons.person,
            size: 55,
            color: Color.fromARGB(255, 132, 134, 132), // Icône utilisateur orange
          ),
        ),

        const SizedBox(height: 12),

        // NOM ET PRÉNOM
        Text(
          '${utilisateur.prenom} ${utilisateur.nom}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 4),

        // RÔLE
        const Text(
          'Parent/Responsable',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF7CA982), // Vert doux conforme à la maquette
          ),
        ),
      ],
    );
  }
}