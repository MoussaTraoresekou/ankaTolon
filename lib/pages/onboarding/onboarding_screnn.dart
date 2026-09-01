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

  // Données des trois pages issues de la maquette Figma
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

  // Quand l'utilisateur change de page
  void onpageChanged(int index) {
    setState(() {
      currenpage = index;
    });
  }

  // Passer l'onboarding
  void skip() {
    completOnboarding();
  }

  // Terminer l'onboarding
  Future<void> completOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("hasSeenOnboarding", true);

    if (mounted) {
      context.goNamed(AppRoutes.login.name);
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
      backgroundColor: context.primarySoft,
      body: Stack(
        children: [
          // =========================
          // LES PAGES D'ONBOARDING
          // =========================
          PageView.builder(
            controller: pageController,
            itemCount: pages.length,
            onPageChanged: onpageChanged,
            itemBuilder: (context, index) {
              return Container(
                // Deuxième page = FAFFFB
                color: index == 1 ? context.bgColor : context.primarySoft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image
                    Image.asset(pages[index]["image"]!, height: 250),

                    const SizedBox(height: 30),

                    // Titre
                    Text(
                      pages[index]["title"]!,
                      textAlign: TextAlign.center,
                      style: context.headingTextStyle.copyWith(
                        color: context.textDark,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        pages[index]["description"]!,
                        textAlign: TextAlign.center,
                        style: context.normalTextStyle.copyWith(
                          color: context.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // =========================
          // BOUTON "PASSER"
          // =========================
          Positioned(
            top: 50,
            right: 20,
            child: currenpage < pages.length - 1
                ? GestureDetector(
                    onTap: skip,
                    child: Text(
                      "Passer",
                      style: context.normalTextStyle.copyWith(
                        color: context.textMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),

          // =========================
          // INDICATEURS DE PAGES
          // =========================
          Positioned(
            bottom: 120,
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
                        ? context.primaryOrange
                        : Colors.grey.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),

          // =========================
          // BOUTON "COMMENCER"
          // =========================
          if (currenpage == pages.length - 1)
            Positioned(
              bottom: 40,
              left: 30,
              right: 30,
              child: CustomButton(
                title: 'Commencer',
                isLoading: false,
                onTap: completOnboarding,
              ),
            ),
        ],
      ),
    );
  }
}
