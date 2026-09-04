
import 'package:flutter/material.dart';

import 'package:tolon/controller/jouetsAdmin/jouets_controller.dart';

import 'package:tolon/models/categorieAdmin/categorie_model.dart';

import 'package:tolon/repository/JouetsAdmin/JouetsRepository.dart';

import 'package:tolon/repository/categorieAdminRepository/categorie_repository.dart';

import 'package:tolon/pages/JouetsAdmin/Add/informations_jouets.dart';
import 'package:tolon/pages/JouetsAdmin/Add/images_jouet.dart';
import 'package:tolon/pages/JouetsAdmin/Add/benefices_jouet.dart';

class AjouterJouetPage extends StatefulWidget {
const AjouterJouetPage({
super.key,
});

@override
State<AjouterJouetPage> createState() =>
_AjouterJouetPageState();
}

class _AjouterJouetPageState
extends State<AjouterJouetPage> {

late JouetController controller;



final GlobalKey<FormState> formKey =
GlobalKey<FormState>();



final TextEditingController nomController =
TextEditingController();

final TextEditingController ageMinimumController =
TextEditingController();

final TextEditingController ageMaximumController =
TextEditingController();

final TextEditingController prixController =
TextEditingController();

final TextEditingController stockController =
TextEditingController();

final TextEditingController descriptionController =
TextEditingController();


String? categorieIdSelectionnee;

List<Categorie> categories = [];



List<TextEditingController> beneficesControllers = [
TextEditingController(),
];



@override
void initState() {
super.initState();

controller = JouetController(
repository: JouetRepository(),
);

chargerCategories();
}

Future<void> chargerCategories() async {

final CategorieRepository repository =
CategorieRepository();

final resultat =
await repository.recupererCategories();

if (!mounted) {
return;
}

setState(() {
categories = resultat;
});
}



void ajouterChampBenefice() {

setState(() {

beneficesControllers.add(
TextEditingController(),
);
});
}



void supprimerBenefice(int index) {

setState(() {

beneficesControllers[index].dispose();

beneficesControllers.removeAt(index);
});
}



Future<void> selectionnerImages() async {

await controller.selectionnerImages();

if (!mounted) {
return;
}

setState(() {});
}



void supprimerImage(int index) {

setState(() {

controller.supprimerImage(index);
});
}



Future<void> ajouterJouet() async {


if (!formKey.currentState!.validate()) {
return;
}



if (categorieIdSelectionnee == null) {

afficherMessage(
'Veuillez sélectionner une catégorie',
);

return;
}


if (controller.imagesSelectionnees.isEmpty) {

afficherMessage(
'Veuillez sélectionner au moins une image',
);

return;
}


final int ageMinimum =
int.parse(
ageMinimumController.text.trim(),
);

final int ageMaximum =
int.parse(
ageMaximumController.text.trim(),
);

final double prix =
double.parse(
prixController.text.trim(),
);

final int stock =
int.parse(
stockController.text.trim(),
);


List<String> benefices = [];

for (
TextEditingController beneficeController
in beneficesControllers
) {

if (
beneficeController.text
    .trim()
    .isNotEmpty
) {

benefices.add(
beneficeController.text.trim(),
);
}
}



if (benefices.isEmpty) {

afficherMessage(
'Veuillez ajouter au moins un bénéfice',
);

return;
}


try {

await controller.ajouterJouet(

nom:
nomController.text.trim(),

categorieId:
categorieIdSelectionnee!,

ageMinimum:
ageMinimum,

ageMaximum:
ageMaximum,

prix:
prix,

stock:
stock,

description:
descriptionController.text.trim(),

benefices:
benefices,
);

if (!mounted) {
return;
}

afficherMessage(
'Jouet ajouté avec succès',
);

Navigator.pop(context);

} catch (e) {

if (!mounted) {
return;
}

afficherMessage(
'Erreur : $e',
);
}
}


void afficherMessage(String message) {

ScaffoldMessenger.of(context).showSnackBar(

SnackBar(
content: Text(message),
),
);
}


@override
Widget build(BuildContext context) {

return Scaffold(

backgroundColor:
const Color(0xFFFAFFFB),

body: SafeArea(

child: LayoutBuilder(

builder: (context, constraints) {


final double largeurEcran =
constraints.maxWidth;


double margeHorizontale;

if (largeurEcran < 450) {

margeHorizontale = 15;

} else if (largeurEcran < 800) {

margeHorizontale = 25;

} else {

margeHorizontale = 40;
}


double largeurImage;

double hauteurImage;

if (largeurEcran < 450) {

largeurImage = 70;
hauteurImage = 60;

} else {

largeurImage = 100;
hauteurImage = 75;
}

return SingleChildScrollView(

child: Padding(

padding: EdgeInsets.symmetric(
horizontal: margeHorizontale,
vertical: 15,
),

child: Form(

key: formKey,

child: Column(

children: [


Row(

crossAxisAlignment:
CrossAxisAlignment.center,

children: [


IconButton(

onPressed: () {
Navigator.pop(context);
},

padding:
EdgeInsets.zero,

constraints:
const BoxConstraints(
minWidth: 35,
minHeight: 35,
),

icon:
const Icon(
Icons.arrow_back_ios,
size: 16,
),
),

const SizedBox(
width: 5,
),


Expanded(

child: Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

Text(

'Ajouter un jouet',

style:
TextStyle(

fontSize:
largeurEcran < 450
? 18
    : 20,

fontWeight:
FontWeight.bold,
),
),

const SizedBox(
height: 4,
),

Text(

'Renseignez les informations '
'du nouveau jouet',

style:
TextStyle(

fontSize:
largeurEcran < 450
? 10
    : 12,

color:
Colors.grey,
),

maxLines: 2,

overflow:
TextOverflow.ellipsis,
),
],
),
),



SizedBox(

width:
largeurImage,

height:
hauteurImage,

child:
Image.asset(

'assets/images/JouetHeader.png',

fit:
BoxFit.contain,
),
),
],
),

const SizedBox(
height: 12,
),

Container(

width:
double.infinity,

padding:
EdgeInsets.all(
largeurEcran < 450
? 12
    : 16,
),

decoration:
BoxDecoration(

color:
Colors.white,

borderRadius:
BorderRadius.circular(
10,
),

boxShadow: [

BoxShadow(

color:
Colors.black
    .withOpacity(
0.15,
),

blurRadius:
7,

offset:
const Offset(
0,
3,
),
),
],
),

child: Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

Text(

'Informations du jouet',

style:
TextStyle(

fontWeight:
FontWeight.bold,

fontSize:
largeurEcran < 450
? 15
    : 17,
),
),

const SizedBox(
height: 12,
),

InformationsJouet(

nomController:
nomController,

ageMinimumController:
ageMinimumController,

ageMaximumController:
ageMaximumController,

prixController:
prixController,

stockController:
stockController,

descriptionController:
descriptionController,

categorieIdSelectionnee:
categorieIdSelectionnee,

categories:
categories,

onCategorieChanged:
(value) {

setState(() {

categorieIdSelectionnee =
value;
});
},
),

const SizedBox(
height: 15,
),


ImagesJouet(

images:
controller
    .imagesSelectionnees,

selectionnerImages:
selectionnerImages,

supprimerImage:
supprimerImage,
),

const SizedBox(
height: 15,
),


BeneficesJouet(

controllers:
beneficesControllers,

ajouterBenefice:
ajouterChampBenefice,

supprimerBenefice:
supprimerBenefice,
),
],
),
),

const SizedBox(
height: 15,
),


Row(

children: [


Expanded(

child: SizedBox(

height: 42,

child:
OutlinedButton(

onPressed: () {

Navigator.pop(
context,
);
},

style:
OutlinedButton.styleFrom(

foregroundColor:
Colors.black87,

side:
BorderSide(
color:
Colors.grey[400]!,
),

shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(
7,
),
),
),

child:
const Text(
'Annuler',
style:
TextStyle(
fontSize: 13,
),
),
),
),
),

const SizedBox(
width: 12,
),


Expanded(

child: SizedBox(

height: 42,

child:
ElevatedButton(

onPressed:
ajouterJouet,

style:
ElevatedButton.styleFrom(

backgroundColor:
const Color(
0xFFE98219,
),

foregroundColor:
Colors.white,

shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(
7,
),
),

elevation:
0,
),

child:
const Text(
'Ajouter',
style:
TextStyle(
fontSize: 13,
fontWeight:
FontWeight.w500,
),
),
),
),
),
],
),

const SizedBox(
height: 20,
),
],
),
),
),
);
},
),
),
);
}


@override
void dispose() {

nomController.dispose();

ageMinimumController.dispose();

ageMaximumController.dispose();

prixController.dispose();

stockController.dispose();

descriptionController.dispose();

for (
TextEditingController controller
in beneficesControllers
) {

controller.dispose();
}

super.dispose();
}
}

