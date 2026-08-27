import 'package:flutter/material.dart';
import 'package:tolon/models/jeux/quiz_models.dart';

class QuizData {
  static const List<QuizTheme> themes = [
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
          optionEmojis: ["🐘", "🦒", "🦏", "🦛"],
          correctAnswerIndex: 0,
        ),
        QuizQuestion(
          text: "Quel oiseau court très vite mais ne sait pas voler ?",
          options: ["Aigle", "Autruche", "Manchot", "Perroquet"],
          optionEmojis: ["🦅", "🦩", "🐧", "🦜"],
          correctAnswerIndex: 1,
        ),
        QuizQuestion(
          text: "Quel animal marin possède huit bras (tentacules) ?",
          options: ["Dauphin", "Requin", "Pieuvre", "Baleine"],
          optionEmojis: ["🐬", "🦈", "🐙", "🐳"],
          correctAnswerIndex: 2,
        ),
      ],
    ),

    // 2. SCIENCES
    QuizTheme(
      id: "sciences",
      title: "Sciences",
      icon: "assets/images/quiz/science.png",
      bgColor: Color(0xFFE5F6FF),
      questions: [
        QuizQuestion(
          text: "Quelle planète est la plus proche du Soleil ?",
          options: ["Terre", "Mars", "Mercure", "Jupiter"],
          optionEmojis: ["🌍", "🔴", "🪐", "🌌"],
          correctAnswerIndex: 2,
        ),
        QuizQuestion(
          text: "Où se trouve le cœur chez l'être humain ?",
          options: ["Dans la tête", "À gauche de la poitrine", "Dans le ventre", "Dans le bras"],
          optionEmojis: ["🧠", "🫀", "🍕", "💪"],
          correctAnswerIndex: 1,
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
          optionEmojis: ["🍁", "🇷🇺", "🏮", "🥖"],
          correctAnswerIndex: 1,
        ),
        QuizQuestion(
          text: "Quel fleuve traverse l'Égypte ?",
          options: ["L'Amazone", "Le Mississippi", "Le Nil", "La Seine"],
          optionEmojis: ["🌴", "🇺🇸", "🐊", "🗼"],
          correctAnswerIndex: 2,
        ),
      ],
    ),

    // 4. HISTOIRE
    QuizTheme(
      id: "histoire",
      title: "Histoire",
      icon: "assets/images/quiz/histoire.png",
      bgColor: Color(0xFFF3E5FF),
      questions: [
        QuizQuestion(
          text: "Qui ont construit les grandes pyramides ?",
          options: ["Les Romains", "Les Égyptiens", "Les Chevaliers", "Les Pirates"],
          optionEmojis: ["🛡️", "👑", "🏰", "🏴‍☠️"],
          correctAnswerIndex: 1,
        ),
        QuizQuestion(
          text: "Quel peuple habitait dans des châteaux forts au Moyen Âge ?",
          options: ["Les Égyptiens", "Les Romains", "Les Seigneurs et Chevaliers", "Les Astronautes"],
          optionEmojis: ["📯", "🏛️", "⚔️", "🚀"],
          correctAnswerIndex: 2,
        ),
      ],
    ),

    // 5. MATHS
    QuizTheme(
      id: "maths",
      title: "Maths",
      icon: "assets/images/quiz/math.png",
      bgColor: Color(0xFFFFE5EC),
      questions: [
        QuizQuestion(
          text: "Combien font 5 x 4 ?",
          options: ["15", "20", "25", "30"],
          optionEmojis: ["🍎", "🍇", "🍓", "🍌"],
          correctAnswerIndex: 1,
        ),
        QuizQuestion(
          text: "Si j'ai 10 bonbons et que j'en donne 3, combien m'en reste-t-il ?",
          options: ["5", "6", "7", "8"],
          optionEmojis: ["🍬", "🍭", "🍫", "🍩"],
          correctAnswerIndex: 2,
        ),
      ],
    ),

    // 6. SPORT
    QuizTheme(
      id: "sport",
      title: "Sport",
      icon: "assets/images/quiz/sport.png",
      bgColor: Color(0xFFE5FDFB),
      questions: [
        QuizQuestion(
          text: "Combien de joueurs forment une équipe de football sur le terrain ?",
          options: ["7 joueurs", "9 joueurs", "11 joueurs", "15 joueurs"],
          optionEmojis: ["🏃", "👟", "🥅", "🏆"],
          correctAnswerIndex: 2,
        ),
        QuizQuestion(
          text: "Dans quel sport utilise-t-shirt une raquette et un volant ?",
          options: ["Tennis", "Badminton", "Ping-pong", "Basket"],
          optionEmojis: ["🎾", "🏸", "🏓", "🏀"],
          correctAnswerIndex: 1,
        ),
      ],
    ),
  ];
}
