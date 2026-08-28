import 'package:flutter/material.dart';

import 'package:tolon/controller/jouetsAdmin/jouets_controller.dart';
import 'package:tolon/cor/theme/app_theme.dart';

import 'package:tolon/pages/JouetsAdmin/Edit/ModifierJouet.dart';

import 'package:tolon/pages/JouetsAdmin/AddJouets.dart';

import 'package:tolon/repository/JouetsAdmin/JouetsRepository.dart';

class ListeJouetsPage extends StatefulWidget {
  const ListeJouetsPage({super.key});

  @override
  State<ListeJouetsPage> createState() => _ListeJouetsPageState();
}

class _ListeJouetsPageState extends State<ListeJouetsPage> {
  late JouetController controller;

  bool chargement = true;

  String? erreur;

  final TextEditingController rechercheController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = JouetController(repository: JouetRepository());

    chargerJouets();
  }

  Future<void> chargerJouets() async {
    try {
      setState(() {
        chargement = true;
        erreur = null;
      });

      await controller.chargerJouets();

      if (!mounted) {
        return;
      }

      setState(() {
        chargement = false;
      });
    } catch (e) {
      print('ERREUR : $e');

      if (!mounted) {
        return;
      }

      setState(() {
        chargement = false;
        erreur = 'Erreur lors du chargement des jouets';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFFFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Liste des jouets',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Gérez tous les jouets ajoutés',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 80,
                    child: Image.asset(
                      'assets/images/JouetHeader.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: TextField(
                        controller: rechercheController,
                        decoration: InputDecoration(
                          hintText: 'Rechercher un jouet',
                          hintStyle: TextStyle(
                            fontSize: 11,
                            color: AppStyles.textMuted,
                          ),
                          prefixIcon: Icon(Icons.search, size: 17),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  SizedBox(
                    height: 38,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AjouterJouetPage(),
                          ),
                        );

                        await chargerJouets();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE98219),
                        foregroundColor: AppStyles.textInverse,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Ajouter un jouet',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(child: construireListe()),
            ],
          ),
        ),
      ),
    );
  }

  Widget construireListe() {
    if (chargement) {
      return const Center(child: CircularProgressIndicator());
    }

    if (erreur != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: AppStyles.badgeRed, size: 40),

            const SizedBox(height: 10),

            Text(erreur!, style: const TextStyle(fontSize: 13)),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: chargerJouets,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    final String texteRecherche = rechercheController.text.toLowerCase();

    final jouetsFiltres = controller.jouets.where((jouet) {
      return jouet.nom.toLowerCase().contains(texteRecherche);
    }).toList();

    if (jouetsFiltres.isEmpty) {
      return const Center(
        child: Text(
          'Aucun jouet trouvé',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppStyles.textInverse,
        boxShadow: [
          BoxShadow(
            color: AppStyles.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Container(
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFF7FC28C),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 65),

                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Catégorie',
                      style: TextStyle(
                        color: AppStyles.textInverse,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Âge',
                      style: TextStyle(
                        color: AppStyles.textInverse,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Prix',
                      style: TextStyle(
                        color: AppStyles.textInverse,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: 80,
                  child: Center(
                    child: Text(
                      'Actions',
                      style: TextStyle(
                        color: AppStyles.textInverse,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: jouetsFiltres.length,
              itemBuilder: (context, index) {
                final jouet = jouetsFiltres[index];

                return construireLigne(jouet);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget construireLigne(dynamic jouet) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 65,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: construireImage(jouet),
            ),
          ),

          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                jouet.categorie,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                '${jouet.ageMinimum}-${jouet.ageMaximum} ans',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                '${jouet.prix.toInt()} FCFA',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModifierJouetPage(jouet: jouet),
                      ),
                    );

                    await chargerJouets();
                  },
                  icon: Icon(Icons.edit_outlined, size: 19),
                ),

                const SizedBox(width: 8),

                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    supprimerJouet(jouet.id);
                  },
                  icon: Icon(Icons.delete_outline, size: 19),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget construireImage(dynamic jouet) {
    if (jouet.images.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: Icon(Icons.toys, size: 25),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        jouet.images[0],
        width: 45,
        height: 65,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Icon(Icons.broken_image, size: 25),
          );
        },
      ),
    );
  }

  Future<void> supprimerJouet(String id) async {
    try {
      await controller.supprimerJouet(id);

      if (!mounted) {
        return;
      }

      setState(() {});
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    }
  }

  @override
  void dispose() {
    rechercheController.dispose();

    super.dispose();
  }
}
