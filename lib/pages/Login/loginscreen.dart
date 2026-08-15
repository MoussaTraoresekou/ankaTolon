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


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final state = ref.watch(authControllerProvider);

    ref.listen<AsyncValue>(authControllerProvider, (_, state) {
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [

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

                  const SizedBox(height: 16),

                  // Titre
                  Text(
                    'Connectez-vous à votre compte',
                    style: AppStyles.titleTextStyle.copyWith(
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: SizeConfig.getProportionateHeight(24)),

                  // Email
                  CustomTextField(
                    label: 'Adresse Email',
                    hintText: 'exemple@email.com',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                  ),

                  SizedBox(height: SizeConfig.getProportionateHeight(16)),

                  // Mot de passe
                  CustomTextField(
                    label: 'Mot de passe',
                    hintText: '••••••••••••',
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outline,
                  ),

                  SizedBox(height: SizeConfig.getProportionateHeight(24)),

                  // Bouton connexion
                  CustomButton(
                    onTap: () {
                      ref
                          .read(authControllerProvider.notifier)
                          .signInWithEmailAndPassword(
                            email:    _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                    },
                    title: 'Se connecter',
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

                  // Créer un compte
                  CommonContainer(
                    onTap: () => context.goNamed(AppRoutes.register.name),
                    text: 'Créer un compte parent',
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