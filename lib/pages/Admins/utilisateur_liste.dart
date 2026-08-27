import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/commun_widget/admin_widgets/card_parent_liste.dart';
import 'package:tolon/controller/admin_controller/listeParent_providers.dart';
import 'package:tolon/cor/app_colors.dart';



class ParentsList extends ConsumerStatefulWidget {
  const ParentsList({super.key});

  @override
  ConsumerState<ParentsList> createState() => _ParentsListState();
}

class _ParentsListState extends ConsumerState<ParentsList> {
  String searchQuery = ""; 

  @override
  Widget build(BuildContext context) {
    final parentsAsync = ref.watch(parentsStreamProvider);

    return Scaffold(
      
      // Le fond vert/clair très discret en arrière-plan derrière l'AppBar
      backgroundColor: const Color(0xFFF4F9F5), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            backgroundColor: AppColors.greenPrimary.withValues(alpha: 0.1), // Bouton retour blanc sur fond clair
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.textDark),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
       
        title: const Text(
          'Liste des parents',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        
      ),
      body: parentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.greenPrimary)),
        error: (err, stack) => Center(child: Text('Erreur : $err')),
        data: (parentsList) {
          final filteredList = parentsList.where((p) {
            final fullName = '${p.prenom} ${p.nom}'.toLowerCase();
            return fullName.contains(searchQuery.toLowerCase()) || p.email.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              const SizedBox(height: 50),

              // LA GRANDE CARTE BLANCHE 
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,

                    // Arrondis marqués uniquement en haut
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      
                      BoxShadow(
                        color: AppColors.greenPrimary.withValues(alpha: 0.40),
                        blurRadius: 20,
                        spreadRadius: 4,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //  BARRE DE RECHERCHE ARRONDIE
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: AppColors.greenPrimary.withValues(alpha: 0.2)),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration: const InputDecoration(
                              icon: Icon(Icons.search, color: AppColors.textGrey, size: 22),
                              hintText: 'Recherche un parent.....',
                              hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 14, fontFamily: 'Quicksand'),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // BANDEAU VERT DE COMPTAGE (Parents inscrits)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F4EC), 
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.greenPrimary, 
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(Icons.people_outline_rounded, color: Colors.white, size: 30),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${parentsList.length}', 
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.1),
                                  ),
                                  const Text(
                                    'Parents inscrits',
                                    style: TextStyle(fontSize: 15, color: AppColors.textDark, fontWeight: FontWeight.w600, fontFamily: 'Quicksand'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // LISTE DES PARENTS QUI SCROLLENT
                        filteredList.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Text('Aucun parent trouvé.', style: TextStyle(color: AppColors.textGrey, fontFamily: 'Quicksand')),
                                ),
                              )
                            : Column(
                                children: filteredList.map((parent) => ParentCard(parent: parent)).toList(),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
