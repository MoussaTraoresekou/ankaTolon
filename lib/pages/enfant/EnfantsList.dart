import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';
import 'package:tolon/repository/enfant/enfant_repository.dart';

class EnfantsListScreen extends ConsumerWidget {
  const EnfantsListScreen({super.key});

  static const List<Color> _avatarBgColors = [
    Color(0xFFE2F1E4),
    Color(0xFFFFF3D6),
    Color(0xFFEAE3FF),
  ];

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enfantsAsync = ref.watch(enfantsStreamProvider);

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
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
                      child: const Icon(
                        Icons.chevron_left,
                        color: AppStyles.textDark,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Mes enfants',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppStyles.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Liste des enfants
              Expanded(
                child: enfantsAsync.when(
                  data: (enfants) {
                    if (enfants.isEmpty) {
                      return const Center(
                        child: Text(
                          'Aucun enfant enregistré pour le moment',
                          style: TextStyle(color: AppStyles.textMuted),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: enfants.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final enfant = enfants[index];
                        final ageCalculated = _calculerAge(enfant.naissance);

                        final String fullName = (enfant.nom ?? '').isNotEmpty
                            ? '${enfant.prenom} ${enfant.nom}'
                            : (enfant.prenom ?? '');

                        final Color bgColor = _avatarBgColors.isNotEmpty
                            ? _avatarBgColors[index % _avatarBgColors.length]
                            : AppStyles.primarySoft;

                        return _buildEnfantItemCard(
                          fullName,
                          '$ageCalculated ans',
                          enfant.avatarUrl,
                          avatarBgColor: bgColor,
                          onTap: () {
                            context.pushNamed(
                              AppRoutes.enfantProfil.name,
                              extra: enfant,
                            );
                          },
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
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bouton d'ajout en bas
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => context.pushNamed(AppRoutes.addEnfant.name),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE07A28),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Ajouter un profil enfant',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildEnfantItemCard(
    String fullName,
    String ageText,
    String? avatarUrl, {
    required Color avatarBgColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF2D6A4F).withValues(alpha: 0.4),
          width: 1,
        ),
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
                CircleAvatar(
                  radius: 36,
                  backgroundColor: avatarBgColor,
                  child: ClipOval(
                    child: avatarUrl != null && avatarUrl.isNotEmpty
                        ? (avatarUrl.startsWith('http')
                              ? Image.network(
                                  avatarUrl,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.person,
                                    color: AppStyles.primary,
                                    size: 36,
                                  ),
                                )
                              : Image.asset(
                                  avatarUrl,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.person,
                                    color: AppStyles.primary,
                                    size: 36,
                                  ),
                                ))
                        : const Icon(
                            Icons.person,
                            color: AppStyles.primary,
                            size: 36,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppStyles.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F1E4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ageText,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D6A4F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppStyles.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
