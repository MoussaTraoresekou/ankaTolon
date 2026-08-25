import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/commun_widget/common_button.dart';
import 'package:tolon/controller/enfant/enfant_controller.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/async_value_ui.dart';
import 'package:tolon/cor/utils/size_config.dart';

class SelectAvatarScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> dataEnfant;

  const SelectAvatarScreen({super.key, required this.dataEnfant});

  @override
  ConsumerState<SelectAvatarScreen> createState() => _SelectAvatarScreenState();
}

class _SelectAvatarScreenState extends ConsumerState<SelectAvatarScreen> {
  // Liste des images d'avatars (remplace les chemins par tes assets)
  final List<String> _avatars = [
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar2.png',
    'assets/images/avatars/avatar3.png',
    'assets/images/avatars/avatar2.png',
    'assets/images/avatars/avatar3.png',
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar3.png',
    'assets/images/avatars/avatar2.png',
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar2.png',
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar3.png',
  ];

  int _selectedAvatarIndex = 1; // Index sélectionné par défaut

  Future<void> _onTerminerTap() async {
    final avatarSelectionne = _avatars[_selectedAvatarIndex];

    final succes = await ref
        .read(enfantControllerProvider.notifier)
        .ajouterEnfant(
          nom: widget.dataEnfant['nom'],
          prenom: widget.dataEnfant['prenom'],
          naissance: widget.dataEnfant['naissance'] as DateTime,
          sexe: widget.dataEnfant['sexe'],
          avatarUrl: avatarSelectionne, 
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
    final state = ref.watch(enfantControllerProvider);

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportionateWidth(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.getProportionateHeight(16)),

              // Bouton Retour
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F2EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.black87,
                  ),
                ),
              ),

              SizedBox(height: SizeConfig.getProportionateHeight(16)),

              // Titre et sous-titre
              const Text(
                'Choisir un avatar',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sélectionnez un avatar que votre enfant aime',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),

              SizedBox(height: SizeConfig.getProportionateHeight(20)),

              // Grille des Avatars (3 par ligne)
              Expanded(
                child: GridView.builder(
                  itemCount: _avatars.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedAvatarIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatarIndex = index;
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF4CD97B)
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                _avatars[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  // Widget de fallback si l'image n'est pas encore ajoutée aux assets
                                  return Container(
                                    color: const Color(0xFFE0F2E9),
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.teal,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          // Badge de validation vert
                          if (isSelected)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4CD97B),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bannières d'information sous la grille
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4EC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF4CD97B),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Vous pouvez le changer plus tard dans le profil',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bouton Terminer
              CustomButton(
                onTap: _onTerminerTap,
                title: 'Terminer',
                isLoading: state.isLoading,
              ),
              SizedBox(height: SizeConfig.getProportionateHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
