import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/pages/catalogue/catalogue.dart';
import 'package:tolon/pages/enfant/espace_enfant_tuto.dart';
import 'package:tolon/pages/parent/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:tolon/pages/profil/profil_page.dart';
import 'package:tolon/pages/tutoriels/TutorielParents.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    CataloguePage(),
    Tutorielparents(),
    ProfilPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // On intercepte le retour
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Affichage de la confirmation
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Quitter l'application ?"),
            content: const Text("Voulez-vous vraiment fermer AnkaTolon ?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Non", style: TextStyle(color: context.textDark)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Oui", style: TextStyle(color: context.textDark)),
              ),
            ],
          ),
        );

        if (shouldPop ?? false) {
          SystemNavigator.pop(); // Ferme l'application native
        }
      },
      child: Scaffold(
        body: _pages[_selectedIndex],
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          index: _selectedIndex,
          color: context.navbarColor,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: context.navbarColor,

          items: [
            Icon(Icons.home, size: 25, color: Colors.white),
            Icon(Icons.shopping_cart, size: 25, color: Colors.white),
            Icon(Icons.video_library, size: 25, color: Colors.white),
            Icon(Icons.person, size: 25, color: Colors.white),
          ],

          onTap: (index) {
            setState(() {
              if (index == _selectedIndex) return;
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
