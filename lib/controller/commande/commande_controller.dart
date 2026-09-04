import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/models/commande/command_model.dart';
import 'package:tolon/repository/commande_repository/commande_repository.dart';


final commandeControllerProvider =
    NotifierProvider<CommandeController, List<Commande>>(
  CommandeController.new,
);

class CommandeController extends Notifier<List<Commande>> {
  late final CommandeRepository _commandeRepository;

  @override
  List<Commande> build() {
    _commandeRepository = ref.read(commandeRepositoryProvider);

    chargerCommandes();

    return [];
  }

  /// Récupère toutes les commandes du client connecté
  Future<void> chargerCommandes() async {
    try {
      final commandes = await _commandeRepository.getMesCommandes();

      state = commandes;
    } catch (e) {
      state = [];
      rethrow;
    }
  }

  /// Actualise la liste des commandes
  Future<void> actualiserCommandes() async {
    await chargerCommandes();
  }

  /// Récupère une commande selon son ID
  Future<Commande?> getCommandeById(String commandeId) async {
    try {
      return await _commandeRepository.getCommandeById(commandeId);
    } catch (e) {
      return null;
    }
  }
}