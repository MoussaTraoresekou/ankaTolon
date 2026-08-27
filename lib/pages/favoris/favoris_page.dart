import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/commun_widget/favoris/bouton_favori.dart';
import 'package:tolon/controller/favoris/favoris_controller.dart';
import 'package:tolon/cor/theme/app_theme.dart';
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
    // Premier chargement au lancement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchJouets();
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
      // 1. Récupérer les dates d'ajout
      final dates = await favorisRepo.getDatesAjout();

      // 2. Traitement si aucun favori
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

      // 3. Récupérer les détails des jouets en parallèle
      final futures = ids.map((id) => jouetRepo.getJouetById(id));
      final resultats = await Future.wait(futures);
      final jouets = resultats.whereType<JouetModel>().toList();

      if (mounted) {
        setState(() {
          _datesAjout = dates;
          jouetsFavoris = jouets;
          _trierJouets();
          chargement = false;
        });
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement des favoris : $e');
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
          (a, b) => a.nomJouet.toLowerCase().compareTo(b.nomJouet.toLowerCase()),
        );
        break;

      case 'Nom Z-A':
        jouetsFavoris.sort(
          (a, b) => b.nomJouet.toLowerCase().compareTo(a.nomJouet.toLowerCase()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Écouter les changements de la liste d'IDs favoris de façon idiomatique
    ref.listen<List<String>>(favorisControllerProvider, (previous, next) {
      _fetchJouets(next);
    });

    final idsFavoris = ref.watch(favorisControllerProvider);

    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // EN-TÊTE
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
                          style: AppStyles.titleTextStyle,
                        ),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Image.asset(
                      'assets/images/imageHours.png',
                      width: 110,
                      height: 110,
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
                      color: const Color.fromARGB(255, 219, 238, 221),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Color.fromARGB(255, 221, 99, 99),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${idsFavoris.length} favoris',
                          style: AppStyles.normalTextStyle,
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
                      _buildMenuItem('Plus récent'),
                      _buildMenuItem('Plus ancien'),
                      _buildMenuItem('Nom A-Z'),
                      _buildMenuItem('Nom Z-A'),
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
                            style: AppStyles.normalTextStyle,
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

  // Factorisation des éléments du Menu de Tri pour alléger la méthode build
  PopupMenuItem<String> _buildMenuItem(String title) {
    final bool isSelected = _triSelectionne == title;
    return PopupMenuItem<String>(
      value: title,
      child: Row(
        children: [
          if (isSelected) ...[
            const Icon(
              Icons.check,
              color: Color(0xFFE67E22),
              size: 18,
            ),
            const SizedBox(width: 8),
          ],
          Text(title),
        ],
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
                  style: AppStyles.titleTextStyle,
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