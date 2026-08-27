import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/commun_widget/common_button.dart';
import 'package:tolon/commun_widget/custom_text_field.dart';
import 'package:tolon/controller/auth/auth_controller.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/async_value_ui.dart';
import 'package:tolon/cor/utils/size_config.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onEnvoyerTap() async {
    final succes = await ref
        .read(authControllerProvider.notifier)
        .reinitialiserMotDePasse(email: _emailController.text);

    if (!mounted) return;

    final state = ref.read(authControllerProvider);

    if (succes) {
      state.showSuccessDialog(
        context,
        'Un lien de réinitialisation a été envoyé à votre adresse email.',
        () => context.pop(),
      );
    } else {
      state.showErrorDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final state = ref.watch(authControllerProvider);

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'Mot de passe oublié',
                      textAlign: TextAlign.center,
                      style: AppStyles.headingTextStyle.copyWith(color: Colors.black87),
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
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(16)),

                Text(
                  'Entrez votre adresse email, nous vous enverrons un lien pour réinitialiser votre mot de passe.',
                  textAlign: TextAlign.center,
                  style: AppStyles.normalTextStyle.copyWith(color: Colors.black54),
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(28)),

                CustomTextField(
                  label: 'Adresse Email',
                  hintText: 'exemple@email.com',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(28)),

                CustomButton(
                  onTap: _onEnvoyerTap,
                  title: 'Envoyer le lien',
                  isLoading: state.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}