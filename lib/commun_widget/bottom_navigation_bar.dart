import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/pages/catalogue/catalogue.dart';
import 'package:tolon/pages/page_to_delete.dart';
import 'package:tolon/pages/page_to_delete2.dart';
import 'package:tolon/pages/page_to_delete3.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Page2(),
    CataloguePage(),
    Page3(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        index: _selectedIndex,
        color: AppStyles.navbarColor,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: AppStyles.navbarColor,

        items: [
          Icon(Icons.home, size: 25, color: Colors.white),
          Icon(Icons.shopping_cart, size: 25, color: Colors.white),
          Icon(Icons.person, size: 25, color: Colors.white),
        ],

        onTap: (index) {
          setState(() {
            if (index == _selectedIndex) return;
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
