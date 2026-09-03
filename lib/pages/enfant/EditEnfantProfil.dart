import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/enfant/enfant_modal.dart';

class EditEnfantProfilScreen extends StatefulWidget {
  final EnfantModel enfant;

  const EditEnfantProfilScreen({super.key, required this.enfant});

  @override
  State<EditEnfantProfilScreen> createState() => _EditEnfantProfilScreenState();
}

class _EditEnfantProfilScreenState extends State<EditEnfantProfilScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _dateController;

  DateTime? _selectedDate;
  String? _selectedSexe;

  final List<String> _sexeOptions = ['Garçon', 'Fille'];

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.enfant.nom);
    _prenomController = TextEditingController(text: widget.enfant.prenom);
    _selectedDate = widget.enfant.naissance;

    if (_selectedDate != null) {
      _dateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(_selectedDate!),
      );
    } else {
      _dateController = TextEditingController();
    }

    // Récupération et normalisation du sexe de l'enfant
    final initialSexe = widget.enfant.sexe;
    if (initialSexe.isNotEmpty) {
      _selectedSexe = _sexeOptions.firstWhere(
        (option) => option.toLowerCase() == initialSexe.toLowerCase(),
        orElse: () => 'Garçon',
      );
    } else {
      _selectedSexe = 'Garçon';
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.primary,
              onPrimary: context.textInverse,
              onSurface: context.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: context.bgColor,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: context.textDark,
              ),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: Text(
          'Modifier un profil Enfant',
          style: TextStyle(
            color: context.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom
                _buildLabel('Nom'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _nomController,
                  hintText: 'Entrez le nom ',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 20),

                // Prénom
                _buildLabel('Prénom'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _prenomController,
                  hintText: 'Entrez le prénom',
                  prefixIcon: Icons.text_fields_rounded,
                ),
                const SizedBox(height: 20),

                // Date de naissance
                _buildLabel('Date de naissance'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _dateController,
                  hintText: '02/09/2006',
                  prefixIcon: Icons.calendar_today_outlined,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 20),

                // Sexe
                _buildLabel('Sexe'),
                const SizedBox(height: 8),
                _buildDropdownSexe(),

                const SizedBox(height: 48),

                // Bouton Suivant
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final updatedData = {
                          'nom': _nomController.text.trim(),
                          'prenom': _prenomController.text.trim(),
                          'naissance': _selectedDate,
                          'sexe': _selectedSexe,
                        };

                        // 1. Récupère l'enfant retourné par ChoisirAvatarScreen
                        final EnfantModel? result = await context
                            .pushNamed<EnfantModel>(
                              AppRoutes.choisirAvatar.name,
                              extra: {
                                'enfant': widget.enfant,
                                'updatedData': updatedData,
                              },
                            );

                        // 2. Si un enfant mis à jour est renvoyé, on le ferme vers le Profil Screen principal
                        if (result != null && mounted) {
                          context.pop(result);
                        }
                      }
                    },
                    child: Text(
                      'Suivant',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.textInverse,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: context.textDark,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(fontSize: 16, color: context.textDark),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ce champ est obligatoire';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF558B2F)),
        filled: true,
        fillColor: context.textInverse,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.borderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF558B2F), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.badgeRed, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.badgeRed, width: 1.8),
        ),
      ),
    );
  }

  Widget _buildDropdownSexe() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedSexe,
      icon: Icon(Icons.keyboard_arrow_down, color: context.textDark),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.accessibility_new_rounded,
          color: Color(0xFF558B2F),
        ),
        filled: true,
        fillColor: context.textInverse,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.borderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF558B2F), width: 1.8),
        ),
      ),
      items: _sexeOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: context.textDark),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedSexe = newValue;
        });
      },
    );
  }
}
