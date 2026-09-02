
import 'package:flutter/material.dart';

import 'package:tolon/controller/defis/defi_controller.dart';
import 'package:tolon/models/defis/defi_model.dart';

import 'package:tolon/pages/DefisAdmin/widgets/champ_defi.dart';
import 'package:tolon/pages/DefisAdmin/widgets/tache_form_widget.dart';

class AjouterDefiPage extends StatefulWidget {
const AjouterDefiPage({
super.key,
});

@override
State<AjouterDefiPage> createState() =>
_AjouterDefiPageState();
}

class _AjouterDefiPageState extends State<AjouterDefiPage> {
// =====================================================
// CONTROLLER
// =====================================================

final DefiController controller = DefiController();

// =====================================================
// CHAMPS
// =====================================================

final TextEditingController titreController =
TextEditingController();

final TextEditingController descriptionController =
TextEditingController();

// =====================================================
// DUREE DE VALIDITE
// =====================================================

final TextEditingController dureeController =
TextEditingController();

// =====================================================
// AGE
// =====================================================

int ageMin = 4;
int ageMax = 12;

// =====================================================
// TACHES
// =====================================================

List<Map<String, dynamic>> taches = [];

// =====================================================
// INITIALISATION
// =====================================================

@override
void initState() {
super.initState();

controller.chargerCategories();

// Durée par défaut : 24 heures
dureeController.text = "24";

// Une tâche par défaut
taches.add({
'type': null,
'categorie': null,
'nombre': '1',
});
}

// =====================================================
// DISPOSE
// =====================================================

@override
void dispose() {
titreController.dispose();
descriptionController.dispose();
dureeController.dispose();

controller.dispose();

super.dispose();
}

// =====================================================
// MESSAGE
// =====================================================

void afficherMessage(String message) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
message,
style: const TextStyle(
fontSize: 14,
),
),
),
);
}

// =====================================================
// AJOUTER TACHE
// =====================================================

void ajouterTache() {
setState(() {
taches.add({
'type': null,
'categorie': null,
'nombre': '1',
});
});
}

// =====================================================
// SUPPRIMER TACHE
// =====================================================

void supprimerTache(int index) {
setState(() {
taches.removeAt(index);

// Garder au moins une tâche
if (taches.isEmpty) {
taches.add({
'type': null,
'categorie': null,
'nombre': '1',
});
}
});
}

// =====================================================
// ENREGISTRER
// =====================================================

Future<void> enregistrerDefi() async {
// ===================================================
// TITRE
// ===================================================

if (titreController.text.trim().isEmpty) {
afficherMessage(
"Veuillez saisir le titre",
);

return;
}

// ===================================================
// DESCRIPTION
// ===================================================

if (descriptionController.text.trim().isEmpty) {
afficherMessage(
"Veuillez saisir la description",
);

return;
}

// ===================================================
// DUREE
// ===================================================

final int? duree = int.tryParse(
dureeController.text.trim(),
);

if (duree == null || duree <= 0) {
afficherMessage(
"Veuillez saisir une durée valide en heures",
);

return;
}

// ===================================================
// LISTES
// ===================================================

List<TacheDefi> activites = [];
List<TacheDefi> quiz = [];

// ===================================================
// PARCOURIR LES TACHES
// ===================================================

for (int i = 0; i < taches.length; i++) {
final tache = taches[i];

// TYPE
String? type;

if (tache['type'] != null) {
type = tache['type'].toString();
}

// CATEGORIE
String? categorieId;

if (tache['categorie'] != null) {
categorieId =
tache['categorie'].toString();
}

// NOMBRE
int nombre = int.tryParse(
tache['nombre']?.toString() ?? '1',
) ??
1;

// VERIFIER TYPE
if (type == null || type.isEmpty) {
afficherMessage(
"Veuillez sélectionner le type de la tâche ${i + 1}",
);

return;
}

// VERIFIER CATEGORIE
if (categorieId == null ||
categorieId.isEmpty) {
afficherMessage(
"Veuillez sélectionner la catégorie de la tâche ${i + 1}",
);

return;
}

// VERIFIER NOMBRE
if (nombre <= 0) {
afficherMessage(
"Le nombre doit être supérieur à 0",
);

return;
}

// CREER TACHE
final nouvelleTache = TacheDefi(
categorieId: categorieId,
nombre: nombre,
);

// ACTIVITE
if (type == "activité" ||
type == "activite") {
activites.add(
nouvelleTache,
);
}

// QUIZ
else if (type == "quiz") {
quiz.add(
nouvelleTache,
);
}
}

// ===================================================
// CREER LE DEFI
// ===================================================

final Defi defi = Defi(
id: '',
titre: titreController.text.trim(),
description: descriptionController.text.trim(),
dateAjout: DateTime.now(),
ageMin: ageMin,
ageMax: ageMax,
dureeValidite: duree,
activites: activites,
quiz: quiz,
);

// ===================================================
// ENREGISTRER
// ===================================================

try {
await controller.ajouterDefi(
defi,
);

if (!mounted) {
return;
}

if (controller.erreur != null) {
afficherMessage(
controller.erreur!,
);

return;
}

afficherMessage(
"Défi ajouté avec succès",
);

Navigator.pop(
context,
true,
);
} catch (e) {
if (!mounted) {
return;
}

afficherMessage(
"Erreur lors de l'ajout : $e",
);
}
}

// =====================================================
// BUILD
// =====================================================

@override
Widget build(BuildContext context) {
return Scaffold(
// =================================================
// FOND
// =================================================

backgroundColor:
const Color(0xFFFAFFFB),

// =================================================
// APP BAR
// =================================================

appBar: AppBar(
backgroundColor:
Colors.white,

elevation: 1,

centerTitle: true,

leading: IconButton(
onPressed: () {
Navigator.pop(context);
},

icon: const Icon(
Icons.arrow_back,
color: Colors.black,
size: 25,
),
),

title: const Text(
"Ajouter un défi",

style: TextStyle(
color: Color(0xFF263746),
fontSize: 22,
fontWeight: FontWeight.bold,
),
),
),

// =================================================
// BODY
// =================================================

body: SafeArea(
child: AnimatedBuilder(
animation: controller,

builder: (context, child) {
// ===========================================
// CHARGEMENT
// ===========================================

if (controller.isLoading &&
controller.categories.isEmpty) {
return const Center(
child: CircularProgressIndicator(),
);
}

return SingleChildScrollView(
padding: const EdgeInsets.fromLTRB(
24,
18,
24,
30,
),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
// =====================================
// IMAGE AU MILIEU
// =====================================

Center(
child: Image.asset(
"assets/images/header_Defis.png",

height: 110,

width: 140,

fit: BoxFit.contain,
),
),

const SizedBox(
height: 20,
),

// =====================================
// TITRE
// =====================================

const Text(
"Titre du défi",

style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: Color(0xFF263746),
),
),

const SizedBox(
height: 8,
),

ChampDefi(
label: "",

hint:
"Exemple : Dessiner une maison",

controller:
titreController,
),

const SizedBox(
height: 20,
),

// =====================================
// DESCRIPTION
// =====================================

const Text(
"Description du défi",

style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
color: Color(0xFF263746),
),
),

const SizedBox(
height: 8,
),

ChampDefi(
label: "",

hint:
"Décrire le défi...",

controller:
descriptionController,

maxLines: 5,
),

const SizedBox(
height: 22,
),

// =====================================
// LISTE DES TACHES
// =====================================

Container(
width: double.infinity,

padding:
const EdgeInsets.all(15),

decoration:
BoxDecoration(
color: Colors.white,

borderRadius:
BorderRadius.circular(12),

border: Border.all(
color:
const Color(
0xFFA8D5B5,
),

width: 1.2,
),
),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
// TITRE + AJOUTER
Row(
mainAxisAlignment:
MainAxisAlignment
    .spaceBetween,

children: [
const Text(
"Liste des tâches",

style: TextStyle(
fontSize: 16,
fontWeight:
FontWeight.bold,
color:
Color(
0xFF263746,
),
),
),

OutlinedButton.icon(
onPressed:
ajouterTache,

icon:
const Icon(
Icons.add,
size: 19,
),

label:
const Text(
"Ajouter",

style:
TextStyle(
fontSize: 13,
fontWeight:
FontWeight.w600,
),
),

style:
OutlinedButton
    .styleFrom(
minimumSize:
const Size(
0,
36,
),

padding:
const EdgeInsets
    .symmetric(
horizontal: 10,
),

side:
const BorderSide(
color:
Color(
0xFFA8D5B5,
),
),

shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius
    .circular(
7,
),
),
),
),
],
),

const SizedBox(
height: 12,
),

// TACHES
Column(
children: [
for (
int i = 0;
i < taches.length;
i++
)
TacheFormWidget(
type:
taches[i]['type'],

categorie:
taches[i]
['categorie'],

nombre:
taches[i]
['nombre']
    .toString(),

categories:
controller
    .categories,

// TYPE
onTypeChanged:
(value) {
setState(() {
taches[i]['type'] =
value;

taches[i]
['categorie'] =
null;
});
},

// CATEGORIE
onCategorieChanged:
(value) {
setState(() {
taches[i]
['categorie'] =
value;
});
},

// NOMBRE
onNombreChanged:
(value) {
setState(() {
taches[i]
['nombre'] =
value;
});
},

// SUPPRIMER
onSupprimer: () {
supprimerTache(
i,
);
},
),
],
),
],
),
),

const SizedBox(
height: 22,
),

// =====================================
// DUREE DE VALIDITE
// =====================================

Container(
width: double.infinity,

padding:
const EdgeInsets.all(15),

decoration:
BoxDecoration(
color: Colors.white,

borderRadius:
BorderRadius.circular(12),

border: Border.all(
color:
const Color(
0xFFA8D5B5,
),

width: 1.2,
),
),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [
const Text(
"Durée de validité",

style: TextStyle(
fontSize: 16,
fontWeight:
FontWeight.bold,
color:
Color(
0xFF263746,
),
),
),

const SizedBox(
height: 5,
),

const Text(
"Indiquez pendant combien d'heures le défi sera disponible.",

style: TextStyle(
fontSize: 13,
color: Colors.grey,
),
),

const SizedBox(
height: 10,
),

TextField(
controller:
dureeController,

keyboardType:
TextInputType.number,

style:
const TextStyle(
fontSize: 16,
fontWeight:
FontWeight.w500,
color:
Color(
0xFF263746,
),
),

decoration:
InputDecoration(
hintText:
"Exemple : 24",

suffixText:
"heures",

suffixStyle:
const TextStyle(
fontSize: 14,
fontWeight:
FontWeight.w600,
color:
Color(
0xFFE98219,
),
),

filled: true,

fillColor:
const Color(
0xFFFAFFFB,
),

border:
OutlineInputBorder(
borderRadius:
BorderRadius
    .circular(
9,
),

borderSide:
const BorderSide(
color:
Color(
0xFFA8D5B5,
),
),
),

enabledBorder:
OutlineInputBorder(
borderRadius:
BorderRadius
    .circular(
9,
),

borderSide:
const BorderSide(
color:
Color(
0xFFA8D5B5,
),
),
),

focusedBorder:
OutlineInputBorder(
borderRadius:
BorderRadius
    .circular(
9,
),

borderSide:
const BorderSide(
color:
Color(
0xFFE98219,
),

width: 2,
),
),

contentPadding:
const EdgeInsets
    .symmetric(
horizontal: 14,
vertical: 15,
),
),
),
],
),
),

const SizedBox(
height: 25,
),

// =====================================
// BOUTON PUBLIER
// =====================================

Center(
child: SizedBox(
width: 200,

height: 52,

child: ElevatedButton(
onPressed:
controller.isLoading
? null
    : enregistrerDefi,

style:
ElevatedButton.styleFrom(
backgroundColor:
const Color(
0xFFE98219,
),

foregroundColor:
Colors.white,

elevation: 2,

shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius
    .circular(
10,
),
),
),

child:
controller.isLoading
? const SizedBox(
height: 24,
width: 24,

child:
CircularProgressIndicator(
strokeWidth: 2,
color:
Colors.white,
),
)
    : const Text(
"Publier",

style:
TextStyle(
fontSize: 17,
fontWeight:
FontWeight.bold,
),
),
),
),
),

const SizedBox(
height: 15,
),
],
),
);
},
),
),
);
}
}
