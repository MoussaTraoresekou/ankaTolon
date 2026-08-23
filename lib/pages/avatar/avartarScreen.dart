import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/commun_widget/common_button.dart';
import 'package:tolon/controller/enfant/enfant_controller.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/async_value_ui.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/models/enfant/enfant_avant_choix_avartar.dart';
import 'package:tolon/repository/avartarRepository/avatar.dart';

class AvatarSelectionScreen extends ConsumerStatefulWidget {
  const AvatarSelectionScreen({super.key, required this.draft});

  final EnfantInfoAvantchoixAvatar draft;

  @override
  ConsumerState<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends ConsumerState<AvatarSelectionScreen> {
  String? _avatarSelectionne;

  Future<void> _onTerminerTap() async {
    if (_avatarSelectionne == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir un avatar !')),
      );
      return;
    }

    final succes = await ref.read(enfantControllerProvider.notifier).ajouterEnfant(
          nom: widget.draft.nom,
          prenom: widget.draft.prenom,
          naissance: widget.draft.naissance,
          sexe: widget.draft.sexe,
          avatarUrl: _avatarSelectionne,
        );

    if (!mounted) return;

    final state = ref.read(enfantControllerProvider);

    if (succes) {
      state.showSuccessDialog(context, 'Enfant ajouté avec succès !', () {
        context.goNamed(AppRoutes.home.name);
      });
    } else {
      state.showErrorDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final avatarsAsync = ref.watch(avatarUrlsProvider);
    final state = ref.watch(enfantControllerProvider);

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.getProportionateWidth(16),
                SizeConfig.getProportionateHeight(16),
                SizeConfig.getProportionateWidth(16),
                0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5F1E7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.getProportionateHeight(12)),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionateWidth(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choisir un avatar',
                    style: AppStyles.headingTextStyle.copyWith(color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sélectionnez un avatar que votre enfant aime',
                    style: AppStyles.normalTextStyle.copyWith(color: Colors.black45),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.getProportionateHeight(16)),

            Expanded(
              child: avatarsAsync.when(
                data: (avatars) => GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionateWidth(16),
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: avatars.length,
                  itemBuilder: (context, index) {
                    final url = avatars[index];
                    final estSelectionne = url == _avatarSelectionne;

                    return GestureDetector(
                      onTap: () => setState(() => _avatarSelectionne = url),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: estSelectionne
                                    ? const Color(0xFF6FB565)
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFFF0F0F0),
                                child: const Icon(Icons.person, color: Colors.black26),
                              ),
                            ),
                          ),
                          if (estSelectionne)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF6FB565),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check, color: Colors.white, size: 14),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Erreur : $error')),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.getProportionateWidth(16),
                SizeConfig.getProportionateHeight(12),
                SizeConfig.getProportionateWidth(16),
                SizeConfig.getProportionateHeight(16),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF7F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline, color: Color(0xFF6FB565), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Vous pouvez le changer plus tard dans le profil',
                            style: AppStyles.normalTextStyle.copyWith(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(12)),
                  CustomButton(
                    onTap: _onTerminerTap,
                    title: 'Terminer',
                    isLoading: state.isLoading,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}