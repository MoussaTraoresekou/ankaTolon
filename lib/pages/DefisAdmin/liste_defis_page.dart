
import 'package:flutter/material.dart';

import 'package:tolon/controller/defis/defi_controller.dart';
import 'package:tolon/pages/DefisAdmin/widgets/defi_card.dart';
import 'package:tolon/pages/DefisAdmin/ajout_defi_page.dart';
import 'package:tolon/pages/DefisAdmin/modifier_defi_page.dart';


class ListeDefisPage extends StatefulWidget {

const ListeDefisPage({
super.key,
});

@override
State<ListeDefisPage> createState() =>
_ListeDefisPageState();
}


class _ListeDefisPageState
extends State<ListeDefisPage> {



final DefiController controller =
DefiController();



final TextEditingController rechercheController =
TextEditingController();

String recherche = '';



@override
void initState() {

super.initState();

chargerDefis();

rechercheController.addListener(() {

setState(() {

recherche =
rechercheController.text
    .toLowerCase()
    .trim();
});
});
}




Future<void> chargerDefis() async {

try {

await controller.recupererDefis();

} catch (e) {

if (!mounted) return;

ScaffoldMessenger.of(context)
    .showSnackBar(

SnackBar(
content: Text(
"Erreur : $e",
),
),
);
}
}



Future<void> supprimerDefi(
String id) async {

final confirmation =
await showDialog<bool>(

context: context,

builder: (context) {

return AlertDialog(

title:
const Text(
"Supprimer le défi",
),

content:
const Text(
"Voulez-vous vraiment supprimer ce défi ?",
),

actions: [



TextButton(

onPressed: () {

Navigator.pop(
context,
false,
);
},

child:
const Text(
"Annuler",
),
),




TextButton(

onPressed: () {

Navigator.pop(
context,
true,
);
},

child:
const Text(

"Supprimer",

style: TextStyle(
color: Colors.red,
),
),
),
],
);
},
);




if (confirmation != true) {
return;
}




try {

await controller.supprimerDefi(
id,
);


if (!mounted) return;


ScaffoldMessenger.of(context)
    .showSnackBar(

const SnackBar(

content: Text(
"Défi supprimé avec succès",
),
),
);




await chargerDefis();

} catch (e) {

if (!mounted) return;

ScaffoldMessenger.of(context)
    .showSnackBar(

SnackBar(

content: Text(
"Erreur lors de la suppression : $e",
),
),
);
}
}




@override
void dispose() {

rechercheController.dispose();

controller.dispose();

super.dispose();
}




@override
Widget build(
BuildContext context) {

return Scaffold(



backgroundColor:
const Color(0xFFFAFFFB),




appBar: AppBar(

backgroundColor:
Colors.white,

elevation: 0,

centerTitle: true,

title:
const Text(

"Liste des défis",

style: TextStyle(

color:
Color(0xFF263746),

fontSize:
20,

fontWeight:
FontWeight.bold,
),
),
),




body: AnimatedBuilder(

animation:
controller,

builder:
(context, child) {



if (controller.isLoading &&
controller.listeDefis.isEmpty) {

return const Center(

child:
CircularProgressIndicator(),
);
}




final defisFiltres =
controller.listeDefis.where(
(defi) {

return defi.titre
    .toLowerCase()
    .contains(recherche) ||

defi.description
    .toLowerCase()
    .contains(recherche);
},
).toList();




return Column(

children: [


Padding(

padding:
const EdgeInsets.fromLTRB(
16,
16,
16,
10,
),

child: Row(

children: [



Expanded(

child: TextField(

controller:
rechercheController,

decoration:
InputDecoration(

hintText:
"Rechercher un défi...",

hintStyle:
TextStyle(

color:
Colors.grey.shade500,

fontSize:
14,
),



prefixIcon:
const Icon(

Icons.search,

color:
Colors.grey,

size:
21,
),



suffixIcon:
recherche.isNotEmpty

? IconButton(

onPressed: () {

rechercheController
    .clear();
},

icon:
const Icon(
Icons.clear,
color:
Colors.grey,
),
)

    : null,

filled:
true,

fillColor:
Colors.white,

contentPadding:
const EdgeInsets
    .symmetric(

horizontal:
12,

vertical:
12,
),



border:
OutlineInputBorder(

borderRadius:
BorderRadius.circular(
8,
),

borderSide:
BorderSide(
color:
Colors.grey.shade300,
),
),

enabledBorder:
OutlineInputBorder(

borderRadius:
BorderRadius.circular(
8,
),

borderSide:
const BorderSide(
color:
Color(0xFFA8D5B5),
),
),

focusedBorder:
OutlineInputBorder(

borderRadius:
BorderRadius.circular(
8,
),

borderSide:
const BorderSide(

color:
Color(0xFFE98219),

width:
1.5,
),
),
),
),
),


const SizedBox(
width: 10,
),




SizedBox(

height:
48,

child:
ElevatedButton.icon(

onPressed: () async {

final resultat =
await Navigator.push(

context,

MaterialPageRoute(

builder:
(context) =>
const AjouterDefiPage(),
),
);




if (resultat == true) {

await chargerDefis();
}
},


icon:
const Icon(

Icons.add,

size:
19,
),


label:
const Text(

"Ajouter",

style: TextStyle(

fontSize:
14,

fontWeight:
FontWeight.w600,
),
),


style:
ElevatedButton.styleFrom(

backgroundColor:
const Color(
0xFFE98219,
),

foregroundColor:
Colors.white,

elevation:
1,

padding:
const EdgeInsets
    .symmetric(

horizontal:
16,
),

shape:
RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(
8,
),
),
),
),
),
],
),
),



const SizedBox(
height: 5,
),




Expanded(

child:



defisFiltres.isEmpty

? Center(

child: Text(

recherche.isEmpty
? "Aucun défi disponible"
    : "Aucun défi trouvé",

style:
TextStyle(

fontSize:
15,

color:
Colors.grey.shade600,
),
),
)




    : RefreshIndicator(

onRefresh:
chargerDefis,

child:
ListView.builder(

padding:
const EdgeInsets
    .symmetric(

horizontal:
16,

vertical:
5,
),

itemCount:
defisFiltres.length,

itemBuilder:
(context, index) {

final defi =
defisFiltres[index];


return DefiCard(

defi:
defi,




onModifier:
() async {

final resultat =
await Navigator.push(

context,

MaterialPageRoute(

builder:
(context) =>
ModifierDefiPage(

defi:
defi,
),
),
);


if (resultat ==
true) {

await chargerDefis();
}
},




onSupprimer:
() {

supprimerDefi(
defi.id,
);
},
);
},
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

