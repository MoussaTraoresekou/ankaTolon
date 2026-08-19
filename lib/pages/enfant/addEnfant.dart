import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/commun_widget/common_button.dart';
import 'package:tolon/commun_widget/common_container_widget.dart';
import 'package:tolon/commun_widget/custom_text_field.dart';
import 'package:tolon/controller/enfant/enfant_controller.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/async_value_ui.dart';
import 'package:tolon/cor/utils/size_config.dart';

class AddEnfantScreen extends ConsumerStatefulWidget {
  const AddEnfantScreen({super.key});

  @override
  ConsumerState<AddEnfantScreen> createState() => _AddEnfantScreenState();
}

class _AddEnfantScreenState extends ConsumerState<AddEnfantScreen> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _dateNaissanceController = TextEditingController();

  DateTime? _dateNaissance;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _dateNaissanceController.dispose();
    super.dispose();
  }

  Future<void> _choisirDateNaissance() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 6)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 15)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _dateNaissance = date;
        _dateNaissanceController.text =
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      });
    }
  }

  Future<void> _onCreerTap() async {
    if (_dateNaissance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir une date de naissance !')),
      );
      return;
    }

    final succes = await ref.read(enfantControllerProvider.notifier).ajouterEnfant(
          nom: _nomController.text.trim(),
          prenom: _prenomController.text.trim(),
          naissance: _dateNaissance!,
        );

    if (!mounted) return;

    final state = ref.read(enfantControllerProvider);

    if (succes) {
      state.showSuccessDialog(
        context,
        'Enfant ajouté avec succès !',
        () {
          context.goNamed(AppRoutes.home.name);
        },
      );
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
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: SizeConfig.getProportionateHeight(100),
                    width: SizeConfig.getProportionateWidth(100),
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Ajouter un enfant',
                    style: AppStyles.titleTextStyle.copyWith(color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: Colors.black12, thickness: 1),
                  SizedBox(height: SizeConfig.getProportionateHeight(15)),

                  CustomTextField(
                    label: 'Nom',
                    hintText: 'Nom de l\'enfant',
                    keyboardType: TextInputType.name,
                    controller: _nomController,
                    prefixIcon: Icons.person_outline,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(12)),

                  CustomTextField(
                    label: 'Prénom',
                    hintText: 'Prénom de l\'enfant',
                    keyboardType: TextInputType.name,
                    controller: _prenomController,
                    prefixIcon: Icons.person_outline,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(12)),

                  GestureDetector(
                    onTap: _choisirDateNaissance,
                    child: AbsorbPointer(
                      child: CustomTextField(
                        label: 'Date de naissance',
                        hintText: 'JJ/MM/AAAA',
                        keyboardType: TextInputType.datetime,
                        controller: _dateNaissanceController,
                        prefixIcon: Icons.cake_outlined,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(24)),

                  CustomButton(
                    onTap: _onCreerTap,
                    title: 'Créer',
                    isLoading: state.isLoading,
                  ),
                  SizedBox(height: SizeConfig.getProportionateHeight(12)),

                  CommonContainer(
                    onTap: () => context.goNamed(AppRoutes.home.name),
                    text: 'Annuler',
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