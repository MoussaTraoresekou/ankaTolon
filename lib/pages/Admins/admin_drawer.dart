import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/controller/profil/profil_controller.dart';
import 'package:tolon/cor/app_colors.dart';
import 'package:tolon/cor/router/routes.dart';

class AdminDrawer extends ConsumerWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // En-tête du menu latéral
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.greenPrimary),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: const AssetImage(
                "assets/images/adminProfil.png",
              ),
              //child: Icon(Icons.admin_panel_settings_rounded, size: 36, color: AppColors.greenPrimary),
            ),
            accountName: const Text(
              'Admin Ankatolon',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: const Text(
              'ankatolon@gmail.coml',
              style: TextStyle(fontFamily: 'Quicksand', fontSize: 13),
            ),
          ),

          // Options de navigation internes
          ListTile(
            leading: const Icon(
              Icons.people_outline_rounded,
              color: AppColors.greenPrimary,
              size: 30,
            ),
            title: const Text(
              'Liste des parents',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop(); // Ferme le drawer
              context.pushNamed(AppRoutes.adminutilisateurListe.name);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.orangeSecondary,
              size: 30,
            ),
            title: const Text(
              'Toutes les commandes',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              context.pushNamed(AppRoutes.admincommandeListe.name);
            },
          ),

          const Spacer(),
          const Divider(color: Color(0xFFF5F5F5), height: 1),

          // BOUTON DÉCONNEXION DE TA MAQUETTE AVEC DIALOGUE DE SÉCURITÉ
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.orangeSecondary),
            title: const Text(
              'Se déconnecter',
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                color: AppColors.orangeSecondary,
              ),
            ),
            onTap: () async {
              await ref.read(profilControllerProvider.notifier).deconnexion();
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // void _showLogoutDialog(BuildContext context, WidgetRef ref) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       backgroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  //       title: const Text(
  //         'Déconnexion',
  //         style: TextStyle(
  //           fontFamily: 'Quicksand',
  //           fontWeight: FontWeight.bold,
  //           fontSize: 18,
  //         ),
  //       ),
  //       content: const Text(
  //         'Êtes-vous sûr de vouloir quitter votre espace d\'administration ?',
  //         style: TextStyle(fontFamily: 'Quicksand', fontSize: 14),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text(
  //             'Annuler',
  //             style: TextStyle(
  //               fontFamily: 'Quicksand',
  //               fontWeight: FontWeight.w600,
  //               color: AppColors.textGrey,
  //             ),
  //           ),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.redAccent,
  //             foregroundColor: Colors.white,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //           ),
  //           onPressed: () async {
  //             await ref.read(profilControllerProvider.notifier).deconnexion();
  //           },

  //           child: const Text(
  //             'Quitter',
  //             style: TextStyle(
  //               fontFamily: 'Quicksand',
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
