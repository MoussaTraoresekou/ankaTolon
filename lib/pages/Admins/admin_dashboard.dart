import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/commun_widget/admin_widgets/quick_action_tile.dart';
import 'package:tolon/cor/app_colors.dart';
import 'package:tolon/commun_widget/admin_widgets/stat_card.dart';
import 'package:tolon/commun_widget/admin_widgets/section_container.dart';
import 'package:tolon/commun_widget/admin_widgets/order_row.dart';
import 'package:tolon/commun_widget/admin_widgets/user_row.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/controller/admin_controller/admin_providers.dart';
import 'package:tolon/cor/utils/fonction_date_Calcul.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ajout de WidgetRef ref

    // Écoute en temps réel des compteurs statistiques de Firebase
    final asyncTotalUsers = ref.watch(totalUsersStreamProvider);
    final asyncTotalChildren = ref.watch(totalChildrenStreamProvider);
    final asyncTotalOrders = ref.watch(totalOrdersStreamProvider);
    final asyncTotalActivities = ref.watch(totalActivitiesStreamProvider);

    // Écoute en temps réel des listes Firebase
    final asyncLastOrders = ref.watch(lastOrdersStreamProvider);
    final asyncLastUsers = ref.watch(lastUsersStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: AppColors.orangeSecondary,
            size: 28,
          ),
          onPressed: () {
            // Action du tiroir de navigation latéral (Drawer)
          },
        ),
        centerTitle: true,
        actions: [
          // (Votre bloc notifications actuel reste identique...)
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: AppColors.orangeSecondary,
                  size: 28,
                ),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: CircleAvatar(
              backgroundColor: AppColors.greenPrimary,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zone Bienvenue avec image
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Bonjour, Admin 👋',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Voici un aperçu général de votre application.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Image.asset(
                  'assets/images/admin_photo.png',
                  height: 85,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 25),

            // PREMIÈRE LIGNE DE STATS DYNAMIQUES
            Row(
              children: [
                Expanded(
                  child: asyncTotalUsers.when(
                    data: (count) => StatCard(
                      title: 'Utilisateurs',
                      value: '$count',
                      icon: Icons.people_alt_rounded,
                      isHighlighted: false,
                    ),
                    loading: () => StatCard(
                      title: 'Utilisateurs',
                      value: '...',
                      icon: Icons.people_alt_rounded,
                      isHighlighted: false,
                    ),
                    error: (e, _) => StatCard(
                      title: 'Utilisateurs',
                      value: 'Erreur',
                      icon: Icons.people_alt_rounded,
                      isHighlighted: false,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: asyncTotalChildren.when(
                    data: (count) => StatCard(
                      title: 'Enfants',
                      value: '$count',
                      icon: Icons.child_care,
                      isHighlighted: true,
                    ),
                    loading: () =>  StatCard(
                      title: 'Enfants',
                      value: '...',
                      icon: Icons.child_care,
                      isHighlighted: true,
                    ),
                    error: (e, _) =>  StatCard(
                      title: 'Enfants',
                      value: '0',
                      icon: Icons.child_care,
                      isHighlighted: false,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // DEUXIÈME LIGNE DE STATS DYNAMIQUES
            Row(
              children: [
                Expanded(
                  child: asyncTotalOrders.when(
                    data: (count) => StatCard(
                      title: 'Commandes',
                      value: '$count',
                      icon: Icons.shopping_bag_outlined,
                      isHighlighted: true,
                    ),
                    loading: () => const StatCard(
                      title: 'Commandes',
                      value: '...',
                      icon: Icons.shopping_bag_outlined,
                      isHighlighted: true,
                    ),
                    error: (e, _) => const StatCard(
                      title: 'Commandes',
                      value: '0',
                      icon: Icons.shopping_bag_outlined,
                      isHighlighted: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: asyncTotalActivities.when(
                    data: (count) => StatCard(
                      title: 'Activités réalisées',
                      value: '$count',
                      icon: Icons.emoji_events_outlined,
                      isHighlighted: false,
                    ),
                    loading: () => const StatCard(
                      title: 'Activités réalisées',
                      value: '...',
                      icon: Icons.emoji_events_outlined,
                      isHighlighted: false,
                    ),
                    error: (e, _) => const StatCard(
                      title: 'Activités réalisées',
                      value: '0',
                      icon: Icons.emoji_events_outlined,
                      isHighlighted: false,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // LISTE DYNAMIQUE : Dernières commandes avec recherche du nom via l'ID (Corrigé et Sécurisé)
            SectionContainer(
              title: 'Dernières commandes',
              child: asyncLastOrders.when(
                data: (snapshot) {
                  if (snapshot.docs.isEmpty) {
                    return const Text(
                      'Aucune commande passée',
                      style: TextStyle(fontSize: 11),
                    );
                  }
                  return Column(
                    children: snapshot.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;

                      // EXTRACTION SÉCURISÉE : Gère si parent_id est du texte ou une référence cliquable
                      String parentId = '';
                      final dynamic parentData = data['parent_id'];

                      if (parentData is DocumentReference) {
                        parentId = parentData
                            .id; // Extrait l'ID pur de la référence users/ID
                      } else if (parentData is String) {
                        parentId = parentData;
                      }

                      // CORRECTION DU PRIX : Évite le plantage si le montant est un chiffre (int/double) dans Firestore
                      final String prix = data['montant_total'] != null
                          ? "${data['montant_total']} F CFA"
                          : '0 F CFA';

                      // Formatage de la date de la commande (Jour, Mois en lettres et Année)
                      String dateCommande = 'Récemment';
                      if (data['date_cmd'] is Timestamp) {
                        final DateTime dt = (data['date_cmd'] as Timestamp)
                            .toDate();

                        // Tableau des mois en français
                        final moisEnLettres = [
                          'janvier',
                          'février',
                          'mars',
                          'avril',
                          'mai',
                          'juin',
                          'juillet',
                          'août',
                          'septembre',
                          'octobre',
                          'novembre',
                          'décembre',
                        ];

                        String nomMois =
                            moisEnLettres[dt.month -
                                1]; // -1 car le tableau commence à l'index 0

                        // Construit la phrase : "20 août 2026"
                        dateCommande = '${dt.day} $nomMois ${dt.year}';
                      }

                      // Utilisation du FutureBuilder pour aller chercher le NOM réel dans 'users'
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(parentId)
                            .get(),
                        builder: (context, userSnapshot) {
                          String nomParent = 'Chargement...';

                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            nomParent = 'Chargement...';
                          } else if (userSnapshot.hasData &&
                              userSnapshot.data!.exists) {
                            final userData =
                                userSnapshot.data!.data()
                                    as Map<String, dynamic>?;
                            nomParent =
                                userData?['nom'] ??
                                userData?['name'] ??
                                'Parent Ankan Tolon';
                          } else {
                            nomParent = 'Parent Inconnu';
                          }

                          return OrderRow(
                            id: doc.id,
                            name: nomParent,
                            date: dateCommande,
                            price: prix,
                            status: data['status'] ?? 'En cours',
                            statusColor: (data['status'] == 'Livrée')
                                ? Colors.green
                                : AppColors.orangeSecondary,
                          );
                        },
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    const Text('Erreur de chargement des commandes'),
              ),
            ),

            const SizedBox(height: 24),

            // LISTE DYNAMIQUE : Nouveaux utilisateurs corrigés avec heure dynamique
            SectionContainer(
              title: 'Nouveaux utilisateurs',
              child: asyncLastUsers.when(
                data: (snapshot) {
                  if (snapshot.docs.isEmpty) {
                    return const Text(
                      'Aucun utilisateur inscrit',
                      style: TextStyle(fontSize: 11),
                    );
                  }
                  return Column(
                    children: snapshot.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final String name =
                          data['name'] ?? data['nom'] ?? 'Inconnu';

                      // PARCOURS MAGIQUE DES INITIALES (ex: "Coulibaly Moh" -> "CM")
                      String initialesCalculees = '??';
                      if (name.isNotEmpty) {
                        List<String> mots = name.split(
                          ' ',
                        ); // Sépare le texte par les espaces

                        if (mots.length > 1 && mots[1].isNotEmpty) {
                          // Cas général : Il y a un nom et un prénom -> On prend la 1ère lettre du 1er mot + 1ère lettre du 2ème mot
                          initialesCalculees = mots[0][0] + mots[1][0];
                        } else {
                          // Cas de secours : Si le parent n'a écrit qu'un seul mot -> On prend ses 2 premières lettres
                          initialesCalculees = name.substring(
                            0,
                            min(name.length, 2),
                          );
                        }
                      }

                      return UserRow(
                        initials: initialesCalculees.toUpperCase(),
                        name: name,
                        email: data['email'] ?? 'Pas d\'email',
                        time: formatTempsEcoule(data['date_inscription']),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => const Text('Erreur de chargement'),
              ),
            ),
            const SizedBox(height: 24),

            // Section Actions Rapides (Transformées en vrais boutons cliquables)
            const Text(
              'Actions rapides',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    //context.go('/admin/add-toy'); // Redirection vers la page d'ajout de jouet
                  },
                  child: const QuickActionTile(
                    label: 'Ajouter un jouet',
                    icon: Icons.grid_view_rounded,
                    color: AppColors.greenPrimary,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    //context.go('/admin/add-activity'); // Redirection vers la page d'ajout d'activité
                  },
                  child: const QuickActionTile(
                    label: 'Créer une activité',
                    icon: Icons.extension,
                    color: AppColors.orangeSecondary,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    //context.go('/admin/add-tutorial'); // Redirection vers la page d'ajout d' un tutoriel
                  },
                  child: const QuickActionTile(
                    label: 'Ajouter un tutoriel',
                    icon: Icons.play_circle_outline,
                    color: AppColors.greenPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.greenPrimary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),

          BottomNavigationBarItem(
            icon: Icon(Icons.widgets_outlined),
            label: 'Jouets',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.play_lesson_outlined),
            label: 'Tutoriels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_outlined),
            label: 'Defis',
          ),
        ],
      ),
    );
  }
}
