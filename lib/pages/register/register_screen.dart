import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/commun_widget/common_button.dart';
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
  final _nomController         = TextEditingController();
  final _prenomController      = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final state = ref.watch(authControllerProvider);

    ref.listen<AsyncValue>(authControllerProvider, (_, state) {
      if (!state.isLoading && !state.hasError && state.hasValue) {
        state.showSuccessDialog(
          context,
          'Votre compte parent a été créé avec succès !',
          () async {
            await ref.read(authControllerProvider.notifier).logout();
            if (context.mounted) {
              context.goNamed(AppRoutes.login.name);
            }
          },
        );
      }
      state.showErrorDialog(context);
    });

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
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
              child: Column(
                children: [
                  Text(
                    'Inscription',
                    style: AppStyles.headingTextStyle.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                      fontSize: 30
                    ),
                  ),

                  // Logo
                  Hero(
                    tag: 'app_logo',
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: SizeConfig.getProportionateWidth(100),
                      height: SizeConfig.getProportionateHeight(100),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    'Inscrivez-vous sur ankan tolon',
                    style: AppStyles.titleTextStyle.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                      fontSize: 15
                    ),
                  ),


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
                    prefixIcon: Icons.send_outlined,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(12)),

                  CustomTextField(
                    label: 'Mot de passe',
                    hintText: '••••••••••••',
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    controller: _passwordController,
                    prefixIcon: Icons.visibility_off_outlined,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(24)),

                  CustomButton(
                    onTap: () {
                      ref.read(authControllerProvider.notifier).loginOrCreateUserWithEmailAndPassword(
                            email:       _emailController.text.trim(),
                            password:    _passwordController.text.trim(),
                            nom:         _nomController.text.trim(),
                            prenom:      _prenomController.text.trim(),
                            phoneNumber: _phoneNumberController.text.trim(),
                          );
                    },
                    title: "M'inscrire",
                    isLoading: state.isLoading,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(24)),
                  RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Vous avez un compte ? ',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: "Se connecter",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF0066CC),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.goNamed(AppRoutes.login.name);
                              },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}