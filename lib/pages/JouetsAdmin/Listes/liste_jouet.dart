
import 'package:flutter/material.dart';

import 'package:tolon/controller/jouetsAdmin/jouets_controller.dart';
import 'package:tolon/models/JouetsAdmin/jouet_list_model.dart';
import 'package:tolon/repository/JouetsAdmin/JouetsRepository.dart';

import 'package:tolon/pages/JouetsAdmin/AddJouets.dart';
import 'package:tolon/pages/JouetsAdmin/Edit/ModifierJouet.dart';

class ListeJouetsPage extends StatefulWidget {
const ListeJouetsPage({
super.key,
});

@override
State<ListeJouetsPage> createState() =>
_ListeJouetsPageState();
}

class _ListeJouetsPageState
extends State<ListeJouetsPage> {

// =====================================================
// CONTROLLER
// =====================================================

late JouetController controller;

// =====================================================
// ETAT
// =====================================================

bool chargement = true;

String? erreur;

// =====================================================
// RECHERCHE
// =====================================================

final TextEditingController rechercheController =
TextEditingController();

// =====================================================
// INIT STATE
// =====================================================

@override
void initState() {
super.initState();

controller = JouetController(
repository: JouetRepository(),
);

chargerDonnees();
}

// =====================================================
// CHARGER LES DONNEES
// =====================================================

Future<void> chargerDonnees() async {
try {
if (mounted) {
setState(() {
chargement = true;
erreur = null;
});
}

await controller.chargerJouets();

if (!mounted) return;

setState(() {
chargement = false;
});
} catch (e) {
print('ERREUR CHARGEMENT : $e');

if (!mounted) return;

setState(() {
chargement = false;
erreur =
'Erreur lors du chargement des jouets';
});
}
}

// =====================================================
// BUILD
// =====================================================

@override
Widget build(BuildContext context) {

return Scaffold(
backgroundColor:
const Color(0xFFFAFFFB),

body: SafeArea(
child: Padding(
padding:
const EdgeInsets.symmetric(
horizontal: 12,
vertical: 15,
),

child: Column(
children: [

// =================================================
// HEADER
// =================================================

Row(
children: [

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [

const Text(
'Liste des jouets',

style: TextStyle(
fontSize: 23,
fontWeight:
FontWeight.bold,
),
),

const SizedBox(
height: 6,
),

Text(
'Gérez tous les jouets ajoutés',

style: TextStyle(
fontSize: 14,
color:
Colors.grey[600],
),
),
],
),
),

// =================================================
// IMAGE HEADER
// =================================================

SizedBox(
width: 95,
height: 78,

child: Image.asset(
'assets/images/JouetHeader.png',
fit: BoxFit.contain,
),
),
],
),

const SizedBox(
height: 15,
),

// =================================================
// RECHERCHE + AJOUTER
// =================================================

Row(
children: [

// =================================================
// RECHERCHE
// =================================================

Expanded(
child: SizedBox(
height: 40,

child: TextField(
controller:
rechercheController,

decoration:
InputDecoration(
hintText:
'Rechercher',

hintStyle:
const TextStyle(
fontSize: 12,
),

prefixIcon:
const Icon(
Icons.search,
size: 19,
),

contentPadding:
const EdgeInsets.symmetric(
horizontal: 8,
),

border:
OutlineInputBorder(
borderRadius:
BorderRadius.circular(7),
),

enabledBorder:
OutlineInputBorder(
borderRadius:
BorderRadius.circular(7),

borderSide:
BorderSide(
color:
Colors.grey[300]!,
),
),
),

onChanged: (value) {
setState(() {});
},
),
),
),

const SizedBox(
width: 7,
),

// =================================================
// AJOUTER
// =================================================

SizedBox(
height: 40,

child: ElevatedButton(
onPressed: () async {

await Navigator.push(
context,

MaterialPageRoute(
builder:
(context) =>
const AjouterJouetPage(),
),
);

await chargerDonnees();
},

style:
ElevatedButton.styleFrom(
backgroundColor:
const Color(
0xFFE98219,
),

foregroundColor:
Colors.white,

padding:
const EdgeInsets.symmetric(
horizontal: 13,
),

shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(7),
),
),

child: const Text(
'Ajouter',

style: TextStyle(
fontSize: 12,
),
),
),
),
],
),

const SizedBox(
height: 18,
),

// =================================================
// LISTE
// =================================================

Expanded(
child:
construireListe(),
),
],
),
),
),
);
}

// =====================================================
// LISTE
// =====================================================

Widget construireListe() {

if (chargement) {

return const Center(
child:
CircularProgressIndicator(),
);
}

// =====================================================
// ERREUR
// =====================================================

if (erreur != null) {

return Center(
child: Column(
mainAxisAlignment:
MainAxisAlignment.center,

children: [

const Icon(
Icons.error,
color: Colors.red,
size: 40,
),

const SizedBox(
height: 10,
),

Text(
erreur!,
style:
const TextStyle(
fontSize: 13,
),
),

const SizedBox(
height: 10,
),

ElevatedButton(
onPressed:
chargerDonnees,

child:
const Text(
'Réessayer',
),
),
],
),
);
}

// =====================================================
// RECHERCHE
// =====================================================

final String recherche =
rechercheController.text
    .trim()
    .toLowerCase();

final List<Jouet> jouets =
controller.jouets.where(
(jouet) {

return jouet.nom
    .toLowerCase()
    .contains(recherche);

},
).toList();

// =====================================================
// AUCUN RESULTAT
// =====================================================

if (jouets.isEmpty) {

return const Center(
child: Text(
'Aucun jouet trouvé',

style: TextStyle(
fontSize: 13,
color: Colors.grey,
),
),
);
}

// =====================================================
// TABLEAU
// =====================================================

return LayoutBuilder(
builder: (
context,
contraintes,
) {

final double largeur =
contraintes.maxWidth;

return Container(
width: double.infinity,

decoration: BoxDecoration(
color: Colors.white,

borderRadius:
BorderRadius.circular(8),

boxShadow: [
BoxShadow(
color:
Colors.black.withValues(alpha: 0.10),

blurRadius: 8,

offset:
const Offset(0, 3),
),
],
),

child: Column(
children: [

construireEntete(
largeur,
),

Expanded(
child: ListView.builder(
itemCount:
jouets.length,

itemBuilder:
(context, index) {

return construireLigne(
jouets[index],
largeur,
);
},
),
),
],
),
);
},
);
}

// =====================================================
// ENTETE DU TABLEAU
// =====================================================

Widget construireEntete(
double largeur) {

final bool petitEcran =
largeur < 450;

return Container(
height:
petitEcran ? 40 : 50,

decoration:
const BoxDecoration(
color:
Color(0xFF7FC28C),

borderRadius:
BorderRadius.only(
topLeft:
Radius.circular(8),

topRight:
Radius.circular(8),
),
),

child: Row(
children: [

// =================================================
// IMAGE
// =================================================

SizedBox(
width:
petitEcran ? 60 : 120,

child:
const Center(
child: Text(''),
),
),

// =================================================
// AGE
// =================================================

Expanded(
child: Center(
child: Text(
'Âge',

style: TextStyle(
color:
Colors.white,

fontSize:
petitEcran
? 11
    : 14,

fontWeight:
FontWeight.bold,
),
),
),
),

// =================================================
// PRIX
// =================================================

Expanded(
child: Center(
child: Text(
'Prix',

style: TextStyle(
color:
Colors.white,

fontSize:
petitEcran
? 11
    : 14,

fontWeight:
FontWeight.bold,
),
),
),
),

// =================================================
// ACTIONS
// =================================================

SizedBox(
width:
petitEcran
? 78
    : 120,

child: Padding(
padding:
EdgeInsets.only(
left:
petitEcran
? 7
    : 10,
),

child: Center(
child: Text(
'Actions',

style:
TextStyle(
color:
Colors.white,

fontSize:
petitEcran
? 11
    : 14,

fontWeight:
FontWeight.bold,
),
),
),
),
),
],
),
);
}

// =====================================================
// LIGNE
// =====================================================

Widget construireLigne(
Jouet jouet,
double largeur) {

final bool petitEcran =
largeur < 450;

return Container(
height:
petitEcran
? 82
    : 110,

decoration:
BoxDecoration(
border:
Border(
bottom:
BorderSide(
color:
Colors.grey[200]!,
),
),
),

child: Row(
children: [

// =================================================
// IMAGE
// =================================================

SizedBox(
width:
petitEcran
? 60
    : 120,

child: Center(
child:
construireImage(
jouet,
petitEcran,
),
),
),

// =================================================
// AGE
// =================================================

Expanded(
child: Center(
child: Text(
'${jouet.ageMinimum}-${jouet.ageMaximum} ans',

textAlign:
TextAlign.center,

style:
TextStyle(
fontSize:
petitEcran
? 10
    : 14,
),
),
),
),

// =================================================
// PRIX
// =================================================

Expanded(
child: Center(
child: Text(
'${jouet.prix.toInt()} FCFA',

textAlign:
TextAlign.center,

maxLines:
2,

overflow:
TextOverflow.ellipsis,

style:
TextStyle(
fontSize:
petitEcran
? 10
    : 14,

fontWeight:
FontWeight.w500,
),
),
),
),

// =================================================
// ACTIONS
// =================================================

SizedBox(
width:
petitEcran
? 78
    : 120,

child: Padding(
padding:
EdgeInsets.only(
left:
petitEcran
? 7
    : 10,
),

child: Row(
mainAxisAlignment:
MainAxisAlignment.center,

mainAxisSize:
MainAxisSize.min,

children: [

// =================================================
// MODIFIER
// =================================================

SizedBox(
width:
petitEcran
? 32
    : 48,

height:
petitEcran
? 32
    : 48,

child:
IconButton(
onPressed:
() async {

await Navigator.push(
context,

MaterialPageRoute(
builder:
(context) {

return ModifierJouetPage(
jouet:
jouet,
);
},
),
);

await chargerDonnees();
},

padding:
EdgeInsets.zero,

icon:
Icon(
Icons.edit_outlined,

size:
petitEcran
? 18
    : 23,

color:
Colors.black87,
),
),
),

// =================================================
// SUPPRIMER
// =================================================

SizedBox(
width:
petitEcran
? 32
    : 48,

height:
petitEcran
? 32
    : 48,

child:
IconButton(
onPressed: () {

supprimerJouet(
jouet.id,
);
},

padding:
EdgeInsets.zero,

icon:
Icon(
Icons.delete_outline,

size:
petitEcran
? 18
    : 23,

color:
Colors.black87,
),
),
),
],
),
),
),
],
),
);
}

// =====================================================
// IMAGE
// =====================================================

Widget construireImage(
Jouet jouet,
bool petitEcran) {

final double largeur =
petitEcran
? 48
    : 75;

final double hauteur =
petitEcran
? 60
    : 85;

// =====================================================
// PAS D'IMAGE
// =====================================================

if (jouet.images.isEmpty) {

return Container(
width:
largeur,

height:
hauteur,

decoration:
BoxDecoration(
color:
Colors.grey[200],

borderRadius:
BorderRadius.circular(6),
),

child:
Icon(
Icons.toys,

size:
petitEcran
? 25
    : 38,

color:
Colors.grey,
),
);
}

// =====================================================
// IMAGE
// =====================================================

return ClipRRect(
borderRadius:
BorderRadius.circular(6),

child:
Image.network(
jouet.images[0],

width:
largeur,

height:
hauteur,

fit:
BoxFit.contain,

errorBuilder:
(context, error, stackTrace) {

return Container(
width:
largeur,

height:
hauteur,

decoration:
BoxDecoration(
color:
Colors.grey[200],

borderRadius:
BorderRadius.circular(6),
),

child:
Icon(
Icons.broken_image,

size:
petitEcran
? 25
    : 38,

color:
Colors.grey,
),
);
},
),
);
}

// =====================================================
// SUPPRIMER
// =====================================================

Future<void> supprimerJouet(
String id) async {

try {

await controller.supprimerJouet(
id,
);

if (!mounted) return;

setState(() {});

ScaffoldMessenger.of(context)
    .showSnackBar(
const SnackBar(
content:
Text(
'Jouet supprimé avec succès',
),
),
);

} catch (e) {

if (!mounted) return;

ScaffoldMessenger.of(context)
    .showSnackBar(
SnackBar(
content:
Text(
'Erreur : $e',
),
),
);
}
}

// =====================================================
// DISPOSE
// =====================================================

@override
void dispose() {

rechercheController.dispose();

super.dispose();
}
}

