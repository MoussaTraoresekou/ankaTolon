import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tolon/cor/router/gorouterRouterrefreshStream.dart';
import 'package:tolon/pages/Login/loginscreen.dart';
import 'package:tolon/pages/onboarding/onboarding_screnn.dart';
import 'package:tolon/pages/parent/homScreen.dart';
import 'package:tolon/pages/register/register_screen.dart';
import 'package:tolon/pages/splush/splushScreen.dart';

part 'routes.g.dart';

enum AppRoutes {
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
    refreshListenable: GoRouterRefreshStream(
      firebaseAuth.authStateChanges(),
    ),
    redirect: (context, state) async {
      final user = firebaseAuth.currentUser;
      final currentLoc = state.matchedLocation;

      // ==========================================
      // ROUTES PUBLIQUES
      // ==========================================
      final publicRoutes = [
        '/splash',
        '/onboarding',
        '/login',
        '/register',
      ];

      final isPublic = publicRoutes.contains(currentLoc);

      // ==========================================
      // UTILISATEUR NON CONNECTÉ
      // ==========================================
      if (user == null) {
        if (isPublic) {
          return null;
        }
        return '/login';
      }

      // ==========================================
      // UTILISATEUR CONNECTÉ (BLOQUAGE PENDANT L'INSCRIPTION)
      // ==========================================
      // Si l'utilisateur vient de valider son inscription sur /register,
      // on annule temporairement la redirection automatique vers la Home
      // pour lui laisser le temps de voir son pop-up graphique de succès.
      if (currentLoc == '/register') {
        return null;
      }

      // ==========================================
      // REDIRECTION ET VÉRIFICATION APRÈS CONNEXION
      // ==========================================
      if (currentLoc == '/login') {
        final userDocument = await firestore
            .collection('users')
            .doc(user.uid)
            .get();

        if (!userDocument.exists) {
          return '/login';
        }

        final data = userDocument.data();
        final role = data?['type'];

        // ADMIN
        if (role == 'admin') {
          return '/adminDashboard';
        }

        // PARENT
        if (role == 'parent') {
          return '/home';
        }

        // Rôle inconnu
        return '/login';
      }

      // ==========================================
      // PROTECTION INTERFACE ADMIN
      // ==========================================
      if (currentLoc == '/adminDashboard') {
        final userDocument = await firestore
            .collection('users')
            .doc(user.uid)
            .get();

        final role = userDocument.data()?['type'];

        if (role != 'admin') {
          return '/home';
        }
      }

      // ==========================================
      // PROTECTION INTERFACE PARENT
      // ==========================================
      if (currentLoc == '/home') {
        final userDocument = await firestore
            .collection('users')
            .doc(user.uid)
            .get();

        final role = userDocument.data()?['type'];

        if (role != 'parent') {
          return '/adminDashboard';
        }
      }

      return null;
    },
    routes: [
      // =========================
      // SPLASH
      // =========================
      GoRoute(
        path: '/splash',
        name: AppRoutes.splash.name,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      // =========================
      // ONBOARDING
      // =========================
      GoRoute(
        path: '/onboarding',
        name: AppRoutes.onboarding.name,
        builder: (context, state) {
          return const OnboardingScreen();
        },
      ),

      // =========================
      // LOGIN
      // =========================
      GoRoute(
        path: '/login',
        name: AppRoutes.login.name,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),

      // =========================
      // REGISTER
      // =========================
      GoRoute(
        path: '/register',
        name: AppRoutes.register.name,
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),

      // =========================
      // HOME PARENT
      // =========================
      GoRoute(
        path: '/home',
        name: AppRoutes.home.name,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),

      // =========================
      // ADMIN
      // =========================
      /*
      GoRoute(
        path: '/adminDashboard',
        name: AppRoutes.adminDashboard.name,
        builder: (context, state) {
          return const AdminDashboardScreen();
        },
      ),
      */
    ],
  );
}
