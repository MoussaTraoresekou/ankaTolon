import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/controller/favoris/favoris_controller.dart';

class BoutonFavori extends ConsumerWidget {
  final String jouetId;

  const BoutonFavori({super.key, required this.jouetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorisIds = ref.watch(favorisControllerProvider);
    final isFavori = favorisIds.contains(jouetId);

    return GestureDetector(
      onTap: () {
        ref.read(favorisControllerProvider.notifier).toggleFavori(jouetId);
      },
      child: Icon(
        isFavori ? Icons.favorite : Icons.favorite_border,
        color: const Color(0xFFE67E22),
        size: 22,
      ),
    );
  }
}
