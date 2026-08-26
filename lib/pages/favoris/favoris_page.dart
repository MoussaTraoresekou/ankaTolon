import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/commun_widget/favoris/bouton_favori.dart';
import 'package:tolon/controller/favoris/favoris_controller.dart';
import 'package:tolon/models/jouets/jouet_models.dart';
import 'package:tolon/repository/favoris/favoris_repository.dart';
import 'package:tolon/repository/jouets_reposotory/jouet_repository.dart';

class FavorisPage extends ConsumerStatefulWidget {
  const FavorisPage({super.key});

  @override
  ConsumerState<FavorisPage> createState() => _FavorisPageState();
}

class _FavorisPageState extends ConsumerState<FavorisPage> {
  List<JouetModel> jouetsFavoris = [];
  bool chargement = true;
  String _triSelectionne = 'Plus récent';

  Map<String, DateTime> _datesAjout = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchJouets();

      ref.listenManual<List<String>>(favorisControllerProvider, (
        previous,
        next,
      ) {
        _fetchJouets(next);
      });
    });
  }

  Future<void> _fetchJouets([List<String>? idsExternes]) async {
    if (!mounted) return;

    setState(() {
      chargement = true;
    });

    final List<String> ids = idsExternes ?? ref.read(favorisControllerProvider);

    final jouetRepo = ref.read(jouetRepositoryProvider);
    final favorisRepo = ref.read(favorisRepositoryProvider);

    try {
      // Récupérer les dates d'ajout
      final dates = await favorisRepo.getDatesAjout();
      debugPrint(' DATES FAVORIS : $dates');

      // Aucun favori
      if (ids.isEmpty) {
        if (mounted) {
          setState(() {
            _datesAjout = dates;
            jouetsFavoris = [];
            chargement = false;
          });
        }
        return;
      }

      // Récupérer les informations de chaque jouet
      final futures = ids.map((id) => jouetRepo.getJouetById(id));

      final resultats = await Future.wait(futures);
      debugPrint('IDs favoris : $ids');
      debugPrint('Résultats jouets : $resultats');

      final jouets = resultats.whereType<JouetModel>().toList();
      debugPrint('Nombre IDs favoris : ${ids.length}');
      debugPrint('Nombre jouets récupérés : ${jouets.length}');
      for (final jouet in jouets) {
  debugPrint(
    ' ${jouet.nomJouet} | ID=${jouet.id} | DATE=${_datesAjout[jouet.id]}',
  );
}

      if (mounted) {
        setState(() {
          _datesAjout = dates;
          jouetsFavoris = jouets;

          _trierJouets();

          chargement = false;
        });
      }
    } catch (e) {
      debugPrint('Erreur chargement favoris : $e');

      if (mounted) {
        setState(() {
          chargement = false;
        });
      }
    }
  }

  void _trierJouets() {
    switch (_triSelectionne) {
      case 'Plus récent':
        jouetsFavoris.sort((a, b) {
          final dateA = _datesAjout[a.id];
          final dateB = _datesAjout[b.id];

          if (dateA == null && dateB == null) return 0;
          if (dateA == null) return 1;
          if (dateB == null) return -1;

          return dateB.compareTo(dateA);
        });
        break;

      case 'Plus ancien':
        jouetsFavoris.sort((a, b) {
          final dateA = _datesAjout[a.id];
          final dateB = _datesAjout[b.id];

          if (dateA == null && dateB == null) return 0;
          if (dateA == null) return 1;
          if (dateB == null) return -1;

          return dateA.compareTo(dateB);
        });
        break;

      case 'Nom A-Z':
        jouetsFavoris.sort(
          (a, b) =>
              a.nomJouet.toLowerCase().compareTo(b.nomJouet.toLowerCase()),
        );
        break;

      case 'Nom Z-A':
        jouetsFavoris.sort(
          (a, b) =>
              b.nomJouet.toLowerCase().compareTo(a.nomJouet.toLowerCase()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final idsFavoris = ref.watch(favorisControllerProvider);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 243, 236),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // EN-TÊTE AVEC IMAGE OURS
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 219, 238, 221),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mes favoris',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // const SizedBox(width: 6),
                        // Icon(
                        //   Icons.favorite,
                        //   color: Color.fromARGB(255, 174, 8, 8),
                        //   size: 18,
                        // ),
                        SizedBox(height: 6),
                        Text(
                          'Retrouvez tous les jouets que vous avez ajoutés à vos favoris',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(240, 10, 10, 10),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(width: 8),

                  // Ours en haut à droite
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Image.asset(
                      'assets/images/imageHours.png',
                      width: 100,
                      height: 100,
                      // fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // BARRE DE COMPTEUR ET FILTRE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 219, 238, 221),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Color.fromARGB(255, 174, 8, 8),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${idsFavoris.length} favoris',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
  onSelected: (value) {
    setState(() {
      _triSelectionne = value;
      _trierJouets();
    });
  },

  itemBuilder: (context) => [
    PopupMenuItem(
      value: 'Plus récent',
      child: Row(
        children: [
          if (_triSelectionne == 'Plus récent')
            const Icon(
              Icons.check,
              color: Color(0xFFE67E22),
              size: 18,
            ),
          if (_triSelectionne == 'Plus récent')
            const SizedBox(width: 8),

          const Text('Plus récent'),
        ],
      ),
    ),

    PopupMenuItem(
      value: 'Plus ancien',
      child: Row(
        children: [
          if (_triSelectionne == 'Plus ancien')
            const Icon(
              Icons.check,
              color: Color(0xFFE67E22),
              size: 18,
            ),
          if (_triSelectionne == 'Plus ancien')
            const SizedBox(width: 8),

          const Text('Plus ancien'),
        ],
      ),
    ),

    PopupMenuItem(
      value: 'Nom A-Z',
      child: Row(
        children: [
          if (_triSelectionne == 'Nom A-Z')
            const Icon(
              Icons.check,
              color: Color(0xFFE67E22),
              size: 18,
            ),
          if (_triSelectionne == 'Nom A-Z')
            const SizedBox(width: 8),

          const Text('Nom A-Z'),
        ],
      ),
    ),

    PopupMenuItem(
      value: 'Nom Z-A',
      child: Row(
        children: [
          if (_triSelectionne == 'Nom Z-A')
            const Icon(
              Icons.check,
              color: Color(0xFFE67E22),
              size: 18,
            ),
          if (_triSelectionne == 'Nom Z-A')
            const SizedBox(width: 8),

          const Text('Nom Z-A'),
        ],
      ),
    ),
  ],

  child: Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 7,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Trier par : ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),

        Text(
          _triSelectionne,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE67E22),
          ),
        ),

        const SizedBox(width: 2),

        const Icon(
          Icons.keyboard_arrow_down,
          size: 20,
          color: Color(0xFFE67E22),
        ),
      ],
    ),
  ),
),
                ],
              ),

              const SizedBox(height: 20),

              // LISTE DES JOUETS OU INDICATION VIDE
              if (chargement)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(color: Color(0xFFE67E22)),
                  ),
                )
              else if (jouetsFavoris.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Text(
                      'Aucun favori pour le moment',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: jouetsFavoris.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final jouet = jouetsFavoris[index];
                    return _jouetCard(jouet);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jouetCard(JouetModel jouet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                image: jouet.image.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(jouet.image.first),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: const Color(0xFFF7F4F0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jouet.nomJouet,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F2E9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${jouet.ageMin}-${jouet.ageMax} ans',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF4D8A52),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 3),
                    Text(
                      jouet.noteMoyen.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${jouet.prix.toStringAsFixed(0)} FCFA',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    BoutonFavori(jouetId: jouet.id),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
