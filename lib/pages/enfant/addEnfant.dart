import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tolon/commun_widget/common_button.dart';
import 'package:tolon/commun_widget/custom_text_field.dart';
import 'package:tolon/controller/enfant/enfant_controller.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/cor/utils/size_config.dart';

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
  String? _sexeSelectionne;

  final List<String> _genres = ['Garçon', 'Fille'];

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    dateNaissanceController.dispose();
    super.dispose();
  }

  Future<void> _choisirDateNaissance() async {
    final now = DateTime.now();

    // 12 ans au plus ancien (ex: né en 2014)
    final firstDate = DateTime(now.year - 12, now.month, now.day);

    // 4 ans au plus récent (ex: né en 2019)
    final lastDate = DateTime(now.year - 4, now.month, now.day);

    // Date par défaut sélectionnée (10 ans par exemple)
    final initialDate = lastDate;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (date != null) {
      setState(() {
        _dateNaissance = date;
        dateNaissanceController.text =
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      });
    }
  }

  Future<void> _onSuivantTap() async {
    final nom = nomController.text.trim();
    final prenom = prenomController.text.trim();

    if (nom.isEmpty || prenom.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez renseigner le nom et le prénom !'),
        ),
      );
      return;
    }

    if (_dateNaissance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez choisir une date de naissance !'),
        ),
      );
      return;
    }

    if (_sexeSelectionne == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner le sexe !')),
      );
      return;
    }

    context.pushNamed(
      AppRoutes.selectAvatar.name,
      extra: {
        'nom': nom,
        'prenom': prenom,
        'naissance': _dateNaissance,
        'sexe': _sexeSelectionne,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final state = ref.watch(enfantControllerProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportionateWidth(20),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.getProportionateHeight(16)),

                      // En-tête : Bouton retour + Titre
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.goNamed(AppRoutes.home.name);
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: context.boxSurfaceLight,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: context.textDark,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Nouveau profil Enfant',
                              textAlign: TextAlign.center,
                              style: context.headingTextStyle.copyWith(
                                color: context.textDark,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),

                      SizedBox(height: SizeConfig.getProportionateHeight(32)),

                      // Champ Nom
                      CustomTextField(
                        label: 'Nom',
                        hintText: "Entrer le nom de l'enfant",
                        keyboardType: TextInputType.name,
                        controller: nomController,
                        prefixIcon: Icons.person_outline,
                      ),

                      SizedBox(height: SizeConfig.getProportionateHeight(16)),

                      // Champ Prénom
                      CustomTextField(
                        label: 'Prénom',
                        hintText: "Entrer le prenom de l'enfant",
                        keyboardType: TextInputType.name,
                        controller: prenomController,
                        prefixIcon: Icons.abc,
                      ),

                      SizedBox(height: SizeConfig.getProportionateHeight(16)),

                      // Champ Date de naissance
                      GestureDetector(
                        onTap: _choisirDateNaissance,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            label: 'Date de naissance',
                            hintText: 'Entrer sa date de naissance',
                            keyboardType: TextInputType.datetime,
                            controller: dateNaissanceController,
                            prefixIcon: Icons.calendar_today_outlined,
                          ),
                        ),
                      ),

                      SizedBox(height: SizeConfig.getProportionateHeight(16)),

                      // Champ Sexe (Dropdown)
                      Text(
                        'Sexe',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: context.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: context.textInverse,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _sexeSelectionne,
                            hint: Row(
                              children: [
                                Icon(
                                  Icons.accessibility_new,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Entrer son sexe',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            isExpanded: true,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: context.textDark,
                            ),
                            items: _genres.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  children: [
                                    Icon(
                                      value == 'Garçon'
                                          ? Icons.boy
                                          : Icons.girl,
                                      color: Colors.grey.shade700,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(value),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _sexeSelectionne = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bouton Suivant en bas
              CustomButton(
                onTap: _onSuivantTap,
                title: 'Suivant',
                isLoading: state.isLoading,
              ),
              SizedBox(height: SizeConfig.getProportionateHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
