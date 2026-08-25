import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/commun_widget/favoris/bouton_favori.dart';
import 'package:tolon/controller/favoris/favoris_controller.dart';
import 'package:tolon/models/jouets/jouet_models.dart';
import 'package:tolon/repository/jouets_reposotory/jouet_repository.dart';

class FavorisPage extends ConsumerStatefulWidget {
  const FavorisPage({super.key});

  @override
  ConsumerState<FavorisPage> createState() => _FavorisPageState();
}

class _FavorisPageState extends ConsumerState<FavorisPage> {
  List<JouetModel> jouetsFavoris = [];
  bool chargement = true;

  @override
  void initState() {
    super.initState();
    _fetchJouets();
  }

  Future<void> _fetchJouets() async {
    setState(() => chargement = true);
    
    final ids = ref.read(favorisControllerProvider);
    final jouetRepo = ref.read(jouetRepositoryProvider);

    try {
      final futures = ids.map((id) => jouetRepo.getJouetById(id));
      final resultats = await Future.wait(futures);

      if (mounted) {
        setState(() {
          jouetsFavoris = resultats.whereType<JouetModel>().toList();
          chargement = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => chargement = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final idsFavoris = ref.watch(favorisControllerProvider);

    // Synchronise la liste des jouets si un favori est retiré
    ref.listen<List<String>>(favorisControllerProvider, (previous, next) {
      if (mounted) {
        setState(() {
          jouetsFavoris.removeWhere((jouet) => !next.contains(jouet.id));
        });
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFDFFFB),
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
                      color: Color(0xFFE8F2E9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
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
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Retrouvez tous les jouets que vous avez ajoutés à vos favoris',
                          style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.3),
                        ),
                      ],
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
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1E5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.favorite, color: Color(0xFFE67E22), size: 18),
                        const SizedBox(width: 6),
                        Text(
                          '${idsFavoris.length} favoris',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: const [
                      Text('Trier par : ', style: TextStyle(fontSize: 13, color: Colors.black54)),
                      Text(
                        'plus récent ˅',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFE67E22)),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // LISTE DES JOUETS OU INDICATION VIDE
              if (chargement)
                const Center(child: Padding(padding: EdgeInsets.only(top: 50), child: CircularProgressIndicator(color: Color(0xFFE67E22))))
              else if (jouetsFavoris.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Text('Aucun favori pour le moment', style: TextStyle(color: Colors.grey)),
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                image: jouet.image.isNotEmpty
                    ? DecorationImage(image: NetworkImage(jouet.image.first), fit: BoxFit.cover)
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F2E9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${jouet.ageMin}-${jouet.ageMax} ans',
                    style: const TextStyle(fontSize: 10, color: Color(0xFF4D8A52)),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 3),
                    Text(jouet.noteMoyen.toStringAsFixed(1), style: const TextStyle(fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${jouet.prix.toStringAsFixed(0)} FCFA',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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