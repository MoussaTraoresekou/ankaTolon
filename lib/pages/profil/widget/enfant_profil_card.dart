import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';

class EnfantProfilCard extends StatelessWidget {
  final EnfantModel enfant;

  const EnfantProfilCard({
    super.key,
    required this.enfant,
  });

  int _calculerAge(DateTime dateNaissance) {
    final aujourdhui = DateTime.now();
    int age = aujourdhui.year - dateNaissance.year;
    if (aujourdhui.month < dateNaissance.month ||
        (aujourdhui.month == dateNaissance.month &&
            aujourdhui.day < dateNaissance.day)) {
      age--;
    }
    return age < 0 ? 0 : age;
  }

  @override
  Widget build(BuildContext context) {
    final age = _calculerAge(enfant.naissance);
    final sexeTexte = enfant.sexe.trim();

    return Row(
      children: [
        // AVATAR DE L'ENFANT
        _buildAvatar(),

        const SizedBox(width: 12),

        // INFORMATIONS
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${enfant.prenom} ${enfant.nom}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  // BADGE ÂGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3EA),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$age ans',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4D8A52),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // BADGE SEXE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEDD),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      sexeTexte.isNotEmpty ? sexeTexte : 'Féminin',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE67E22),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // CHEVRON CLIQUABLE
        IconButton(
          icon: const Icon(
            Icons.chevron_right_rounded,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () {
            context.pushNamed(
              AppRoutes.enfantProfil.name,
              extra: enfant,
            );
          },
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    if (enfant.avatarUrl != null && enfant.avatarUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          enfant.avatarUrl!,
          width: 55,
          height: 55,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _avatarParDefaut(),
        ),
      );
    }
    return _avatarParDefaut();
  }

  Widget _avatarParDefaut() {
    return Container(
      width: 55,
      height: 55,
      decoration: const BoxDecoration(
        color: Color(0xFFFFE8D2),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.child_care_rounded,
        size: 32,
        color: Color(0xFFE67E22),
      ),
    );
  }
}