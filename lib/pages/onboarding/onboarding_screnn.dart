import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tolon/commun_widget/common_button.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();
  int currenpage = 0;

  // Données des trois pages issues de notre maquette Figma
  final List<Map<String, String>> pages = [
    {
      "title": "Apprends en t'amusant",
      "description": "Des contenus éducatifs adaptés à chaque âge.",
      "image": "assets/images/onboarding/b1.png",
    },
    {
      "title": "Joue, progresse et gagne !",
      "description":
          "Transforme les efforts en victoires et suis tes réussites.",
      "image": "assets/images/onboarding/b2.png",
    },
    {
      "title": "Des récompenses, oui !",
      "description":
          "Cumule tes points au quotidien et collectionne tous les trophées.",
      "image": "assets/images/onboarding/b3.png",
    },
  ];

  void onpageChanged(int index) {
    setState(() {
      currenpage = index;
    });
  }

  void skip() {
    completOnboarding();
  }

  Future<void> completOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("hasSeenOnboarding", true);
    if (mounted) {
      context.goNamed(
        AppRoutes.login.name,
      ); // Utilisation de votre route d'authentification cible
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.onboading13,
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: pages.length,
            onPageChanged: onpageChanged,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(pages[index]["image"]!, height: 250),
                  const SizedBox(height: 30),
                  Text(
                    pages[index]["title"]!,
                    textAlign: TextAlign.center,
                    style: AppStyles.headingTextStyle.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      pages[index]["description"]!,
                      textAlign: TextAlign.center,
                      style: AppStyles.normalTextStyle.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 50,
            right: 20,
            child: currenpage < pages.length - 1
                ? GestureDetector(
                    onTap: skip,
                    child: Text(
                      "Passer", // Version française de Skip conforme à l'application
                      style: AppStyles.normalTextStyle.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          Positioned(
            bottom:
                120, // Remonté légèrement pour laisser la place au bouton CustomButton
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: currenpage == index ? 12 : 8,
                  height: currenpage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currenpage == index
                        ? AppStyles.primaryOrange
                        : Colors.grey.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
          if (currenpage == pages.length - 1)
            Positioned(
              bottom: 40,
              left: 30,
              right: 30,
              child: CustomButton(
                title:
                    'Commencer', // Utilise directement votre bouton réutilisable avec chargement
                isLoading: false,
                onTap: completOnboarding,
              ),
            ),
        ],
      ),
    );
  }
}
