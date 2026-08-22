import 'package:flutter/material.dart';

class BarreDeFiltre extends StatefulWidget {
  const BarreDeFiltre({super.key});

  @override
  State<BarreDeFiltre> createState() => _BarreDeFiltreState();
}

class _BarreDeFiltreState extends State<BarreDeFiltre> {
  // Variables pour stocker l'état de nos filtres
  bool _filtreEnStock = false;
  bool _filtrePromotion = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // 1. LA BARRE DE RECHERCHE TEXTUELLE
          Row(
            children: [
              const Expanded(
                child: SearchBar(
                  hintText: 'Rechercher un produit...',
                  leading: Icon(Icons.search),
                ),
              ),
              const SizedBox(width: 8),
              // Bouton entonnoir pour ouvrir des options avancées si besoin
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () {
                  // Action pour ouvrir un menu de filtres plus grand
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 2. LES FILTRES RAPIDES (FilterChips)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Défilement horizontal
            child: Row(
              children: [
                // Premier filtre
                FilterChip(
                  label: const Text('En Stock'),
                  selected: _filtreEnStock,
                  onSelected: (bool valeur) {
                    setState(() {
                      _filtreEnStock = valeur;
                    });
                  },
                ),
                const SizedBox(width: 8),

                // Deuxième filtre
                FilterChip(
                  label: const Text('En Promotion'),
                  selected: _filtrePromotion,
                  onSelected: (bool valeur) {
                    setState(() {
                      _filtrePromotion = valeur;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
