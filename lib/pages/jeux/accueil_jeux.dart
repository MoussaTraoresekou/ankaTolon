import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/pages/jeux/categorie_jeux.dart';
import 'package:tolon/pages/jeux/devine/devine.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GamesHomeScreen(),
    ),
  );
}


class GamesHomeScreen extends StatelessWidget {
  const GamesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: Stack(
          children: [

            Positioned(
              top: 70,
              right: -30,
              child: _DecorativeCircle(
                size: 100,
                color: const Color(0xFFE7F4EB),
              ),
            ),

            Positioned(
              top: 270,
              left: -35,
              child: _DecorativeCircle(
                size: 75,
                color: const Color(0xFFFFF1DA),
              ),
            ),

            Positioned(
              bottom: 100,
              right: -30,
              child: _DecorativeCircle(
                size: 90,
                color: const Color(0xFFE7EEFF),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      _BackButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),

                      const SizedBox(width: 14),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Amusons-nous !",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            Text(
                              "Mes jeux",
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Text(
                            "🎮",
                            style: TextStyle(fontSize: 21),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF6EE),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Prêt à jouer ?",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF365A45),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "Apprends en t'amusant\navec nos petits jeux !",
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        const Text(
                          "🧒🏻",
                          style: TextStyle(fontSize: 65),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    "Choisis ton jeu",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF334155),
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    "Quel défi veux-tu relever aujourd'hui ?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),

                  const SizedBox(height: 20),


                  _GameCard(
                    backgroundColor: const Color(0xFFEFF6FF),
                    iconBackgroundColor: const Color(0xFFDCEBFF),
                    icon: "🧠",
                    title: "Quiz",
                    description:
                    "Réponds aux questions et teste tes connaissances.",
                    buttonColor: const Color(0xFFF3A447),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuizApp(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  _GameCard(
                    backgroundColor: const Color(0xFFFFF5E6),
                    iconBackgroundColor: const Color(0xFFFFE9C5),
                    icon: "🔢",
                    title: "Devine le nombre",
                    description:
                    "Trouve le nombre secret grâce aux indices.",
                    buttonColor: const Color(0xFFF3A447),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GuessNumberScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Petit message
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "✨",
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          "Chaque jeu est une nouvelle aventure !",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _GameCard extends StatelessWidget {
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final String icon;
  final String title;
  final String description;
  final Color buttonColor;
  final VoidCallback onTap;

  const _GameCard({
    required this.backgroundColor,
    required this.iconBackgroundColor,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.8),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              // Illustration
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 42),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF334155),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7B8794),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Bouton
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Jouer",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: const SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF475569),
            size: 22,
          ),
        ),
      ),
    );
  }
}

// decoration


class _DecorativeCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _DecorativeCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}