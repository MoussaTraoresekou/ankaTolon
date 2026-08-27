import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';

class EspaceEnfantScreen extends ConsumerWidget {
  final EnfantModel enfant;

  const EspaceEnfantScreen({super.key, required this.enfant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String prenom = enfant.prenom ?? 'Enfant';
    final String? avatarUrl = enfant.avatarUrl;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, prenom, avatarUrl),
              const SizedBox(height: 24),
              _buildStatsCard(points: 450, badges: 100),
              const SizedBox(height: 24),
              _buildGridMenu(context),
              const SizedBox(height: 24),
              _buildDailyChallengeCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Header avec bouton retour, salut, notifications et avatar
  Widget _buildHeader(BuildContext context, String prenom, String? avatarUrl) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_left,
              size: 24,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Bonjour $prenom !',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textDark,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('👋', style: TextStyle(fontSize: 16)),
                ],
              ),
              const Text(
                'Heureux de vous retrouver',
                style: TextStyle(fontSize: 12, color: AppStyles.textMuted),
              ),
            ],
          ),
        ),
        // Badge Notification
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.grey,
                size: 26,
              ),
            ),
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: const BoxDecoration(
                  color: AppStyles.badgeRed,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '10',
                  textAlign: TextAlign.center,
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
        const SizedBox(width: 10),
        // Avatar Enfant
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xFFFFE0B2),
          child: ClipOval(
            child: avatarUrl != null && avatarUrl.isNotEmpty
                ? (avatarUrl.startsWith('http')
                      ? Image.network(
                          avatarUrl,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          avatarUrl,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ))
                : const Icon(Icons.person, color: Colors.white, size: 26),
          ),
        ),
      ],
    );
  }

  // Carte verte : Points et Badges
  Widget _buildStatsCard({required int points, required int badges}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF409457),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  'assets/images/points.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$points',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'points',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white30),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/badget.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$badges',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'badges',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Grille 2x2 : Jeux, Tutoriels, Activités, Progression
  // Grille 2x2 : Jeux, Tutoriels, Activités, Progression
  Widget _buildGridMenu(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildMenuCard(
          title: 'Jeux',
          bgColor: const Color(0xFFDDEDDF),
          image: 'assets/images/jeux.png',
          onTap: () {},
        ),
        _buildMenuCard(
          title: 'Tutoriels',
          bgColor: const Color(0xFFFFEEC1),
          image: 'assets/images/tuto.png',
          onTap: () {},
        ),
        _buildMenuCard(
          title: 'Activités',
          bgColor: const Color(0xFFFFEEC1),
          image: 'assets/images/activity.png',
          onTap: () {},
        ),
        _buildMenuCard(
          title: 'Progression',
          bgColor: const Color(0xFFDDEDDF),
          image: 'assets/images/progress.png',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required String title,
    required Color bgColor,
    String? image,
    IconData? iconData,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Affichage de l'image si elle existe, sinon de l'icône
            if (image != null && image.isNotEmpty)
              Image.asset(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  iconData ?? Icons.extension,
                  size: 52,
                  color: iconColor ?? const Color(0xFF2E4D32),
                ),
              )
            else if (iconData != null)
              Icon(
                iconData,
                size: 52,
                color: iconColor ?? const Color(0xFF2E4D32),
              ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E4D32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Défis du jour
  Widget _buildDailyChallengeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDDEDDF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(
              255,
              3,
              3,
              3,
            ).withOpacity(0.3), // Ombre discrète
            blurRadius: 10, // Flou progressif
            spreadRadius: 0,
            offset: const Offset(0, 4), // Décalage vers le bas
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/defis.png', // Assurez-vous d'avoir l'image dans vos assets
            width: 48,
            height: 48,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.emoji_events_rounded,
              size: 48,
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Défis du jour',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B7A4B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Dessine ton animal préféré en 10 mins',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D8B55),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Commencer',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            height: 70,
            width: 70,
            'assets/images/cadeau.png', // Assurez-vous d'avoir l'image dans vos assets
          ),
        ],
      ),
    );
  }
}
