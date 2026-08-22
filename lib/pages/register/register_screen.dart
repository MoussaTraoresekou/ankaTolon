import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/commun_widget/common_button.dart';
import 'package:tolon/commun_widget/common_container_widget.dart';
import 'package:tolon/commun_widget/custom_text_field.dart';
import 'package:tolon/controller/auth/auth_controller.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/async_value_ui.dart';
import 'package:tolon/cor/utils/size_config.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController       = TextEditingController();
  final _passwordController    = TextEditingController();
  final _nameController        = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final state = ref.watch(authControllerProvider);

    // Écoute de l'état asynchrone envoyé par l'authController
    ref.listen<AsyncValue>(authControllerProvider, (_, state) {
      if (!state.isLoading && !state.hasError && state.hasValue) {
        // Déclenchement du dialogue graphique de succès
        state.showSuccessDialog(
          context, 
          'Votre compte parent a été créé avec succès !', 
          () async {
            // 1. Déconnexion forcée en arrière-plan pour annuler la session automatique
            await ref.read(authControllerProvider.notifier).logout();
            
            if (context.mounted) {
              // 2. Redirection manuelle et propre vers l'écran de saisie des identifiants
              context.goNamed(AppRoutes.login.name);
            }
          },
        );
      }
      // Affichage du pop-up d'erreur rouge si Firebase rejette la requête (ex: mail déjà pris)
      state.showErrorDialog(context);
    });

    return Scaffold(
      backgroundColor: AppStyles.pastelBg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.getProportionateWidth(16),
            SizeConfig.getProportionateHeight(40),
            SizeConfig.getProportionateWidth(16),
            0,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Logo lié à l'animation Hero du SplashScreen
                  Hero(
                    tag: 'app_logo',
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: SizeConfig.getProportionateHeight(100),
                      width: SizeConfig.getProportionateWidth(100),
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Inscription du parent',
                    style: AppStyles.titleTextStyle.copyWith(color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Colors.black12, thickness: 1),
                  SizedBox(height: SizeConfig.getProportionateHeight(15)),

                  CustomTextField(
                    label: 'Nom complet',
                    hintText: 'Votre nom complet',
                    keyboardType: TextInputType.name,
                    controller: _nameController,
                    prefixIcon: Icons.person_outline,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(12)),

                  CustomTextField(
                    label: 'Numéro de téléphone',
                    hintText: 'Ex: 76 00 00 00',
                    keyboardType: TextInputType.phone,
                    controller: _phoneNumberController,
                    prefixIcon: Icons.phone_outlined,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(12)),

                  CustomTextField(
                    label: 'Adresse Email',
                    hintText: 'parent@email.com',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(12)),

                  CustomTextField(
                    label: 'Mot de passe',
                    hintText: '••••••••••••',
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outline,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(24)),

                  CustomButton(
                    onTap: () {
                      ref.read(authControllerProvider.notifier).loginOrCreateUserWithEmailAndPassword(
                            email:       _emailController.text.trim(),
                            password:    _passwordController.text.trim(),
                            name:        _nameController.text.trim(),
                            phoneNumber: _phoneNumberController.text.trim(),
                            type:        'parent',
                          );
                    },
                    title: "M'inscrire",
                    isLoading: state.isLoading,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(20)),
                  Text(
                    'OU',
                    style: AppStyles.normalTextStyle.copyWith(
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(20)),

                  CommonContainer(
                    onTap: () => context.goNamed(AppRoutes.login.name),
                    text: 'Me connecter à un compte existant',
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
