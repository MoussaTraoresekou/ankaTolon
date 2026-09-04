import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/controller/enfant/enfant_controller.dart';
import 'package:tolon/cor/theme/app_theme.dart';

import 'package:tolon/models/enfant/enfant_modal.dart';
import 'package:tolon/repository/enfant/enfant_repository.dart';

class ChoisirAvatarScreen extends ConsumerStatefulWidget {
  final EnfantModel enfant;
  final Map<String, dynamic>? updatedData;

  const ChoisirAvatarScreen({
    super.key,
    required this.enfant,
    this.updatedData,
  });

  @override
  ConsumerState<ChoisirAvatarScreen> createState() =>
      _ChoisirAvatarScreenState();
}

class _ChoisirAvatarScreenState extends ConsumerState<ChoisirAvatarScreen> {
  final List<String> _avatars = [
    'assets/images/avatars/avatar1.jpg',
    'assets/images/avatars/avatar2.jpg',
    'assets/images/avatars/avatar3.jpg',
    'assets/images/avatars/avatar4.jpg',
    'assets/images/avatars/avatar5.jpg',
    'assets/images/avatars/avatar6.jpg',
    'assets/images/avatars/avatar7.jpg',
    'assets/images/avatars/avatar8.jpg',
    'assets/images/avatars/avatar9.jpg',
    'assets/images/avatars/avatar10.jpg',
    'assets/images/avatars/avatar11.jpg',
    'assets/images/avatars/avatar12.jpg',
  ];

  late String _selectedAvatar;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.enfant.avatarUrl ?? _avatars[1];
  }

  Future<void> _submitForm() async {
    setState(() => _isLoading = true);

    try {
      final updatedEnfant = widget.enfant.copyWith(
        nom: widget.updatedData?['nom'] ?? widget.enfant.nom,
        prenom: widget.updatedData?['prenom'] ?? widget.enfant.prenom,
        naissance: widget.updatedData?['naissance'] ?? widget.enfant.naissance,
        sexe: widget.updatedData?['sexe'] ?? widget.enfant.sexe,
        avatarUrl: _selectedAvatar,
      );

      // Appel de la méthode modifierEnfant du controller Riverpod
      final success = await ref
          .read(enfantControllerProvider.notifier)
          .modifierEnfant(updatedEnfant);

      if (mounted && success) {
        if (success) {
          ref.invalidate(enfantsStreamProvider);
          context.pop(updatedEnfant);
        } else {
          final state = ref.read(enfantControllerProvider);
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.toString()),
                backgroundColor: context.badgeRed,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la mise à jour : $e'),
            backgroundColor: context.badgeRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: context.bgColor,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: context.textDark,
              ),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choisir un avatar',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sélectionnez un avatar que votre enfant aime',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _avatars.length,
                  itemBuilder: (context, index) {
                    final avatarPath = _avatars[index];
                    final isSelected = _selectedAvatar == avatarPath;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatar = avatarPath;
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                color: isSelected
                                    ? context.primary
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(36),
                              child: Image.asset(
                                avatarPath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (_, _, _) => Container(
                                  color: Colors.grey.shade300,
                                  child: Icon(Icons.person, size: 40),
                                ),
                              ),
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: context.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: context.textInverse,
                                  size: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: context.boxSurfaceLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: context.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Vous pouvez le changer plus tard dans le profil',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Terminer',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.textInverse,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
