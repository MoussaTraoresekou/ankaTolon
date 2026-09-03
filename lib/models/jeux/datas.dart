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
          text: "Quel empereur a fondé la dynastie des Askia au sein de l'Empire Songhaï ?",
          options: ["Sonni Ali Ber", "Askia Mohamed", "Mansa Maghan", "Daouda Traoré"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 1, // Askia Mohamed
        ),
        QuizQuestion(
          text: "Quel roi de Sikasso est resté célèbre pour sa résistance farouche contre les troupes coloniales françaises ?",
          options: ["Tiéba Traoré", "Babemba Traoré", "Biton Coulibaly", "Ngolo Diarra"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 1, // Babemba Traoré
        ),
        QuizQuestion(
          text: "Quelle charte historique, considérée comme l'une des premières déclarations des droits de l'homme, a été proclamée sous Sundjata Keïta ?",
          options: ["La Charte de Ségou", "La Charte de Kouroukan Fouga", "La Charte de Kita", "Le Code de Tombouctou"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 1, // La Charte de Kouroukan Fouga
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
          text: "Quelle ville malienne est devenue un centre mondial de savoir et de commerce de l'or sous l'Empire du Mali et du Songhaï ?",
          options: ["Mopti", "Gao", "Ségou", "Tombouctou"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 3, // Tombouctou
        ),
        QuizQuestion(
          text: "Quel grand conquérant et chef de l'Empire Toucouleur a pris le contrôle de Ségou au XIXe siècle ?",
          options: ["El Hadj Oumar Tall", "Samory Touré", "Tiéba Traoré", "Amadou Cheikhou"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 0, // El Hadj Oumar Tall
        ),
        QuizQuestion(
          text: "Quel empereur guerrier a fondé l'Empire Songhaï en capturant Tombouctou et Djenné ?",
          options: ["Askia Mohamed", "Sonni Ali Ber", "Mansa Moussa", "Soumaoro Kanté"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 1, // Sonni Ali Ber
        ),
        QuizQuestion(
          text: "Quel empereur du Mali a envoyé une immense flotte d'embarcations explorer l'océan Atlantique avant Christophe Colomb ?",
          options: ["Mansa Maghan", "Mansa Souleymane", "Aboubakri II", "Sundjata Keïta"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 2, // Aboubakri II
        ),
        QuizQuestion(
          text: "Quel héros national a fondé l'Empire de Wassoulou et résisté pendant des années à la colonisation française ?",
          options: ["Samory Touré", "Babemba Traoré", "Firhoun Ag Al انصاف", "Modibo Keïta"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 0, // Samory Touré
        ),
        QuizQuestion(
          text: "Qui était la mère de Sundjata Keïta, souvent honorée dans l'épopée mandingue pour sa patience et sa force ?",
          options: ["Sogolon Kondé", "Kankou Moussa", "Kassa Sougouné", "Ina Keïta"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 0, // Sogolon Kondé
        ),
        QuizQuestion(
          text: "Quel célèbre mur de défense a été construit à Sikasso pour protéger la ville des attaques de Samory Touré et des Français ?",
          options: ["Le Tata de Sikasso", "La Muraille de Gao", "Le Fort de Medina", "La Digue de Ségou"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 0, // Le Tata de Sikasso
        ),
        QuizQuestion(
          text: "Quel roi a succédé à Biton Coulibaly et a transformé Ségou en un puissant empire militaire ?",
          options: ["Da Monzon", "Ngolo Diarra", "Monzon Diarra", "Tiramakhan Traoré"],
          optionEmojis: [
            "assets/images/quiz/manssa_mussa.png",
            "assets/images/quiz/sumaro.png",
            "assets/images/quiz/sundjata.png",
            "assets/images/quiz/soni_aly.png"
          ],
          correctAnswerIndex: 1, // Ngolo Diarra
        ),
        QuizQuestion(
          text: "Qui a aracher le baobao",
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
          optionEmojis: [
            "assets/images/quiz/dauphin.png",
            "assets/images/quiz/requin.png",
            "assets/images/quiz/pieuvre.png",
            "assets/images/quiz/baleine.png"
          ],
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

    // 4. HISTOIRE

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
          optionEmojis: [
            "assets/images/quiz/dauphin.png",
            "assets/images/quiz/requin.png",
            "assets/images/quiz/pieuvre.png",
            "assets/images/quiz/baleine.png"
          ],
          correctAnswerIndex: 1,
        ),
        QuizQuestion(
          text: "Si j'ai 10 bonbons et que j'en donne 3, combien m'en reste-t-il ?",
          options: ["5", "6", "7", "8"],
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
          optionEmojis: [
            "assets/images/quiz/dauphin.png",
            "assets/images/quiz/requin.png",
            "assets/images/quiz/pieuvre.png",
            "assets/images/quiz/baleine.png"
          ],
          correctAnswerIndex: 2,
        ),
        QuizQuestion(
          text: "Dans quel sport utilise-t-shirt une raquette et un volant ?",
          options: ["Tennis", "Badminton", "Ping-pong", "Basket"],
          optionEmojis: [
            "assets/images/quiz/dauphin.png",
            "assets/images/quiz/requin.png",
            "assets/images/quiz/pieuvre.png",
            "assets/images/quiz/baleine.png"
          ],
          correctAnswerIndex: 1,
        ),
      ],
    ),
  ];
}
