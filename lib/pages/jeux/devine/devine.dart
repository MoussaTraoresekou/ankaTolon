import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GuessNumberScreen(),
    ),
  );
}

class GuessNumberScreen extends StatefulWidget {
  const GuessNumberScreen({super.key});

  @override
  State<GuessNumberScreen> createState() => _GuessNumberScreenState();
}

class _GuessNumberScreenState extends State<GuessNumberScreen> {
  final int _maxNumber = 20;

  late int _secretNumber;

  int _attempts = 0;

  String _hintMessage = "Trouve le nombre secret !";
  String _hintEmoji = "🤔";
  Color _hintColor = const Color(0xFF475569);

  bool _hasWon = false;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _secretNumber = Random().nextInt(_maxNumber) + 1;
      _attempts = 0;

      _hintMessage = "Trouve le nombre secret !";
      _hintEmoji = "🤔";
      _hintColor = const Color(0xFF475569);

      _hasWon = false;

      _controller.clear();
    });
  }

  void _checkGuess() {
    final input = _controller.text.trim();

    if (input.isEmpty) {
      setState(() {
        _hintMessage = "Entre d'abord un nombre 😊";
        _hintEmoji = "✏️";
        _hintColor = const Color(0xFFF59E0B);
      });
      return;
    }

    final guessedNumber = int.tryParse(input);

    if (guessedNumber == null ||
        guessedNumber < 1 ||
        guessedNumber > _maxNumber) {
      setState(() {
        _hintMessage = "Choisis un nombre entre 1 et $_maxNumber !";
        _hintEmoji = "🙈";
        _hintColor = const Color(0xFFEF6A6A);
      });
      return;
    }

    setState(() {
      _attempts++;

      if (guessedNumber == _secretNumber) {
        _hasWon = true;

        _hintMessage =
        "Bravo ! 🎉\nTu as trouvé en $_attempts ${_attempts == 1 ? "essai" : "essais"} !";

        _hintEmoji = "🏆";
        _hintColor = const Color(0xFF43A875);
      } else if (guessedNumber < _secretNumber) {
        _hintMessage = "C'est plus grand !";
        _hintEmoji = "⬆️";
        _hintColor = const Color(0xFFF59E0B);
      } else {
        _hintMessage = "C'est plus petit !";
        _hintEmoji = "⬇️";
        _hintColor = const Color(0xFF5B8DEF);
      }
    });

    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: Stack(
          children: [

            Positioned(
              top: 40,
              right: -20,
              child: _DecorativeCircle(
                size: 90,
                color: const Color(0xFFE3F2E9),
              ),
            ),

            Positioned(
              top: 180,
              left: -35,
              child: _DecorativeCircle(
                size: 70,
                color: const Color(0xFFFFF0D8),
              ),
            ),

            Positioned(
              bottom: 120,
              right: -30,
              child: _DecorativeCircle(
                size: 100,
                color: const Color(0xFFE5EEFF),
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  // HEADER
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
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
                                "Petit jeu",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              Text(
                                "Devine le nombre",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Nombre d'essais
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Text(
                                "⭐",
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "$_attempts",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 15),

                          // Titre
                          const Text(
                            "À toi de jouer !",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF334155),
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            "Choisis un nombre entre 1 et $_maxNumber",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                          ),

                          const SizedBox(height: 30),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(
                              20,
                              24,
                              20,
                              26,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.045),
                                  blurRadius: 25,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Emoji
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: Container(
                                    key: ValueKey(_hintEmoji),
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: _hasWon
                                          ? const Color(0xFFE8F7EE)
                                          : const Color(0xFFF5F8F6),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _hintEmoji,
                                      style: const TextStyle(
                                        fontSize: 58,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 22),

                                // Bulle d'indice
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _hintColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _hintMessage,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      height: 1.35,
                                      fontWeight: FontWeight.w800,
                                      color: _hintColor,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 25),


                                if (!_hasWon) ...[
                                  Container(
                                    height: 76,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAF9),
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: const Color(0xFFE4ECE7),
                                        width: 2,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _controller,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      maxLength: 2,
                                      autofocus: false,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF334155),
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: "?",
                                        hintStyle: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFFCBD5E1),
                                        ),
                                        counterText: "",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  // Bouton
                                  SizedBox(
                                    width: double.infinity,
                                    height: 58,
                                    child: ElevatedButton(
                                      onPressed: _checkGuess,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        const Color(0xFF68B984),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Deviner",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(width: 8),

                                        ],
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  SizedBox(
                                    width: double.infinity,
                                    height: 58,
                                    child: ElevatedButton(
                                      onPressed: _startNewGame,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        const Color(0xFFF3A447),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Rejouer",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "🎮",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Petit indicateur
                          if (!_hasWon)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.lightbulb_outline_rounded,
                                  size: 18,
                                  color: Color(0xFFF3A447),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Réfléchis bien avant de répondre !",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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