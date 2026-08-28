import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<Offset> logoSlideAnimation;
  late Animation<double> logoScaleAnimation;
  late Animation<double> logoFadeAnimation;

  late Animation<Offset> titleSlideAnimation;
  late Animation<double> titleFadeAnimation;

  late Animation<Offset> subtitleSlideAnimation;
  late Animation<double> subtitleFadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    logoSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.8), end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
          ),
        );

    logoScaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    titleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
          ),
        );

    titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.35, 0.65, curve: Curves.easeIn),
      ),
    );

    subtitleSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.55, 0.95, curve: Curves.easeOutCubic),
          ),
        );

    subtitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.55, 0.85, curve: Curves.easeIn),
      ),
    );

    controller.forward();

    _navigateToTheNextPage();
  }

  Future<void> _navigateToTheNextPage() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenOnboarding = prefs.getBool("hasSeenOnboarding") ?? false;

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      context.goNamed(AppRoutes.onboarding.name);
    } else {
      context.goNamed(AppRoutes.login.name);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primarySoft,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: logoFadeAnimation,
              child: SlideTransition(
                position: logoSlideAnimation,
                child: ScaleTransition(
                  scale: logoScaleAnimation,
                  child: Image.asset('assets/images/logo.png', width: 150),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
