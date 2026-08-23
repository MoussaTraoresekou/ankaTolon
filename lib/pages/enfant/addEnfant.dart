import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/commun_widget/common_button.dart';
import 'package:tolon/commun_widget/custom_text_field.dart';
import 'package:tolon/commun_widget/drop_down.dart';
import 'package:tolon/controller/enfant/enfant_controller.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/async_value_ui.dart';
import 'package:tolon/cor/utils/size_config.dart';
import 'package:tolon/models/enfant/enfant_avant_choix_avartar.dart';

class AddEnfantScreen extends ConsumerStatefulWidget {
  const AddEnfantScreen({super.key});

  @override
  ConsumerState<AddEnfantScreen> createState() => _AddEnfantScreenState();
}

class _AddEnfantScreenState extends ConsumerState<AddEnfantScreen> {
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final dateNaissanceController = TextEditingController();

  DateTime? _dateNaissance;
  String? _sexe;

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    dateNaissanceController.dispose();
    super.dispose();
  }

  Future<void> _choisirDateNaissance() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 6)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 15)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppStyles.navbarColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    setState(() {
      _dateNaissance = date;

      dateNaissanceController.text =
          '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    });
  }

  void _onSuivantTap() {
    final isValid = ref
        .read(enfantControllerProvider.notifier)
        .validerInformationsEnfant(
          nom: nomController.text,
          prenom: prenomController.text,
          naissance: _dateNaissance,
          sexe: _sexe,
        );

    if (!isValid) {
      return;
    }

    final enfantInfo = EnfantInfoAvantchoixAvatar(
      nom: nomController.text.trim(),
      prenom: prenomController.text.trim(),
      naissance: _dateNaissance!,
      sexe: _sexe!,
    );

    context.pushNamed(AppRoutes.addEnfantAvatar.name, extra: enfantInfo);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final state = ref.watch(enfantControllerProvider);

    ref.listen<AsyncValue>(enfantControllerProvider, (_, state) {
      state.showErrorDialog(context);
    });

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
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'Nouveau profil Enfant',
                        textAlign: TextAlign.center,
                        style: AppStyles.headingTextStyle.copyWith(
                          color: Colors.black87,
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.goNamed(AppRoutes.home.name);
                            }
                          },
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

                  const SizedBox(height: 8),

                  SizedBox(height: SizeConfig.getProportionateHeight(25)),

                  CustomTextField(
                    label: 'Nom',
                    hintText: 'Nom de l\'enfant',
                    keyboardType: TextInputType.name,
                    controller: nomController,
                    prefixIcon: Icons.person_outline_rounded,
                    prefixIconColor: AppStyles.navbarColor,
                  ),

                  SizedBox(height: SizeConfig.getProportionateHeight(12)),
                  CustomTextField(
                    label: 'Prénom',
                    hintText: 'Prénom de l\'enfant',
                    keyboardType: TextInputType.name,
                    controller: prenomController,
                    prefixIcon: Icons.person_outline_rounded,
                    prefixIconColor: AppStyles.navbarColor,
                  ),

                  SizedBox(height: SizeConfig.getProportionateHeight(12)),
                  GestureDetector(
                    onTap: _choisirDateNaissance,
                    child: AbsorbPointer(
                      child: CustomTextField(
                        label: 'Date de naissance',
                        hintText: 'JJ/MM/AAAA',
                        keyboardType: TextInputType.datetime,
                        controller: dateNaissanceController,
                        prefixIcon: Icons.calendar_today_rounded,
                        prefixIconColor: AppStyles.navbarColor,
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.getProportionateHeight(18)),

                  CustomDropdown<String>(
                    label: 'Sexe',
                    hintText: 'Sélectionner le sexe',
                    value: _sexe,
                    prefixIcon: Icons.person_outline_rounded,
                    prefixIconColor: AppStyles.navbarColor,
                    items: [
                      DropdownMenuItem(
                        value: 'Homme',
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.10),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.male_rounded,
                                size: 20,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Homme',
                              style: AppStyles.normalTextStyle.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Femme',
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.pink.withOpacity(0.10),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.female_rounded,
                                size: 20,
                                color: Colors.pink,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Femme',
                              style: AppStyles.normalTextStyle.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _sexe = value;
                      });
                    },
                  ),

                  SizedBox(height: SizeConfig.getProportionateHeight(28)),

                  CustomButton(
                    onTap: _onSuivantTap,
                    title: 'Suivant',
                    isLoading: state.isLoading,
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
