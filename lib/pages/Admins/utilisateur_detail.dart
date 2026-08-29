import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/cor/app_colors.dart';
import 'package:tolon/controller/admin_controller/detailUtilisateur_providers.dart';
import 'package:tolon/commun_widget/admin_widgets/card_detail_cmd.dart';
import 'package:tolon/commun_widget/admin_widgets/ligne_info_cmd.dart';

class UserDetail extends ConsumerWidget {
  final String userId;

  const UserDetail({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDetailProvider(userId));

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            backgroundColor: AppColors.greenPrimary.withValues(alpha: 0.1),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppColors.textNoir,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Text(
          'Détails utilisateur',
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: userAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.greenPrimary),
        ),
        error: (err, stack) => Center(child: Text('Erreur : $err')),
        data: (dataContainer) {
          if (dataContainer == null) {
            return const Center(child: Text('Utilisateur introuvable.'));
          }

          final user = dataContainer.user;
          final enfantsList = dataContainer.enfants;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BLOC PARENT (UserModel)
                CardDetailCmd(
                  title: 'Informations parent',
                  icon: Icons.person_outline_rounded,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: AppColors.greenPrimary.withValues(
                              alpha: 0.1,
                            ),
                            child: const Icon(
                              Icons.account_circle_outlined,
                              size: 40,
                              color: AppColors.greenPrimary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${user.prenom} ${user.nom}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 60),

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F5E9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        user.type.name.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                Text(
                                  user.phoneNumber,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // LISTE D'ENFANTS (EnfantModel)
                CardDetailCmd(
                  title: 'Enfants',
                  icon: Icons.child_care_rounded,
                  child: enfantsList.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'Aucun enfant enregistré.',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontFamily: 'Quicksand',
                            ),
                          ),
                        )
                      : Column(
                          children: enfantsList.asMap().entries.map((entry) {
                            final int index = entry.key;
                            final enfant = entry.value;

                            final bday = enfant.naissance;
                            final String bdayStr =
                                '${bday.day.toString().padLeft(2, '0')}/${bday.month.toString().padLeft(2, '0')}/${bday.year}';
                            final int age = DateTime.now().year - bday.year;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // Séparateur discret s'il y a plus d'un enfant
                                if (index > 0)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.0,
                                    ),
                                    child: Divider(
                                      color: Color(0xFFF5F5F5),
                                      height: 1,
                                    ),
                                  ),

                                // En-tête Enfant : Photo, Prénom et Nom
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundColor: const Color(0xFFDDEDDF),
                                      backgroundImage:
                                          enfant.avatarUrl != null &&
                                              enfant.avatarUrl!.isNotEmpty
                                          ? NetworkImage(enfant.avatarUrl!)
                                          : null,
                                      child:
                                          enfant.avatarUrl == null ||
                                              enfant.avatarUrl!.isEmpty
                                          ? const Icon(
                                              Icons.face_rounded,
                                              size: 28,
                                              color: AppColors.textGrey,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${enfant.prenom} ${enfant.nom}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                          const SizedBox(height: 15),

                                          // Alignement horizontal des Badges d'âge et de niveau sous le nom
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFE8F5E9,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '$age ans',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFF7DDC4,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  'Niveau ${enfant.niveau}',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFFE67E22),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),
                                
                                // Informations chiffrées de l'enfant
                                LigneInfoCmd(
                                  icon: Icons.cake_outlined,
                                  label: 'Date de naissance',
                                  value: bdayStr,
                                ),
                                LigneInfoCmd(
                                  icon: Icons.star_outline_rounded,
                                  label: 'Points cumulés',
                                  value: '${enfant.points} XP',
                                ),
                                LigneInfoCmd(
                                  icon: Icons.insights_rounded,
                                  label: 'Activités réalisées',
                                  value: '${enfant.activitesRealisees}',
                                ),
                                LigneInfoCmd(
                                  icon: Icons.emoji_events_outlined,
                                  label: 'Défis relevés',
                                  value: '${enfant.defisRealises.length}',
                                ),
                                LigneInfoCmd(
                                  icon: Icons.download_done_rounded,
                                  label: 'Tutos téléchargés',
                                  value: '${enfant.tutosTelecharges.length}',
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
