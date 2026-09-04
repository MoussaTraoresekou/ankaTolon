import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:tolon/commun_widget/favoris/bouton_favori.dart';
import 'package:tolon/controller/auth/auth_provider.dart';
import 'package:tolon/controller/favoris/favoris_controller.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/repository/enfant/enfant_repository.dart';
import 'package:tolon/repository/jouets_reposotory/jouet_repository.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Déclaration static const pour garantir la disponibilité
  static const List<Color> _avatarBgColors = [
    Color(0xFFE2F1E4),
    Color(0xFFFFF3D6),
    Color(0xFFEAE3FF),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSectionTitle(
                'Mes enfants',
                'Voir tous les enfants',
                onTap: () => context.pushNamed(AppRoutes.listEnfants.name),
              ),
              const SizedBox(height: 12),
              _buildChildrenList(),
              const SizedBox(height: 24),
              _buildSectionTitle(
                'jouets les plus notés',
                'Voir tous les jouets',
                onTap: () {
                  context.pushNamed(AppRoutes.jouetList.name);
                },
              ),
              const SizedBox(height: 12),
              _buildTopRatedGamesList(),
              const SizedBox(height: 24),
              _buildSectionTitle(
                'Mes Favoris',
                'Voir tous les favoris',
                onTap: () {
                  context.pushNamed(AppRoutes.favorites.name);
                },
              ),
              const SizedBox(height: 12),
              _buildFavoritesList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final userPrenom = ref.watch(userDisplayNameProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Bonjour $userPrenom !',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.textDark,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('👋', style: TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Heureux de vous retrouver',
              style: TextStyle(fontSize: 13, color: context.textMuted),
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.textInverse,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: context.textMuted,
                size: 28,
              ),
            ),
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: BoxDecoration(
                  color: context.badgeRed,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '10',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.textInverse,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    String title,
    String actionText, {
    VoidCallback? onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: context.primarySoft,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: context.textDark,
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Text(
                actionText,
                style: TextStyle(
                  color: context.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.chevron_right, size: 18, color: context.primary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChildrenList() {
    final enfantsAsync = ref.watch(enfantsStreamProvider);

    return SizedBox(
      height: 92,
      child: enfantsAsync.when(
        data: (enfants) {
          // Limite l'affichage aux 3 premiers enfants
          final displayedEnfants = enfants.take(4).toList();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: displayedEnfants.length + 1,
            itemBuilder: (context, index) {
              if (index == displayedEnfants.length) {
                return _buildAddChildCard();
              }

              final enfant = displayedEnfants[index];
              final ageCalculated = _calculerAge(enfant.naissance);

              // Récupération uniquement du prénom
              final String prenomOnly = enfant.prenom ?? '';

              // Sécurité sur l'accès à la liste de couleurs
              final Color bgColor = _avatarBgColors.isNotEmpty
                  ? _avatarBgColors[index % _avatarBgColors.length]
                  : context.primarySoft;

              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: _buildChildCard(
                  prenomOnly,
                  '$ageCalculated ans',
                  enfant.avatarUrl,
                  avatarBgColor: bgColor,
                  onTap: () {
                    context.pushNamed(
                      AppRoutes
                          .enfantProfil
                          .name, // Adaptez selon le nom dans AppRoutes
                      extra: enfant, // Transmet l'objet enfant
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: context.primary)),
        error: (error, stack) => const Center(
          child: Text(
            'Erreur de chargement des enfants',
            style: TextStyle(fontSize: 12, color: Colors.red),
          ),
        ),
      ),
    );
  }

  int _calculerAge(DateTime? dateNaissance) {
    if (dateNaissance == null) return 0;
    final today = DateTime.now();
    int age = today.year - dateNaissance.year;
    if (today.month < dateNaissance.month ||
        (today.month == dateNaissance.month && today.day < dateNaissance.day)) {
      age--;
    }
    return age < 0 ? 0 : age;
  }

  Widget _buildChildCard(
    String name,
    String age,
    String? avatarUrl, {
    required Color avatarBgColor,
    VoidCallback? onTap, // <- Ajout du callback
  }) {
    return InkWell(
      onTap: onTap, // <- Gestion du clic
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 160,
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: context.textInverse,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.shadowColor,
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: avatarBgColor,
              child: ClipOval(
                child: avatarUrl != null && avatarUrl.isNotEmpty
                    ? Image.network(
                        avatarUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.person,
                          size: 30,
                          color: context.textInverse,
                        ),
                      )
                    : Icon(Icons.person, size: 30, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: context.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    age,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddChildCard() {
    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.addEnfant.name),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        height: 72,
        decoration: BoxDecoration(
          color: context.textInverse,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF2D6A4F), // Vert conforme à la maquette
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: context.textInverse,
                size: 22, // Icône plus grande et bien centrée
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Ajouter\nun enfant',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                height: 1.1,
                color: context.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRatedGamesList() {
    final jouetsAsync = ref.watch(streamJouetLesplusNotesProvider);

    return SizedBox(
      height: 220,
      child: jouetsAsync.when(
        data: (jouets) {
          if (jouets.isEmpty) {
            return Center(
              child: Text(
                'Aucun jeu disponible',
                style: TextStyle(color: context.textMuted),
              ),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: jouets.length,
            itemBuilder: (context, index) {
              final jouet = jouets[index];

              return Padding(
                padding: EdgeInsets.only(
                  right: index == jouets.length - 1 ? 0 : 14,
                ),
                child: _buildGameCard(
                  jouetId: jouet.id,
                  title: jouet.nomJouet ?? 'Jeu',
                  rating: (jouet.noteMoyen ?? 0.0).toStringAsFixed(1),
                  imageUrl: (jouet.image.isNotEmpty) ? jouet.image.first : null,
                  onTap: () {
                    context.pushNamed(AppRoutes.jouetDetail.name, extra: jouet);
                  },
                ),
              );
            },
          );
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: context.primary)),
        error: (error, stack) => const Center(
          child: Text(
            'Erreur lors du chargement des jeux',
            style: TextStyle(fontSize: 12, color: Colors.red),
          ),
        ),
      ),
      //bottomNavigationBar: const AppBottomNavigationBar(),
      //bottomNavigationBar: const Barrenavigation(),
    );
  }

  Widget _buildGameCard({
    required String jouetId,
    required String title,
    required String rating,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
    bool estFavori = false;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 155,
        decoration: BoxDecoration(
          color: context.textInverse,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Center(
                            child: Icon(
                              Icons.extension,
                              size: 48,
                              color: context.primary,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.extension,
                            size: 48,
                            color: context.primary,
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: context.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      BoutonFavori(jouetId: jouetId),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    final favorisIds = ref.watch(favorisControllerProvider);
    final jouetsAsync = ref.watch(streamJouetLesplusNotesProvider);

    if (favorisIds.isEmpty) {
      return SizedBox(
        height: 145,
        child: Center(
          child: Text(
            'Aucun favori pour le moment',
            style: TextStyle(color: context.textMuted, fontSize: 13),
          ),
        ),
      );
    }

    return jouetsAsync.when(
      data: (allJouets) {
        // Filtrer la liste des jeux selon les IDs présents dans favorisIds
        final favoris = allJouets
            .where((jouet) => favorisIds.contains(jouet.id))
            .toList();

        if (favoris.isEmpty) {
          return SizedBox(
            height: 145,
            child: Center(
              child: Text(
                'Aucun favori trouvé',
                style: TextStyle(color: context.textMuted, fontSize: 13),
              ),
            ),
          );
        }

        return SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: favoris.length,
            itemBuilder: (context, index) {
              final jouet = favoris[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == favoris.length - 1 ? 0 : 12,
                ),
                child: _buildFavoriteCard(
                  jouetId: jouet.id,
                  title: jouet.nomJouet ?? 'Jeu',
                  imageUrl: (jouet.image.isNotEmpty) ? jouet.image.first : null,
                  onTap: () {
                    context.pushNamed(AppRoutes.jouetDetail.name, extra: jouet);
                  },
                ),
              );
            },
          ),
        );
      },
      loading: () => SizedBox(
        height: 145,
        child: Center(child: CircularProgressIndicator(color: context.primary)),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildFavoriteCard({
    required String jouetId,
    required String title,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.textInverse,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            Icon(Icons.extension, color: context.primary),
                      )
                    : Icon(Icons.extension, color: context.primary),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: context.primarySoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Voir plus',
                style: TextStyle(
                  fontSize: 9,
                  color: context.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
