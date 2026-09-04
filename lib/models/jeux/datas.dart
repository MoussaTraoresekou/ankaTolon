import 'package:flutter/material.dart';
import 'package:tolon/models/jeux/quiz_models.dart';

class QuizData {
  static const List<QuizTheme> themes = [
    QuizTheme(
      id: "histoire_mali",
      title: "Histoire du Mali",
      icon: "assets/images/quiz/histoire.png",
      bgColor: Color(0xFFF3E5FF),
      questions: [
        QuizQuestion(
          text: "Qui est le fondateur légendaire de l'Empire du Mali au XIIIe siècle ?",
          options: ["Mansa Moussa", "Soumaoro Kanté", "Sundjata Keïta", "Sonni Ali Ber"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 2, // Sundjata Keïta
        ),
        QuizQuestion(
          text: "Quel empereur du Mali est célèbre pour son pèlerinage à La Mecca et son immense richesse en or ?",
          options: ["Mansa Moussa", "Askia Mohamed", "Kankou Moussa", "Modibo Keïta"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 0, // Mansa Moussa
        ),
        QuizQuestion(
          text: "Quel roi-sorcier du royaume de Sosso était le grand rival de Sundjata Keïta ?",
          options: ["Samory Touré", "Soumaoro Kanté", "Biton Coulibaly", "Babemba Traoré"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 1, // Soumaoro Kanté
        ),
        
        QuizQuestion(
          text: "Quel roi a fondé le Royaume bambara de Ségou au XVIIIe siècle ?",
          options: ["Monzon Diarra", "Ngolo Diarra", "Biton Coulibaly", "Da Monzon"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 2, // Biton Coulibaly
        ),
        QuizQuestion(
          text: "Qui a arracher le baobao",
          options: ["Da Monzon", "Ngolo Diarra", "Soundjata Keita", "Mythe"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 3, // Ngolo Diarra
        ),
      ],
    ),
    // 1. ANIMAUX
    QuizTheme(
      id: "animaux",
      title: "Animaux",
      icon: "assets/images/quiz/animaux.png",
      bgColor: Color(0xFFFFF4E5),
      questions: [
        QuizQuestion(
          text: "Quel est le plus grand animal terrestre ?",
          options: ["Éléphant", "Girafe", "Rinocéros", "Hippopotame"],
          optionEmojis:
          [
            "assets/images/quiz/elephant.png",
            "assets/images/quiz/giraf.png",
            "assets/images/quiz/reno.png",
            "assets/images/quiz/hippoptame.png"
          ],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          text: "Quel oiseau court très vite mais ne sait pas voler ?",
          options: ["Aigle", "Autruche", "Manchot", "Perroquet"],
          optionEmojis:
          [
            "assets/images/quiz/aigle.png",
            "assets/images/quiz/autriche.png",
            "assets/images/quiz/manchot.png",
            "assets/images/quiz/perroquet.png"
          ],
          correctAnswerIndex: 1,
        ),
        QuizQuestion(
          text: "Quel animal marin possède huit bras (tentacules) ?",
          options: ["Dauphin", "Requin", "Pieuvre", "Baleine"],
          optionEmojis:
          [
            "assets/images/quiz/dauphin.png",
            "assets/images/quiz/requin.png",
            "assets/images/quiz/pieuvre.png",
            "assets/images/quiz/baleine.png"
          ],
          correctAnswerIndex: 2,
        ),
      ],
    ),

    // 3. GÉOGRAPHIE
    QuizTheme(
      id: "geographie",
      title: "Géographie",
      icon: "assets/images/quiz/geographie.png",
      bgColor: Color(0xFFE5FFE9),
      questions: [
        QuizQuestion(
          text: "Quel est le plus grand pays du monde ?",
          options: ["Canada", "Russie", "Chine", "France"],
          optionEmojis: [
            "assets/images/quiz/dauphin.png",
            "assets/images/quiz/requin.png",
            "assets/images/quiz/pieuvre.png",
            "assets/images/quiz/baleine.png"
          ],
          correctAnswerIndex: 1,
        ),
        QuizQuestion(
          text: "Quel fleuve traverse l'Égypte ?",
          options: ["L'Amazone", "Le Mississippi", "Le Nil", "La Seine"],
          optionEmojis: [
            "assets/images/quiz/dauphin.png",
            "assets/images/quiz/requin.png",
            "assets/images/quiz/pieuvre.png",
            "assets/images/quiz/baleine.png"
          ],
          correctAnswerIndex: 2,
        ),
      ],
    ),
  ];
}
