import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';

class EnfantProfilCard extends StatelessWidget {
  final EnfantModel enfant;

  const EnfantProfilCard({
    super.key,
    required this.enfant,
    required BuildContext context,
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
        _buildAvatar(context),

        const SizedBox(width: 12),

        // INFORMATIONS
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${enfant.prenom} ${enfant.nom}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: context.textDark,
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
                      color: context.primarySoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$age ans',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: context.primary,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // BADGE SEXE
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.cardMenuYellow,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      sexeTexte.isNotEmpty ? sexeTexte : 'Féminin',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: context.primaryOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // CHEVRON NAVIGATION
        Icon(Icons.chevron_right_rounded, color: context.textDark, size: 24),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (enfant.avatarUrl != null && enfant.avatarUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          enfant.avatarUrl!,
          width: 55,
          height: 55,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _avatarParDefaut(context),
        ),
      );
    }
    return _avatarParDefaut(context);
  }

  Widget _avatarParDefaut(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: context.cardMenuYellow,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.child_care_rounded,
        size: 32,
        color: context.primaryOrange,
      ),
    );
  }
}
