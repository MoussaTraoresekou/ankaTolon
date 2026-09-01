import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/repository/jouets_reposotory/jouet_repository.dart';

class JeuxListScreen extends ConsumerWidget {
  const JeuxListScreen({super.key});

  static const List<Color> _iconBgColors = [
    Color(0xFFFFF3D6),
    Color(0xFFE2F1E4),
    Color(0xFFEAE3FF),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jeuxAsync = ref.watch(streamJouetLesplusNotesProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE2F1E4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: context.textDark,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Jeux les plus notés',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: context.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Liste des jeux
              Expanded(
                child: jeuxAsync.when(
                  data: (jeux) {
                    if (jeux.isEmpty) {
                      return Center(
                        child: Text(
                          'Aucun jeu disponible pour le moment',
                          style: TextStyle(color: context.textMuted),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: jeux.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final jeu = jeux[index];
                        final Color bgColor = _iconBgColors.isNotEmpty
                            ? _iconBgColors[index % _iconBgColors.length]
                            : context.primarySoft;

                        return _buildJeuItemCard(
                          context: context,
                          title: jeu.nomJouet ?? 'Jeu sans nom',
                          note: jeu.noteMoyen ?? 5.0,
                          images: jeu.image,
                          bgColor: bgColor,
                          onTap: () {
                            context.pushNamed(
                              AppRoutes.jouetDetail.name,
                              extra: jeu,
                            );
                          },
                        );
                      },
                    );
                  },
                  loading: () => Center(
                    child: CircularProgressIndicator(color: context.primary),
                  ),
                  error: (error, stack) => const Center(
                    child: Text(
                      'Erreur de chargement des jeux',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJeuItemCard({
    required BuildContext context,
    required String title,
    required double note,
    List<String>? images,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    // Récupération de la première image
    final String? firstImage = images != null && images.isNotEmpty
        ? images.first
        : null;

    return Container(
      decoration: BoxDecoration(
        color: context.textInverse,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.borderColor, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Vignette du jeu
                CircleAvatar(
                  radius: 36,
                  backgroundColor: bgColor,
                  child: ClipOval(
                    child: firstImage != null && firstImage.isNotEmpty
                        ? (firstImage.startsWith('http')
                              ? Image.network(
                                  firstImage,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Icon(
                                    Icons.sports_esports,
                                    color: context.primary,
                                    size: 36,
                                  ),
                                )
                              : Image.asset(
                                  firstImage,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Icon(
                                    Icons.sports_esports,
                                    color: context.primary,
                                    size: 36,
                                  ),
                                ))
                        : Icon(
                            Icons.sports_esports,
                            color: context.primary,
                            size: 36,
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                // Informations du jeu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: context.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB800),
                            size: 18,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            note.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: context.textDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: context.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
