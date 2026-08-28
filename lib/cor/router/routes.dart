import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tolon/commun_widget/bottom_navigation_bar.dart';
import 'package:tolon/cor/router/gorouterRouterrefreshStream.dart';

import 'package:tolon/models/admin_model/tutoriel_model.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';
import 'package:tolon/models/jouets/jouet_models.dart';

import 'package:tolon/pages/Admins/admin_Bottom_NavigationBar.dart';
import 'package:tolon/pages/Admins/admin_dashboard.dart';
import 'package:tolon/pages/Admins/admin_profi.dart';
import 'package:tolon/pages/Admins/ajout_defis.dart';
import 'package:tolon/pages/Admins/ajout_tutos.dart';
import 'package:tolon/pages/Admins/commande_detail.dart';
import 'package:tolon/pages/Admins/commande_liste.dart';
import 'package:tolon/pages/Admins/liste_tutos.dart';
import 'package:tolon/pages/Admins/utilisateur_detail.dart';
import 'package:tolon/pages/Admins/utilisateur_liste.dart';
import 'package:tolon/pages/JouetsAdmin/AddJouets.dart';
import 'package:tolon/pages/Login/loginscreen.dart';
import 'package:tolon/pages/enfant/EspaceEnfantScreen.dart';
import 'package:tolon/pages/enfant/EspaceEnfantTuto.dart';
import 'package:tolon/pages/favoris/favoris_page.dart';
import 'package:tolon/pages/jouets/JouetsListNotes.dart';
import 'package:tolon/pages/onboarding/onboarding_screnn.dart';
import 'package:tolon/pages/panier/checkout_page.dart';
import 'package:tolon/pages/profil/profil_page.dart';
import 'package:tolon/pages/register/register_screen.dart';
import 'package:tolon/pages/splush/splushScreen.dart';

import 'package:tolon/pages/JouetsAdmin/Listes/liste_jouet.dart';

import 'package:tolon/pages/catalogue/catalogue.dart';

import 'package:tolon/pages/enfant/ChoisirAvatar.dart';
import 'package:tolon/pages/enfant/EditEnfantProfil.dart';
import 'package:tolon/pages/enfant/EnfantProfil.dart';
import 'package:tolon/pages/enfant/EnfantsList.dart';
import 'package:tolon/pages/enfant/SelectAvatar.dart';
import 'package:tolon/pages/enfant/addEnfant.dart';

import 'package:tolon/pages/jouets/jouetDetail.dart';

import 'package:tolon/pages/jouets/rediger_avis.dart';

import 'package:tolon/pages/panier/panier_page.dart';
import 'package:tolon/pages/panier/success_page.dart';
import 'package:tolon/pages/parent/reunitialiser_mot_de_passe.dart';

part 'routes.g.dart';

enum AppRoutes {
  splash,
  onboarding,
  login,
  register,
  changermotdepasse,
  home,
  catalogue,
  cart,
  checkout,
  success,
  orders,
  favorites,
  profile,
  addEnfant,
  listEnfants,
  selectAvatar,
  enfantProfil,
  editEnfant,
  choisirAvatar,
  jouetList,
  jouetDetail,
  redigerAvis,
  tutoriels,
  espaceEnfant,
  espaceEnfantTuto,

  // Routes Admin
  adminDashboard,
  JouetsAdmin,
  addJouetAdmin,
  admintutoriels,
  adminajoututoriels,
  adminajoutdefis,
  admincommandeDetail,
  adminutilisateurDetail,
  adminutilisateurListe,
  admincommandeListe,
  adminprofile,
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

      final publicRoutes = [
        '/splash',
        '/onboarding',
        '/login',
        '/register',
        '/forgotPassword',
      ];

      final isPublic = publicRoutes.contains(currentLoc);

      if (user == null) {
        return isPublic ? null : '/login';
      }

      if (currentLoc == '/register' || currentLoc == '/forgotPassword') {
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
        if (r == 'admin') return '/adminDashboard';
        if (r == 'parent') return '/home';
        return '/login';
      }

      final adminRoutes = [
        '/adminDashboard',
        '/admin-jouets',
        '/add-jouet-admin',
        '/admin-tutoriels',
        '/admin-defis',
      ];

      if (adminRoutes.any((route) => currentLoc.startsWith(route))) {
        if (await getRole() != 'admin') {
          return '/home';
        }
        return null;
      }

      final parentRoutes = [
        '/home',
        '/catalogue',
        '/cart',
        '/checkout',
        '/success',
        '/orders',
        '/favorites',
        '/profile',
        '/addEnfant',
        '/listEnfants',
        '/selectAvatar',
        '/enfant-profil',
        '/edit-enfant-profil',
        '/choisir-avatar',
        '/jeux-list',
        '/detailJouet',
        '/redigerAvis',
        '/tutoriels',
      ];

      if (parentRoutes.contains(currentLoc)) {
        if (await getRole() != 'parent') {
          return '/adminDashboard';
        }
        return null;
      }

      return null;
    },

    routes: [
      // ----------------- ROUTES PUBLIQUES -----------------
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
        path: '/forgotPassword',
        name: AppRoutes.changermotdepasse.name,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // ----------------- ROUTES PARENTS / UTILISATEURS -----------------
      GoRoute(
        path: '/home',
        name: AppRoutes.home.name,
        builder: (context, state) => const AppBottomNavigationBar(),
      ),
      GoRoute(
        path: '/tutoriels',
        name: AppRoutes.tutoriels.name,
        builder: (context, state) => const ListeTutos(),
      ),
      GoRoute(
        path: '/addEnfant',
        name: AppRoutes.addEnfant.name,
        builder: (context, state) => const AddEnfantScreen(),
      ),
      GoRoute(
        path: '/detailJouet',
        name: AppRoutes.jouetDetail.name,
        builder: (context, state) {
          final jouet = state.extra as JouetModel;
          return Jouetdetail(jouet: jouet);
        },
      ),
      GoRoute(
        path: '/redigerAvis',
        name: AppRoutes.redigerAvis.name,
        builder: (context, state) {
          final jouet = state.extra as JouetModel;
          return RedigerAvisPage(jouet: jouet);
        },
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
      GoRoute(
        path: '/cart',
        name: AppRoutes.cart.name,
        builder: (context, state) => const PanierPage(),
      ),
      GoRoute(
        path: '/checkout',
        name: AppRoutes.checkout.name,
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: '/success',
        name: AppRoutes.success.name,
        builder: (context, state) => const SuccessPage(),
      ),
      GoRoute(
        path: '/catalogue',
        name: AppRoutes.catalogue.name,
        builder: (context, state) => const CataloguePage(),
      ),
      GoRoute(
        path: '/favorites',
        name: AppRoutes.favorites.name,
        builder: (context, state) => const FavorisPage(),
      ),
      GoRoute(
        path: '/enfant-profil',
        name: AppRoutes.enfantProfil.name,
        builder: (context, state) {
          final enfant = state.extra as EnfantModel;
          return EnfantProfilScreen(enfant: enfant);
        },
      ),
      GoRoute(
        path: '/edit-enfant-profil',
        name: AppRoutes.editEnfant.name,
        builder: (context, state) {
          final enfant = state.extra as EnfantModel;
          return EditEnfantProfilScreen(enfant: enfant);
        },
      ),
      GoRoute(
        path: '/choisir-avatar',
        name: AppRoutes.choisirAvatar.name,
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>?;
          final enfant = extraData?['enfant'] as EnfantModel?;
          final updatedData =
              extraData?['updatedData'] as Map<String, dynamic>?;

          if (enfant == null) {
            return const Scaffold(
              body: Center(child: Text('Erreur : Profil enfant introuvable.')),
            );
          }
          return ChoisirAvatarScreen(enfant: enfant, updatedData: updatedData);
        },
      ),
      GoRoute(
        path: '/jeux-list',
        name: AppRoutes.jouetList.name,
        builder: (context, state) => const JeuxListScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: AppRoutes.profile.name,
        builder: (context, state) => const ProfilPage(),
      ),

      // ----------------- SHELL ROUTE ADMIN -----------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdminBottomNav(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/adminDashboard',
                name: AppRoutes.adminDashboard.name,
                builder: (context, state) => const AdminDashboard(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin-jouets',
                name: AppRoutes.JouetsAdmin.name,
                builder: (context, state) => const ListeJouetsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin-tutoriels',
                name: AppRoutes.admintutoriels.name,
                builder: (context, state) => const ListeTutos(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/admin-defis',
                name: AppRoutes.adminajoutdefis.name,
                builder: (context, state) => const AjoutDefis(),
              ),
            ],
          ),
        ],
      ),

      // ----------------- ROUTES SECONDAIRES ADMIN -----------------
      GoRoute(
        path: '/add-jouet-admin',
        name: AppRoutes.addJouetAdmin.name,
        builder: (context, state) => const AjouterJouetPage(),
      ),
      GoRoute(
        path: '/adminDashboard/parent-detail/:userId',
        name: AppRoutes.adminutilisateurDetail.name,
        builder: (context, state) {
          final userId = state.pathParameters['userId'];
          return UserDetail(userId: userId!);
        },
      ),
      GoRoute(
        path: '/adminDashboard/commande-detail/:orderId',
        name: AppRoutes.admincommandeDetail.name,
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'];
          return CommandeDetail(orderId: orderId!);
        },
      ),
      GoRoute(
        path: '/adminDashboard/liste-utilisateur',
        name: AppRoutes.adminutilisateurListe.name,
        builder: (context, state) => const ParentsList(),
      ),
      GoRoute(
        path: '/adminDashboard/liste-commande',
        name: AppRoutes.admincommandeListe.name,
        builder: (context, state) => const CommandeListe(),
      ),
      GoRoute(
        path: '/admin-tutoriels/ajout-tuto',
        name: AppRoutes.adminajoututoriels.name,
        builder: (context, state) {
          final tutorielAModifier = state.extra as TutorielModel?;
          return AjoutTuto(tutoriel: tutorielAModifier);
        },
      ),
      GoRoute(
        path: '/admin/profile',
        name: AppRoutes.adminprofile.name,
        builder: (context, state) => const AdminProfil(),
      ),
      GoRoute(
        path: '/espace-enfant',
        name: AppRoutes.espaceEnfant.name,
        builder: (context, state) {
          final enfant = state.extra as EnfantModel;
          return EspaceEnfantScreen(enfant: enfant);
        },
      ),
      GoRoute(
        path: '/espace-enfant-tutos',
        name: AppRoutes.espaceEnfantTuto.name,
        builder: (context, state) => const EspaceEnfantTutoScreen(),
      ),
    ],
  );
}
