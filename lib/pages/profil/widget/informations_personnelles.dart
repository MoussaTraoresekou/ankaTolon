import 'package:flutter/material.dart';
import 'package:tolon/models/auth/user_modal.dart';

class InformationsPersonnelles extends StatelessWidget {
  final UserModel utilisateur;

  const InformationsPersonnelles({
    super.key,
    required this.utilisateur,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFCBE3CE), // Bordure verte fine
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informations personnelles',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 16),

          _InformationItem(
            icon: Icons.person_rounded,
            titre: 'Nom',
            valeur: '${utilisateur.prenom} ${utilisateur.nom}',
          ),

          const SizedBox(height: 16),

          _InformationItem(
            icon: Icons.alternate_email_rounded,
            titre: 'Email',
            valeur: utilisateur.email.isEmpty
                ? 'Non renseigné'
                : utilisateur.email,
          ),

          const SizedBox(height: 16),

          _InformationItem(
            icon: Icons.phone_rounded,
            titre: 'Téléphone',
            valeur: utilisateur.phoneNumber.isEmpty
                ? 'Non renseigné'
                : utilisateur.phoneNumber,
          ),
        ],
      ),
    );
  }
}

class _InformationItem extends StatelessWidget {
  final IconData icon;
  final String titre;
  final String valeur;

  const _InformationItem({
    required this.icon,
    required this.titre,
    required this.valeur,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF4D8A52),
          size: 24,
        ),
        
        const SizedBox(width: 12),

        Text(
          titre,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal, 
            color: Colors.black87,
          ),
        ),

        const Spacer(),

        Text(
          valeur,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal, // non gras
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}