import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';

class EnfantProfilScreen extends StatefulWidget {
  final EnfantModel enfant;

  const EnfantProfilScreen({super.key, required this.enfant});

  @override
  State<EnfantProfilScreen> createState() => _EnfantProfilScreenState();
}

class _EnfantProfilScreenState extends State<EnfantProfilScreen> {
  late EnfantModel _currentEnfant;

  @override
  void initState() {
    super.initState();
    _currentEnfant = widget.enfant;
  }

  static int _calculerAge(DateTime? dateNaissance) {
    if (dateNaissance == null) return 0;
    final today = DateTime.now();
    int age = today.year - dateNaissance.year;
    if (today.month < dateNaissance.month ||
        (today.month == dateNaissance.month && today.day < dateNaissance.day)) {
      age--;
    }
    return age < 0 ? 0 : age;
  }

  @override
  Widget build(BuildContext context) {
    final ageCalculated = _calculerAge(_currentEnfant.naissance);

    return Scaffold(
      backgroundColor: AppStyles.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFD6EADF),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: AppStyles.textDark,
              ),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: Text(
          'Profil',
          style: TextStyle(
            color: AppStyles.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: AppStyles.textDark),
            onPressed: () async {
              final EnfantModel? enfantModifie = await context
                  .pushNamed<EnfantModel>(
                    AppRoutes.editEnfant.name,
                    extra: _currentEnfant,
                  );

              if (enfantModifie != null && mounted) {
                setState(() {
                  _currentEnfant = enfantModifie;
                });
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Avatar de l'enfant
              CircleAvatar(
                radius: 65,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    (_currentEnfant.avatarUrl != null &&
                        _currentEnfant.avatarUrl!.isNotEmpty)
                    ? (_currentEnfant.avatarUrl!.startsWith('http')
                          ? NetworkImage(_currentEnfant.avatarUrl!)
                          : AssetImage(_currentEnfant.avatarUrl!)
                                as ImageProvider)
                    : const AssetImage('assets/images/default_avatar.png'),
              ),
              const SizedBox(height: 16),

              // Nom et prénom
              Text(
                '${_currentEnfant.prenom ?? ''} ${_currentEnfant.nom ?? ''}'
                    .trim(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.textDark,
                ),
              ),
              const SizedBox(height: 4),

              // Âge
              Text(
                '$ageCalculated ans',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7CB342),
                ),
              ),
              const SizedBox(height: 32),

              // Cartes de statistiques (Grille via Wrap)
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildStatCard(
                    context,
                    value: '${_currentEnfant.defisRealises?.length ?? 14}',
                    label: 'Défis',
                    imagePath: 'assets/images/defi.png',
                  ),
                  _buildStatCard(
                    context,
                    value: '${_currentEnfant.activitesRealisees ?? 32}',
                    label: 'Activités',
                    imagePath: 'assets/images/activite.png',
                  ),
                  _buildStatCard(
                    context,
                    value: '${_currentEnfant.niveau ?? 4}',
                    label: 'Noobzer',
                    imagePath: 'assets/images/badge.png',
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Bouton basculer
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE67E22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Action basculer profil actif
                    context.pushNamed(
                      AppRoutes.espaceEnfant.name,
                      extra: widget.enfant,
                    );
                  },
                  child: Text(
                    'Basculer sur ce profil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textInverse,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String value,
    required String label,
    required String imagePath,
  }) {
    final double cardWidth = (MediaQuery.of(context).size.width - 64) / 2;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppStyles.textInverse,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF66BB6A),
                ),
              ),
              if (imagePath != null)
                Image.asset(
                  imagePath,
                  width: 38,
                  height: 38,
                  fit: BoxFit.contain,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppStyles.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
