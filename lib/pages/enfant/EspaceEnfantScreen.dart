import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/controller/auth/auth_controller.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';
import 'package:tolon/pages/parent/dialog/PasswordVerification.dart';

class EspaceEnfantScreen extends ConsumerWidget {
  final EnfantModel enfant;

  const EspaceEnfantScreen({super.key, required this.enfant});

  /// Affiche le dialogue de vérification du mot de passe parent.
  /// Retourne `true` si le mot de passe est correct, sinon `false`.
  Future<bool> _demanderMotDePasseParent(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PasswordVerificationDialog(
        onVerify: (password) async {
          return await ref
              .read(authControllerProvider.notifier)
              .verifierMotDePasse(password);
        },
      ),
    );
    return result ?? false;
  }

  /// Gère la tentative de sortie de l'espace enfant
  Future<void> _tenterSortie(BuildContext context, WidgetRef ref) async {
    final authentifie = await _demanderMotDePasseParent(context, ref);
    if (authentifie && context.mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String prenom = enfant.prenom ?? 'Enfant';
    final String? avatarUrl = enfant.avatarUrl;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _tenterSortie(context, ref);
      },
      child: Scaffold(
        backgroundColor: AppStyles.bgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, ref, prenom, avatarUrl),
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
      ),
    );
  }

  // Header avec bouton retour sécurisé, salut, notifications et avatar
  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    String prenom,
    String? avatarUrl,
  ) {
    return Row(
      children: [
        InkWell(
          onTap: () => _tenterSortie(context, ref),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppStyles.textInverse,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_left,
              size: 24,
              color: AppStyles.textDark,
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textDark,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('👋', style: TextStyle(fontSize: 16)),
                ],
              ),
              Text(
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
              decoration: BoxDecoration(
                color: AppStyles.textInverse,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: AppStyles.textMuted,
                size: 26,
              ),
            ),
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: BoxDecoration(
                  color: AppStyles.badgeRed,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '10',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppStyles.textInverse,
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
          backgroundColor: AppStyles.avatarOrangeBg,
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
                : Icon(Icons.person, color: AppStyles.textInverse, size: 26),
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
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppStyles.textInverse,
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
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppStyles.textInverse,
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
  // Grille 2x2 : Jeux, Tutoriels, Activités, Progress
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
          bgColor: AppStyles.primarySoft,
          image: 'assets/images/jeux.png',
          onTap: () {},
        ),
        _buildMenuCard(
          title: 'Tutoriels',
          bgColor: AppStyles.cardMenuYellow,
          image: 'assets/images/tuto.png',
          onTap: () {
            context.pushNamed(AppRoutes.espaceEnfantTuto.name);
          },
        ),
        _buildMenuCard(
          title: 'Activités',
          bgColor: AppStyles.cardMenuYellow,
          image: 'assets/images/activity.png',
          onTap: () {
            context.pushNamed(AppRoutes.activite.name);
          },
        ),
        _buildMenuCard(
          title: 'Progression',
          bgColor: AppStyles.primarySoft,
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
            if (image != null && image.isNotEmpty)
              Image.asset(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  iconData ?? Icons.extension,
                  size: 52,
                  color: iconColor ?? AppStyles.primary,
                ),
              )
            else if (iconData != null)
              Icon(iconData, size: 52, color: iconColor ?? AppStyles.primary),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppStyles.primary,
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
        color: AppStyles.bgColor,
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
      child: Row(
        children: [
          Image.asset(
            'assets/images/defis.png',
            width: 48,
            height: 48,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.emoji_events_rounded, size: 48, color: Colors.amber),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Défis du jour',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppStyles.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Dessine ton animal préféré en 10 mins',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppStyles.textMuted,
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
                  child: Text(
                    'Commencer',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textInverse,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/cadeau.png', height: 70, width: 70),
        
        ],
      ),
    );
  }
}
