import 'package:flutter/material.dart';

class Barrenavigation extends StatelessWidget {
  const Barrenavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,

      selectedItemColor: const Color(0xFF6FB565),

      unselectedItemColor: Colors.black38,

      currentIndex: 0,

      onTap: (index) {},

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Accueil',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.toys_outlined),
          activeIcon: Icon(Icons.toys),
          label: 'Catalogue',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: 'Panier',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          activeIcon: Icon(Icons.favorite),
          label: 'Favoris',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
