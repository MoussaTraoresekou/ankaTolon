import 'package:flutter/material.dart';

class ModifierInformations extends StatelessWidget {

  final TextEditingController nomController;
  final TextEditingController ageMinimumController;
  final TextEditingController ageMaximumController;
  final TextEditingController prixController;
  final TextEditingController stockController;
  final TextEditingController descriptionController;

  final String? categorieSelectionnee;
  final List<String> categories;
  final Function(String?) onCategorieChanged;

  const ModifierInformations({
    super.key,
    required this.nomController,
    required this.ageMinimumController,
    required this.ageMaximumController,
    required this.prixController,
    required this.stockController,
    required this.descriptionController,
    required this.categorieSelectionnee,
    required this.categories,
    required this.onCategorieChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Row(
          children: [

            Expanded(
              child: TextFormField(
                controller: nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom du jouet',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: DropdownButtonFormField<String>(
                value: categorieSelectionnee,
                decoration: const InputDecoration(
                  labelText: 'Catégorie',
                  border: OutlineInputBorder(),
                ),
                items: categories.map((categorie) {
                  return DropdownMenuItem(
                    value: categorie,
                    child: Text(categorie),
                  );
                }).toList(),
                onChanged: onCategorieChanged,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [

            Expanded(
              child: TextFormField(
                controller: ageMinimumController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Âge minimum',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: TextFormField(
                controller: ageMaximumController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Âge maximum',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [

            Expanded(
              child: TextFormField(
                controller: prixController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Prix',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        TextFormField(
          controller: descriptionController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}