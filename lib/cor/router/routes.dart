import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tolon/cor/router/gorouterRouterrefreshStream.dart';

import 'package:tolon/pages/Login/loginscreen.dart';
import 'package:tolon/pages/enfant/addEnfant.dart';
import 'package:tolon/pages/jouets/jouetDetail.dart';
import 'package:tolon/pages/jouets/jouet_form.dart';
import 'package:tolon/pages/onboarding/onboarding_screnn.dart';
import 'package:tolon/pages/parent/homScreen.dart';
import 'package:tolon/pages/register/register_screen.dart';
import 'package:tolon/pages/splush/splushScreen.dart';


import 'package:tolon/pages/JouetsAdmin/AddJouets.dart';
import 'package:tolon/pages/JouetsAdmin/Listes/liste_jouet.dart';
import 'package:tolon/pages/JouetsAdmin/Edit/ModifierJouet.dart';

part 'routes.g.dart';


// ============================================================
// ROUTES
// ============================================================

enum AppRoutes {
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
  test,
  JouetsAdmin,
  modifierJouet,
}


// ============================================================
// FIREBASE AUTH
// ============================================================

final firebaseAuthProvider =
Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});


// ============================================================
// FIRESTORE
// ============================================================

final firestoreProvider =
Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});


// ============================================================
// ROUTER
// ============================================================

@riverpod
GoRouter appRouter(Ref ref) {

  final firebaseAuth =
  ref.watch(firebaseAuthProvider);

  final firestore =
  ref.watch(firestoreProvider);

  return GoRouter(

    // ========================================================
    // PAGE DE DEPART
    // ========================================================

    initialLocation: '/splash',

    debugLogDiagnostics: true,


    // ========================================================
    // ACTUALISATION AUTHENTIFICATION
    // ========================================================

    refreshListenable:
    GoRouterRefreshStream(
      firebaseAuth.authStateChanges(),
    ),


    // ========================================================
    // REDIRECTION
    // ========================================================

    redirect:
        (context, state) async {

      final user =
          firebaseAuth.currentUser;

      final currentLoc =
          state.matchedLocation;


      // ======================================================
      // ROUTES PUBLIQUES
      // ======================================================

      final publicRoutes = [

        '/splash',

        '/onboarding',

        '/login',

        '/register',

        '/test',

        '/JouetsAdmin',

        '/addjouet',

      ];


      final isPublic =
      publicRoutes.contains(
        currentLoc,
      );


      // ======================================================
      // UTILISATEUR NON CONNECTE
      // ======================================================

      if (user == null) {

        return isPublic
            ? null
            : '/login';
      }


      // ======================================================
      // REGISTER
      // ======================================================

      if (currentLoc ==
          '/register') {

        return null;
      }


      // ======================================================
      // ROLE UTILISATEUR
      // ======================================================

      String? role;

      Future<String?> getRole() async {

        if (role != null) {
          return role;
        }

        final doc =
        await firestore
            .collection('users')
            .doc(user.uid)
            .get();

        role =
        doc.data()?['type']
        as String?;

        return role;
      }


      // ======================================================
      // SPLASH / ONBOARDING / LOGIN
      // ======================================================

      if (
      currentLoc == '/splash' ||
          currentLoc == '/onboarding' ||
          currentLoc == '/login'
      ) {

        final r =
        await getRole();


        if (r == 'admin') {

          return '/adminDashboard';
        }


        if (r == 'parent') {

          return '/home';
        }


        return '/login';
      }


      // ======================================================
      // ADMIN DASHBOARD
      // ======================================================

      if (currentLoc ==
          '/adminDashboard') {

        if (
        await getRole() != 'admin'
        ) {

          return '/home';
        }

        return null;
      }


      // ======================================================
      // ROUTES PARENT
      // ======================================================

      final parentRoutes = [

        '/home',

        '/catalogue',

        '/cart',

        '/orders',

        '/favorites',

        '/profile',

      ];


      if (
      parentRoutes.contains(
        currentLoc,
      )) {

        if (
        await getRole() != 'parent'
        ) {

          return '/adminDashboard';
        }

        return null;
      }


      return null;
    },


    // ========================================================
    // ROUTES
    // ========================================================

    routes: [


      // ======================================================
      // SPLASH
      // ======================================================

      GoRoute(

        path: '/splash',

        name:
        AppRoutes.splash.name,

        builder:
            (context, state) {

          return const SplashScreen();
        },
      ),


      // ======================================================
      // ONBOARDING
      // ======================================================

      GoRoute(

        path: '/onboarding',

        name:
        AppRoutes.onboarding.name,

        builder:
            (context, state) {

          return const OnboardingScreen();
        },
      ),


      // ======================================================
      // LOGIN
      // ======================================================

      GoRoute(

        path: '/login',

        name:
        AppRoutes.login.name,

        builder:
            (context, state) {

          return const LoginScreen();
        },
      ),


      // ======================================================
      // REGISTER
      // ======================================================

      GoRoute(

        path: '/register',

        name:
        AppRoutes.register.name,

        builder:
            (context, state) {

          return const RegisterScreen();
        },
      ),


      // ======================================================
      // HOME
      // ======================================================

      GoRoute(

        path: '/home',

        name:
        AppRoutes.home.name,

        builder:
            (context, state) {

          return const HomeScreen();
        },
      ),


      // ======================================================
      // AJOUTER ENFANT
      // ======================================================

      GoRoute(

        path: '/addEnfant',

        name:
        AppRoutes.addEnfant.name,

        builder:
            (context, state) {

          return const AddEnfantScreen();
        },
      ),


      // ======================================================
      // ANCIEN FORMULAIRE JOUET
      // ======================================================

      GoRoute(

        path: '/ancien-addjouet',

        builder:
            (context, state) {

          return const JouetForm();
        },
      ),


      // ======================================================
      // TEST
      // ======================================================

      GoRoute(

        path: '/test',

        name:
        AppRoutes.test.name,

        builder:
            (context, state) {

          return const AjouterJouetPage();
        },
      ),


      // ======================================================
      // LISTE DES JOUETS ADMIN
      // ======================================================

      GoRoute(

        path: '/JouetsAdmin',

        name:
        AppRoutes.JouetsAdmin.name,

        builder:
            (context, state) {

          return const ListeJouetsPage();
        },
      ),


      // ======================================================
      // AJOUTER UN JOUET
      // ======================================================

      GoRoute(

        path: '/addjouet',

        name:
        AppRoutes.addjouet.name,

        builder:
            (context, state) {

          return const AjouterJouetPage();
        },
      ),


      // ======================================================
      // MODIFIER UN JOUET
      // ======================================================

      GoRoute(

        path: '/modifierJouet',

        name:
        AppRoutes.modifierJouet.name,

        builder:
            (context, state) {

          final jouet =
              state.extra;

          return ModifierJouetPage(
            jouet: jouet as dynamic,
          );
        },
      ),


      // ======================================================
      // DETAIL JOUET
      // ======================================================

      GoRoute(

        path: '/detailJouet',

        name:
        AppRoutes.jouetDetail.name,

        builder:
            (context, state) {

          return const Jouetdetail();
        },
      ),
    ],
  );
}