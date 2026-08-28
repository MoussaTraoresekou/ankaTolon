import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:tolon/commun_widget/common_button.dart';
import 'package:tolon/commun_widget/custom_text_field.dart';
import 'package:tolon/controller/auth/auth_controller.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/async_value_ui.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/repository/authRepository/auth_repository.dart';

class ModifierProfilParent extends ConsumerStatefulWidget {
  const ModifierProfilParent({super.key});

  @override
  ConsumerState<ModifierProfilParent> createState() =>
      _ModifierProfilParentState();
}

class _ModifierProfilParentState extends ConsumerState<ModifierProfilParent> {
  late final TextEditingController _nomController;
  late final TextEditingController _prenomController;
  late final TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();

    _nomController = TextEditingController();
    _prenomController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final state = ref.watch(authControllerProvider);
    final userData = ref.watch(userDataProvider);

    ref.listen<AsyncValue>(authControllerProvider, (_, state) {
      if (!state.isLoading && !state.hasError && state.hasValue) {
        state.showSuccessDialog(
          context,
          'Votre profil a été modifié avec succès !',
          () {
            if (context.mounted) {
              context.pop();
            }
          },
        );
      }

      state.showErrorDialog(context);
    });

    return userData.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        backgroundColor: AppStyles.bgColor,
        body: Center(
          child: Text(
            'Impossible de récupérer vos informations.',
            style: AppStyles.normalTextStyle,
          ),
        ),
      ),
      data: (user) {
        if (user == null) {
          return Scaffold(
            backgroundColor: AppStyles.bgColor,
            body: const Center(child: Text('Aucun utilisateur connecté.')),
          );
        }

        if (_nomController.text.isEmpty &&
            _prenomController.text.isEmpty &&
            _phoneNumberController.text.isEmpty) {
          _nomController.text = user.nom;
          _prenomController.text = user.prenom;
          _phoneNumberController.text = user.phoneNumber;
        }

        return Scaffold(
          backgroundColor: AppStyles.bgColor,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.getProportionateWidth(16),
                SizeConfig.getProportionateHeight(30),
                SizeConfig.getProportionateWidth(16),
                0,
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            'Modifier mon profil',
                            textAlign: TextAlign.center,
                            style: AppStyles.headingTextStyle.copyWith(
                              color: AppStyles.textDark,
                              fontWeight: FontWeight.w800,
                              fontSize: 26,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () => context.pop(),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE5F1E7),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 16,
                                  color: AppStyles.textDark,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: SizeConfig.getProportionateHeight(30)),

                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF4F6F5),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.black26,
                        ),
                      ),

                      SizedBox(height: SizeConfig.getProportionateHeight(24)),

                      CustomTextField(
                        label: 'Nom',
                        hintText: 'Votre nom',
                        keyboardType: TextInputType.name,
                        controller: _nomController,
                        prefixIcon: Icons.person_outline,
                      ),

                      SizedBox(height: SizeConfig.getProportionateHeight(12)),

                      CustomTextField(
                        label: 'Prénom',
                        hintText: 'Votre prénom',
                        keyboardType: TextInputType.name,
                        controller: _prenomController,
                        prefixIcon: Icons.person_outline,
                      ),

                      SizedBox(height: SizeConfig.getProportionateHeight(12)),

                      CustomTextField(
                        label: 'Numéro de téléphone',
                        hintText: 'Ex: 76000000',
                        keyboardType: TextInputType.phone,
                        controller: _phoneNumberController,
                        prefixIcon: Icons.phone_outlined,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                        ],
                      ),

                      SizedBox(height: SizeConfig.getProportionateHeight(28)),

                      CustomButton(
                        onTap: () {
                          ref
                              .read(authControllerProvider.notifier)
                              .modifierInformation(
                                nom: _nomController.text.trim(),
                                prenom: _prenomController.text.trim(),
                                phoneNumber: _phoneNumberController.text.trim(),
                              );
                        },
                        title: 'Enregistrer les modifications',
                        isLoading: state.isLoading,
                      ),

                      SizedBox(height: SizeConfig.getProportionateHeight(12)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
