import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/controller/profil/profil_controller.dart';
import 'package:tolon/cor/app_colors.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/pages/profil/widget/bouton_deconnexion.dart';

class AdminProfil extends ConsumerStatefulWidget {
  const AdminProfil({super.key});

  @override
  ConsumerState<AdminProfil> createState() => _AdminProfilState();
}

class _AdminProfilState extends ConsumerState<AdminProfil> {
  bool _isEditing = false;
  bool _isLoading = false;

  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    
    // Valeurs initiales (À coupler plus tard avec ton flux utilisateur de session)
    _nomController = TextEditingController(text: 'Tolon');
    _prenomController = TextEditingController(text: 'Admin');
    _phoneController = TextEditingController(text: '+223 70 00 00 00');
  }

  Future<void> _sauvegarderProfil() async {
    setState(() => _isLoading = true);
    try {
      final user = ref.read(firebaseAuthProvider).currentUser;
      if (user != null) {

        // Mise à jour en direct sur Firestore
        await ref.read(firestoreProvider).collection('users').doc(user.uid).update({
          'nom': _nomController.text.trim(),
          'prenom': _prenomController.text.trim(),
          'phoneNumber': _phoneController.text.trim(),
        });

        setState(() => _isEditing = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil administrateur mis à jour !'), backgroundColor: AppColors.greenPrimary),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.redAccent));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firebaseAuthProvider).currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F5),
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
       
        // LE BOUTON RETOUR INTELLIGENT
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            backgroundColor: AppColors.greenPrimary.withValues(alpha: 0.1),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14,
                color: AppColors.textDark,
              ),
              onPressed: () => Navigator.of(context).pop(), 

            ),
          ),
        ),

        title: const Text('Profil Admin', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.cancel_outlined : Icons.edit_outlined, color: AppColors.textDark),
            onPressed: () => setState(() => _isEditing = !_isEditing),
          )
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.greenPrimary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.greenPrimary.withValues(alpha: 0.1),
                      backgroundImage: AssetImage("assets/images/adminProfil.png"),
                     // child: const Icon(Icons.admin_panel_settings_rounded, size: 60, color: AppColors.greenPrimary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(user?.email ?? 'ankatolon@gmail.com', style: const TextStyle(fontSize: 14, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 32),

                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.greenPrimary, style: BorderStyle.solid),
                      
                    ),
                    child: Column(
                      children: [
                        _buildField('Prénom', _prenomController, Icons.person_outline),
                        const SizedBox(height: 16),
                        _buildField('Nom', _nomController, Icons.abc),
                        const SizedBox(height: 16),
                        _buildField('Téléphone', _phoneController, Icons.phone_outlined),
                      ],
                    ),
                  ),
                  
                  if (_isEditing) ...[
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orangeSecondary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: _sauvegarderProfil,
                        child: const Text('Enregistrer les modifications', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],

                  SizedBox(height: 50,),

                  BoutonDeconnexion(
                      onPressed: () async {
                        await ref
                            .read(profilControllerProvider.notifier)
                            .deconnexion();
                      },
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Quicksand', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: _isEditing,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textDark, size: 20),
            filled: !_isEditing,
            fillColor: const Color.fromARGB(255, 245, 136, 136),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(style: BorderStyle.solid, color: AppColors.greenPrimary)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFECECEC))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.greenPrimary)),
          ),
        ),
      ],
    );
  }
}
