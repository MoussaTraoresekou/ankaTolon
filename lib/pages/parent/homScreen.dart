import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/controller/auth/auth_provider.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';
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
      backgroundColor: AppStyles.background,
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
              _buildSectionTitle('Jeux les plus notés', 'Voir tous les jeux'),
              const SizedBox(height: 12),
              _buildTopRatedGamesList(),
              const SizedBox(height: 24),
              _buildSectionTitle('Mes Favoris', 'Voir tous les favoris'),
              const SizedBox(height: 12),
              _buildFavoritesList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

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
<<<<<<< HEAD
                  'Bonjour $userPrenom !',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppStyles.textDark,
                  ),
=======
                  'Bonjour Hamidou1 ! 👋',
                  style: AppStyles.titleTextStyle
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Heureux de vous retrouver',
                  style: TextStyle(color: Colors.black45, fontSize: 13),
>>>>>>> aae8b6a0774f0842987b59fceb7eb457debccc89
                ),
                const SizedBox(width: 6),
                const Text('👋', style: TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Heureux de vous retrouver',
              style: TextStyle(fontSize: 13, color: AppStyles.textMuted),
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.grey,
                size: 28,
              ),
            ),
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: const BoxDecoration(
                  color: AppStyles.badgeRed,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '10',
                  textAlign: TextAlign.center,
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
      ],
    );
  }

  // ============================================================
  // TITRE DES SECTIONS
  // ============================================================

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
            color: AppStyles.primarySoft,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppStyles.textDark,
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Text(
                actionText,
                style: const TextStyle(
                  color: AppStyles.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppStyles.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
  // ============================================================
  // MES ENFANTS
  // ============================================================

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
                  : AppStyles.primarySoft;

              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: _buildChildCard(
                  prenomOnly,
                  '$ageCalculated ans',
                  enfant.avatarUrl,
                  avatarBgColor: bgColor,
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppStyles.primary),
        ),
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
  }) {
    return Container(
      width: 150,
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: avatarBgColor,
            child: ClipOval(
              child: avatarUrl != null && avatarUrl.isNotEmpty
                  ? Image.asset(
                      avatarUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, color: AppStyles.primary),
                    )
                  : const Icon(Icons.person, color: AppStyles.primary),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF2E4D32),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  age,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
              child: const Icon(
                Icons.add,
                color: Colors.white,
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
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // JEUX LES PLUS NOTÉS
  // ============================================================

  Widget _buildTopRatedGamesList() {
    final jouetsAsync = ref.watch(streamJouetLesplusNotesProvider);

    return SizedBox(
      height: 220,
      child: jouetsAsync.when(
        data: (jouets) {
          if (jouets.isEmpty) {
            return const Center(
              child: Text(
                'Aucun jeu disponible',
                style: TextStyle(color: AppStyles.textMuted),
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
                  title: jouet.nomJouet ?? 'Jeu',
                  rating: (jouet.noteMoyen ?? 0.0).toStringAsFixed(1),
                  imageUrl: (jouet.image != null && jouet.image.isNotEmpty)
                      ? jouet.image.first
                      : null,
                  onTap: () {
                    context.pushNamed(AppRoutes.jouetDetail.name);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppStyles.primary),
        ),
        error: (error, stack) => const Center(
          child: Text(
            'Erreur lors du chargement des jeux',
            style: TextStyle(fontSize: 12, color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard({
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
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
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(
                              Icons.extension,
                              size: 48,
                              color: AppStyles.primary,
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.extension,
                            size: 48,
                            color: AppStyles.primary,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppStyles.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
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
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(), // Réduit la zone d'espace vide autour de l'icône
                        onPressed: () {
                          setState(() {
                            estFavori = !estFavori;
                          });
                        },
                        icon: Icon(
                          estFavori ? Icons.favorite : Icons.favorite_border,
                          color: estFavori ? Colors.red : Colors.black45,
                          size:
                              20, // Taille fixe et adaptée (ou SizeConfig.getProportionateWidth(20))
                        ),
                      ),
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

  // ============================================================
  // FAVORIS
  // ============================================================

  Widget _buildFavoritesList() {
    return SizedBox(
      height: 130,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          _buildFavoriteCard('Tours colorées'),
          const SizedBox(width: 12),
          _buildFavoriteCard('Mémoire'),
          const SizedBox(width: 12),
          _buildFavoriteCard('Calcul'),
          const SizedBox(width: 12),
          _buildFavoriteCard('Sciences'),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(String title) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
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
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.style, color: AppStyles.primary),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppStyles.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Voir plus',
              style: TextStyle(
                fontSize: 9,
                color: AppStyles.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
