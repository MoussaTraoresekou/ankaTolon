import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tolon/commun_widget/bottom_navigation_bar.dart';
import 'package:tolon/cor/router/gorouterRouterrefreshStream.dart';
import 'package:tolon/models/admin_model/tutoriel_model.dart';
import 'package:tolon/pages/Admins/admin_Bottom_NavigationBar.dart';
import 'package:tolon/pages/Admins/admin_dashboard.dart';
import 'package:tolon/pages/Admins/admin_profi.dart';
import 'package:tolon/pages/Admins/ajout_defis.dart';
import 'package:tolon/pages/Admins/ajout_tutos.dart';
import 'package:tolon/pages/Admins/commande_detail.dart';
import 'package:tolon/pages/Admins/commande_liste.dart';
import 'package:tolon/pages/JouetsAdmin/Listes/liste_jouet.dart';
import 'package:tolon/pages/Admins/liste_tutos.dart';
import 'package:tolon/pages/Admins/utilisateur_detail.dart';
import 'package:tolon/pages/Admins/utilisateur_liste.dart';

import 'package:tolon/models/enfant/enfant_modal.dart';
import 'package:tolon/models/avis/avis_model.dart';
import 'package:tolon/models/jouets/jouet_models.dart';

import 'package:tolon/pages/Login/loginscreen.dart';
import 'package:tolon/pages/catalogue/catalogue.dart';
import 'package:tolon/pages/enfant/ChoisirAvatar.dart';
import 'package:tolon/pages/enfant/EditEnfantProfil.dart';
import 'package:tolon/pages/enfant/EnfantProfil.dart';
import 'package:tolon/pages/enfant/EnfantsList.dart';
import 'package:tolon/pages/enfant/SelectAvatar.dart';
import 'package:tolon/pages/enfant/addEnfant.dart';
import 'package:tolon/pages/favoris/favoris_page.dart';
import 'package:tolon/pages/jouets/JouetsListNotes.dart';
import 'package:tolon/pages/jouets/jouetDetail.dart';
import 'package:tolon/pages/jouets/jouet_form.dart';
import 'package:tolon/pages/onboarding/onboarding_screnn.dart';
import 'package:tolon/pages/panier/checkout_page.dart';
import 'package:tolon/pages/panier/panier_page.dart';
import 'package:tolon/pages/panier/success_page.dart';
import 'package:tolon/pages/profil/profil_page.dart';
import 'package:tolon/pages/register/register_screen.dart';
import 'package:tolon/pages/splush/splushScreen.dart';

import 'package:tolon/pages/panier/panier_page.dart';
import 'package:tolon/pages/panier/checkout_page.dart';
import 'package:tolon/pages/panier/success_page.dart';
import 'package:tolon/pages/jouets/rediger_avis.dart';

import 'package:tolon/pages/catalogue/catalogue.dart';

part 'routes.g.dart';

enum AppRoutes {
  profileEnfant,
  mesenfants,
  addEnfantAvatar,
  jouetDetail,
  redigerAvis, // AJOUT
  addjouet,
  addEnfant,
  splash,
  onboarding,
  login,
  register,
  home,
  catalogue,
  cart,
  checkout,
  success,
  orders,
  favorites,
  profile,
  adminprofile,
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
  listEnfants,
  selectAvatar,
  enfantProfil,
  editEnfant,
  choisirAvatar,
  jouetList,
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
                name: AppRoutes.JouetsAdmin.name,
                builder: (context, state) {
                  return const ListeJouetsPage();
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
        name: AppRoutes.adminprofile.name,
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
  builder: (context, state) {
    final jouet = state.extra as JouetModel;

    return Jouetdetail(
      jouet: jouet,
    );
  },
),

GoRoute(
  path: '/redigerAvis',
  name: AppRoutes.redigerAvis.name,
  builder: (context, state) {
    final extra = state.extra;

    // Compatibilité : on peut passer un JouetModel seul (ancien)
    // ou un Map { 'jouet': JouetModel, 'avis': AvisModel? }
    if (extra is JouetModel) {
      return RedigerAvisPage(jouet: extra);
    }

    final map = extra as Map<String, dynamic>;
    return RedigerAvisPage(
      jouet: map['jouet'] as JouetModel,
      avisExistant: map['avis'] as AvisModel?,
    );
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


      GoRoute(
        path: '/add-jouet-admin',
        name: AppRoutes.addJouetAdmin.name,
        builder: (context, state) {
          return const AjouterJouetPage();
        },
      ),
      GoRoute(
  path: '/forgotPassword',
  name: AppRoutes.changermotdepasse.name,
  builder: (context, state) => const ForgotPasswordScreen(),
),


    ],
  );
}
