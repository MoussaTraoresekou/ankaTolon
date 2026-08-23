import 'package:flutter/material.dart';

import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';

class Barrenavigation extends StatelessWidget {
  const Barrenavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppStyles.navbarColor,
      unselectedItemColor: Colors.black38,
      selectedFontSize: 11,
      unselectedFontSize: 10,
      currentIndex: 0,
      onTap: (index) {},
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            size: SizeConfig.getProportionateWidth(23),
          ),
          activeIcon: Icon(
            Icons.home,
            size: SizeConfig.getProportionateWidth(23),
          ),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.toys_outlined,
            size: SizeConfig.getProportionateWidth(23),
          ),
          activeIcon: Icon(
            Icons.toys,
            size: SizeConfig.getProportionateWidth(23),
          ),
          label: 'Catalogue',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_cart_outlined,
            size: SizeConfig.getProportionateWidth(23),
          ),
          activeIcon: Icon(
            Icons.shopping_cart,
            size: SizeConfig.getProportionateWidth(23),
          ),
          label: 'Panier',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite_outline,
            size: SizeConfig.getProportionateWidth(23),
          ),
          activeIcon: Icon(
            Icons.favorite,
            size: SizeConfig.getProportionateWidth(23),
          ),
          label: 'Favoris',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            size: SizeConfig.getProportionateWidth(23),
          ),
          activeIcon: Icon(
            Icons.person,
            size: SizeConfig.getProportionateWidth(23),
          ),
          label: 'Profil',
        ),
      ],
    );
  }
}
