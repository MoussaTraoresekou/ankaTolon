
import 'package:flutter/material.dart';
import 'package:tolon/models/categorieAdmin/categorie_model.dart';

class ModifierInformations extends StatelessWidget {
final TextEditingController nomController;
final TextEditingController ageMinimumController;
final TextEditingController ageMaximumController;
final TextEditingController prixController;
final TextEditingController stockController;
final TextEditingController descriptionController;

final String? categorieIdSelectionnee;

final List<Categorie> categories;

final Function(String?) onCategorieChanged;

const ModifierInformations({
super.key,
required this.nomController,
required this.ageMinimumController,
required this.ageMaximumController,
required this.prixController,
required this.stockController,
required this.descriptionController,
required this.categorieIdSelectionnee,
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
validator: (value) {
if (value == null || value.isEmpty) {
return 'Veuillez entrer le nom';
}

return null;
},
),
),

const SizedBox(width: 10),

Expanded(
child: DropdownButtonFormField<String>(
initialValue: categories.any(
(categorie) =>
categorie.id == categorieIdSelectionnee,
)
? categorieIdSelectionnee
    : null,

decoration: const InputDecoration(
labelText: 'Catégorie',
border: OutlineInputBorder(),
),

items: categories.map((categorie) {
return DropdownMenuItem<String>(
value: categorie.id,
child: Text(categorie.nom),
);
}).toList(),

onChanged: onCategorieChanged,

validator: (value) {
if (value == null) {
return 'Veuillez sélectionner une catégorie';
}

return null;
},
),
),
],
),

const SizedBox(height: 15),

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
validator: (value) {
if (value == null || value.isEmpty) {
return 'Obligatoire';
}

return null;
},
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
validator: (value) {
if (value == null || value.isEmpty) {
return 'Obligatoire';
}

return null;
},
),
),
],
),

const SizedBox(height: 15),

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
validator: (value) {
if (value == null || value.isEmpty) {
return 'Obligatoire';
}

return null;
},
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
validator: (value) {
if (value == null || value.isEmpty) {
return 'Obligatoire';
}

return null;
},
),
),
],
),

const SizedBox(height: 15),

TextFormField(
controller: descriptionController,
maxLines: 4,
decoration: const InputDecoration(
labelText: 'Description',
border: OutlineInputBorder(),
),
validator: (value) {
if (value == null || value.isEmpty) {
return 'Veuillez entrer une description';
}

return null;
},
),
],
);
}
}
