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
import 'package:flutter/gestures.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
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
      backgroundColor: context.bgColor,
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
                  // Titre
                  Text(
                    'Connexion',
                    style: context.headingTextStyle.copyWith(
                      color: context.textDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
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
                    'Accédez à votre compte',
                    style: context.titleTextStyle.copyWith(
                      color: context.textDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(24)),
                  // Email
                  CustomTextField(
                    label: 'Email',
                    hintText: 'exemple@email.com',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    prefixIcon: Icons.send_outlined,
                  ),

                  SizedBox(height: SizeConfig.getProportionateHeight(16)),

                  // Mot de passe
                  CustomTextField(
                    label: 'Mot de passe',
                    hintText: '••••••••••••',
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    controller: _passwordController,
                    prefixIcon: Icons.visibility_off_outlined,
                  ),

                  SizedBox(height: SizeConfig.getProportionateHeight(9)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.pushNamed(AppRoutes.changermotdepasse.name);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Mot de passe oublié ?',
                              style: TextStyle(
                                fontSize: 10,
                                color: context.accentBlue,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(10)),

                  // Bouton connexion
                  CustomButton(
                    onTap: () {
                      ref
                          .read(authControllerProvider.notifier)
                          .signInWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                    },
                    title: 'Se connecter',
                    isLoading: state.isLoading,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(20)),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Pas de compte ? ',
                          style: TextStyle(
                            fontSize: 10,
                            color: context.textDark,
                          ),
                        ),
                        TextSpan(
                          text: "S'inscrire",
                          style: TextStyle(
                            fontSize: 10,
                            color: context.accentBlue,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.pushNamed(AppRoutes.register.name);
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
