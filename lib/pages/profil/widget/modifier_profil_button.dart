import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tolon/commun_widget/custom_text_field.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/auth/user_modal.dart';

class ModifierProfilButton extends StatelessWidget {
  final UserModel? utilisateur;

  const ModifierProfilButton({super.key, required this.utilisateur});

  void _ouvrirDialogueModification(BuildContext context) {
    if (utilisateur == null) return;

    final prenomController = TextEditingController(text: utilisateur!.prenom);
    final nomController = TextEditingController(text: utilisateur!.nom);
    final phoneController = TextEditingController(
      text: utilisateur!.phoneNumber,
    );
    final formKey = GlobalKey<FormState>();
    bool isChargement = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.textInverse,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> enregistrerModifications() async {
              if (!formKey.currentState!.validate()) return;

              setState(() => isChargement = true);

              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(utilisateur!.uid)
                    .update({
                      'prenom': prenomController.text.trim(),
                      'nom': nomController.text.trim(),
                      'phoneNumber': phoneController.text.trim(),
                    });

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profil mis à jour avec succès !'),
                      backgroundColor: context.primary,
                    ),
                  );
                }
              } catch (e) {
                setState(() => isChargement = false);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur lors de la mise à jour : $e'),
                      backgroundColor: context.badgeRed,
                    ),
                  );
                }
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Modifier mon profil',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: context.textDark,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Champ Prénom
                      CustomTextField(
                        label: 'Prénom',
                        hintText: 'Votre prénom',
                        controller: prenomController,
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 12),

                      // Champ Nom
                      CustomTextField(
                        label: 'Nom',
                        hintText: 'Votre nom',
                        controller: nomController,
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 12),

                      // Champ Téléphone
                      CustomTextField(
                        label: 'Téléphone',
                        hintText: '+223 00 00 00 00',
                        keyboardType: TextInputType.phone,
                        prefixIconColor: context.badgeRed,
                        controller: phoneController,
                        prefixIcon: Icons.phone_outlined,
                      ),
                      const SizedBox(height: 20),

                      // Bouton Enregistrer
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isChargement
                              ? null
                              : enregistrerModifications,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primaryOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: isChargement
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: context.textInverse,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Enregistrer',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: context.textInverse,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: utilisateur == null
            ? null
            : () => _ouvrirDialogueModification(context),
        icon: Icon(Icons.edit_outlined, size: 20),
        label: const Text(
          'Modifier mon profil',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: context.primaryOrange,
          side: BorderSide(color: context.primaryOrange, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
