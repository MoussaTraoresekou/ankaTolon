import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tolon/cor/router/gorouterRouterrefreshStream.dart';
import 'package:tolon/models/admin_model/tutoriel_model.dart';
import 'package:tolon/pages/Admins/admin_Bottom_NavigationBar.dart';
import 'package:tolon/pages/Admins/admin_dashboard.dart';
import 'package:tolon/pages/Admins/admin_profi.dart';
import 'package:tolon/pages/Admins/ajout_defis.dart';
import 'package:tolon/pages/Admins/ajout_tutos.dart';
import 'package:tolon/pages/Admins/commande_detail.dart';
import 'package:tolon/pages/Admins/commande_liste.dart';
import 'package:tolon/pages/Admins/liste_jouets.dart';
import 'package:tolon/pages/Admins/liste_tutos.dart';
import 'package:tolon/pages/Admins/utilisateur_detail.dart';
import 'package:tolon/pages/Admins/utilisateur_liste.dart';
import 'package:tolon/pages/Login/loginscreen.dart';
import 'package:tolon/pages/enfant/addEnfant.dart';
import 'package:tolon/pages/jouets/jouetDetail.dart';
import 'package:tolon/pages/jouets/jouet_form.dart';
import 'package:tolon/pages/onboarding/onboarding_screnn.dart';
import 'package:tolon/pages/parent/homScreen.dart';
import 'package:tolon/pages/register/register_screen.dart';
import 'package:tolon/pages/splush/splushScreen.dart';

part 'routes.g.dart';

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
  admincommandeDetail,
  adminutilisateurDetail,
  adminutilisateurListe,
  admincommandeListe,
  adminjouets,
  admindefis,
  admintutoriels,
  adminajoutjouets,
  adminajoututoriels,
  adminajoutdefis,
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
        builder: (context, state) => const HomeScreen(),
      ),

      // =========================
      // ADMIN
      // =========================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Appel de votre layout en vague verte
          return AdminBottomNav(navigationShell: navigationShell);
        },
        branches: [
          // Onglet Index 0 : Tableau de bord Admin
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/adminDashboard',
                name: AppRoutes.adminDashboard.name,
                builder: (context, state) => const AdminDashboard(),
              ),
            ],
          ),

          // Onglet Index 1 : Gestion des Jouets
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin-jouets',
                name: AppRoutes.adminjouets.name,
                builder: (context, state) {
                  return const ListeJouets();
                },
              ),
            ],
          ),

          // Onglet Index 2 : Gestion des Tutoriels Admin
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin-tutoriels',
                name: AppRoutes.admintutoriels.name,
                builder: (context, state) {
                  return const ListeTutos();
                },
              ),
            ],
          ),

          //Onglet Index 3 : Gestion des Défis
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin-defis',
                name: AppRoutes.adminajoutdefis.name,
                builder: (context, state) {
                  return const AjoutDefis();
                },
              ),
            ],
          ),
        ],
      ),

      // =========================
      // ADMIN - DÉTAIL UTILISATEUR
      // =========================
      GoRoute(
        path: '/adminDashboard/parent-detail/:userId',
        name: AppRoutes.adminutilisateurDetail.name,
        builder: (context, state) {
          
          // Extraction de l'ID depuis les paramètres de chemin
          final userId = state.pathParameters['userId'];
          return UserDetail(userId: userId!);
        },
      ),

      // =========================
      // ADMIN - DÉTAIL COMMANDE
      // =========================
      GoRoute(
        path: '/adminDashboard/commande-detail/:orderId',
        name: AppRoutes.admincommandeDetail.name,
        builder: (context, state) {

          // Extraction de l'ID depuis les paramètres du chemin
          final orderId = state.pathParameters['orderId'];
          return CommandeDetail(orderId: orderId!);
        },
      ),

      // =========================
      // ADMIN - LISTE UTILISATEUR
      // =========================
      GoRoute(
        path: '/adminDashboard/liste-utilisateur',
        name: AppRoutes.adminutilisateurListe.name,
        builder: (context, state) {
          return const ParentsList();
        },
      ),

      // =========================
      // ADMIN - LISTE COMMANDE
      // =========================
      GoRoute(
        path: '/adminDashboard/liste-commande',
        name: AppRoutes.admincommandeListe.name,
        builder: (context, state) {
          return const CommandeListe();
        },
      ),

      // =========================
      // ADMIN - AJOUT_TUTOS
      // =========================
      GoRoute(
        path: '/admin-tutoriels/ajout-tuto',
        name: AppRoutes.adminajoututoriels.name,
        builder: (context, state) {
          final tutorielAModifier = state.extra as TutorielModel?;
          return AjoutTuto(tutoriel: tutorielAModifier);
        },
      ),

      // =========================
      // ADMIN - PROFIL
      // =========================
      GoRoute(
        path: '/admin/profile',
        name: AppRoutes.profile.name,
        builder: (context, state) => const AdminProfil(), // ──> Connecté !
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
    ],
  );
}
