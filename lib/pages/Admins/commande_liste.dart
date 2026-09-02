import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/commun_widget/admin_widgets/card_commande_liste.dart';
import 'package:tolon/controller/admin_controller/listeCommande_providers.dart';
import 'package:tolon/cor/app_colors.dart';


class CommandeListe extends ConsumerStatefulWidget {
  const CommandeListe({super.key});

  @override
  ConsumerState<CommandeListe> createState() => _CommandeListeState();
}

class _CommandeListeState extends ConsumerState<CommandeListe> {
  
  // Onglet de filtrage sélectionné par défaut
  String selectedFilter = "Toutes"; 

  // Liste des catégories d'onglets de votre image
  final List<String> filters = ["Toutes", "En cours", "Livrer", "Annuler"];

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9F5), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFE2EDE2),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.textDark),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Text(
          'Liste des commandes',
          style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold, color: AppColors.textDark, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          
          // BARRE HORIZONTALE DES ONGLETS DE FILTRAGE
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final bool isSelected = selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ChoiceChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isSelected ? Colors.white : AppColors.textDark,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.greenPrimary,
                   backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: isSelected ? Colors.transparent : const Color(0xFFECECEC)),
                    ),
                    showCheckmark: false,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          selectedFilter = filter; // Filtre local instantané
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // LA GRANDE FEUILLE BLANCHE ARRONDIE QUI EMBALLE LE SCROLL
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greenPrimary.withValues(alpha: 0.05),
                    blurRadius: 20,
                    spreadRadius: 4,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ordersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.greenPrimary)),
                error: (err, stack) => Center(child: Text('Erreur : $err')),
                data: (ordersList) {
                  
                  // Tri local intelligent selon l'onglet sélectionné
                  final filteredList = ordersList.where((order) {
                    if (selectedFilter == "Toutes") return true;
                    
                    final String s = order.status.toLowerCase().trim();
                    if (selectedFilter == "En cours") {
                      return s == "en cours" || s == "en preparation";
                    } else if (selectedFilter == "Livrer") {
                      return s == "livrer" || s == "livree" || s == "confimée" || s == "confirmée";
                    } else if (selectedFilter == "Annuler") {
                      return s == "annuler" || s == "annulée";
                    }
                    return true;
                  }).toList();

                  return filteredList.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'Aucune commande "$selectedFilter"',
                              style: const TextStyle(color: AppColors.textGrey, fontFamily: 'Quicksand', fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            return CardCommandeListe(order: filteredList[index]);
                          },
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
