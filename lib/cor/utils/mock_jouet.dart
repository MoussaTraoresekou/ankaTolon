import '../../models/jouets/jouet_models.dart';

class MockData {
  static JouetModel createMockJouet() {
    return JouetModel(
      id: 'mock_${DateTime.now().millisecondsSinceEpoch}', // ID unique
      nomJouet: 'Puzzle Animaux Sauvages',
      prix: 15.99,
      ageMin: 4,
      ageMax: 10,
      benefices: ['Logique', 'Motricité fine'],
      image: ['https://via.placeholder.com/150'], // Image factice
      description: 'Un super puzzle pour apprendre les animaux.',
      noteMoyen: 4.5,
      dateAjout: DateTime.now(),
      categorieId: null,
    );
  }
}
