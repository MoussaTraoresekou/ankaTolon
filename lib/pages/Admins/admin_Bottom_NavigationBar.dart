import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:tolon/cor/app_colors.dart';

class AdminBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AdminBottomNav({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    final int currentIndex = navigationShell.currentIndex;

    return Scaffold(
      // Conserve la mémoire et l'état de vos pages enfants (Dashboard, Jouets, etc.)
      body: navigationShell,

      // LA BARRE EN VAGUE ULTRA-FLUIDE DE VOTRE MAQUETTE
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFFF9FBF9),
        color: AppColors.greenPrimary,
        buttonBackgroundColor: Colors.white,
        height: 65,
        animationDuration: const Duration(
          milliseconds: 300,
        ), // Vitesse du glissement du cercle
        animationCurve: Curves.easeInOut, // Courbe de mouvement fluide
        // Indique au package quelle icône doit être entourée du cercle blanc au démarrage
        index: currentIndex,

        // La liste de vos 4 icônes exactes qui vont recevoir le cercle blanc à tour de rôle
        items: [
          _buildNavItem(Icons.home_filled, 'Home', currentIndex == 0),
          _buildNavItem(Icons.widgets_outlined, 'Jouets', currentIndex == 1),
          _buildNavItem(
            Icons.play_lesson_outlined,
            'Tutoriels',
            currentIndex == 2,
          ),
          _buildNavItem(
            Icons.track_changes_outlined,
            'Défis',
            currentIndex == 3,
          ),
        ],
        onTap: (int index) {
          // NAVIGATION : GoRouter change d'onglet et le cercle se déplace tout seul !
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }

  // Petit widget interne pour dessiner l'icône et cacher le texte proprement quand elle monte dans le cercle
  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,

            // Inversion de couleur automatique : vert quand l'icône est dans le cercle blanc, blanc le reste du temps
            color: isSelected
                ? AppColors.greenPrimary
                : Colors.white.withValues(alpha: 0.8),
          ),
          if (!isSelected) const SizedBox(height: 2),
          if (!isSelected)
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
