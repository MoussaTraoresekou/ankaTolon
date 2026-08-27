import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tolon/commun_widget/bottom_navigation_bar.dart';

import 'package:tolon/pages/enfant/EnfantsList.dart';
import 'package:tolon/pages/enfant/SelectAvatar.dart';
import 'package:tolon/cor/router/gorouterRouterrefreshStream.dart';
import 'package:tolon/pages/Login/loginscreen.dart';
import 'package:tolon/pages/catalogue/catalogue_jouet.dart';
import 'package:tolon/pages/enfant/addEnfant.dart';
import 'package:tolon/pages/jouets/jouetDetail.dart';
import 'package:tolon/pages/jouets/jouet_form.dart';
import 'package:tolon/pages/onboarding/onboarding_screnn.dart';
import 'package:tolon/pages/parent/homScreen.dart';
import 'package:tolon/pages/register/register_screen.dart';
import 'package:tolon/pages/splush/splushScreen.dart';
import 'package:tolon/pages/favoris/favoris_page.dart';

part 'routes.g.dart';

enum AppRoutes {
  profileEnfant,
  mesenfants,
  addEnfantAvatar,
  jouetDetail,
  addjouet,
  addEnfant,
  splash,
  onboarding,
  login,
  register,
  home,
  catalogue,
  cart,
  orders,
  favorites,
  profile,
  adminDashboard,
  listEnfants,
  selectAvatar,
  quiz,
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

@riverpod
GoRouter appRouter(Ref ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
    redirect: (context, state) async {
      final user = firebaseAuth.currentUser;
      final currentLoc = state.matchedLocation;

      final publicRoutes = ['/splash', '/onboarding', '/login', '/register'];
      final isPublic = publicRoutes.contains(currentLoc);

      if (user == null) {
        return isPublic ? null : '/login';
      }

      if (currentLoc == '/register') {
        return null;
      }

      String? role;
      Future<String?> getRole() async {
        if (role != null) return role;
        final doc = await firestore.collection('users').doc(user.uid).get();
        role = doc.data()?['type'] as String?;
        return role;
      }

      if (currentLoc == '/splash' ||
          currentLoc == '/onboarding' ||
          currentLoc == '/login') {
        final r = await getRole();
        if (r == 'admin') {
          return '/adminDashboard';
        }
        if (r == 'parent') {
          return '/home';
        }
        return '/login';
      }

      if (currentLoc == '/adminDashboard') {
        if (await getRole() != 'admin') return '/home';
        return null;
      }

      final parentRoutes = [
        '/home',
        '/catalogue',
        '/cart',
        '/orders',
        '/favorites',
        '/profile',
      ];
      if (parentRoutes.contains(currentLoc)) {
        if (await getRole() != 'parent') return '/adminDashboard';
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: AppRoutes.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: AppRoutes.onboarding.name,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoutes.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: AppRoutes.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        name: AppRoutes.home.name,
        builder: (context, state) => const AppBottomNavigationBar(),
      ),
      GoRoute(
        path: '/addEnfant',
        name: AppRoutes.addEnfant.name,
        builder: (context, state) => const AddEnfantScreen(),
      ),
      GoRoute(
        path: '/addjouet',
        name: AppRoutes.addjouet.name,
        builder: (context, state) => const JouetForm(),
      ),
      GoRoute(
        path: '/detailJouet',
        name: AppRoutes.jouetDetail.name,
        builder: (context, state) => const Jouetdetail(),
      ),
      GoRoute(
        path: '/listEnfants',
        name: AppRoutes.listEnfants.name,
        builder: (context, state) => const EnfantsListScreen(),
      ),
      GoRoute(
        path: '/selectAvatar',
        name: AppRoutes.selectAvatar.name,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return SelectAvatarScreen(dataEnfant: extra);
        },
      ),
    ],
  );
}
