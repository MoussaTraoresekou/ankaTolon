import 'package:flutter/material.dart';
import 'package:tolon/models/jeux/datas.dart';
import 'package:tolon/models/jeux/quiz_models.dart';

class QuizPlayScreen extends StatefulWidget {
  final QuizTheme theme;

  const QuizPlayScreen({super.key, required this.theme});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int _currentIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  int _scoreStars = 120;

  void _checkAnswer(int index) {
    if (_isAnswered) return;
    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;
      if (index == widget.theme.questions[_currentIndex].correctAnswerIndex) {
        _scoreStars += 20;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < widget.theme.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("🎉 Super ! 🎉", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6C5CE7))),
              const SizedBox(height: 16),
              const Text("Tu as terminé ce quiz avec succès !", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text("Génial !", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.theme.questions[_currentIndex];
    final progress = (_currentIndex + 1) / widget.theme.questions.length;
    final List<String> optionLetters = ["A", "B", "C", "D"];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barre supérieure
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 28, color: Color(0xFF2D3748)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "Question ${_currentIndex + 1}/${widget.theme.questions.length}",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF718096)),
                  ),
                  Row(
                    children: [
                      const Text("⭐", style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 4),
                      Text("$_scoreStars", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D3748))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Barre de progression
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFF0EFFF),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C5CE7)),
                ),
              ),
              const SizedBox(height: 48),

              // Texte de la Question
              Text(
                currentQuestion.text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.4),
              ),
              const SizedBox(height: 40),

              // Options de réponse interactives (Fermetures de widgets réparées)
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currentQuestion.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedAnswerIndex == index;

                    Color cardBgColor = Colors.white;
                    Color borderColor = isSelected ? const Color(0xFF6C5CE7) : const Color(0xFFF1F5F9);
                    Color letterBgColor = isSelected ? const Color(0xFF6C5CE7) : const Color(0xFFF8FAFC);
                    Color letterTextColor = isSelected ? Colors.white : const Color(0xFF64748B);

                    if (_isAnswered) {
                      if (index == currentQuestion.correctAnswerIndex) {
                        cardBgColor = const Color(0xFFE6F4EA);
                        borderColor = const Color(0xFF34A853);
                        letterBgColor = const Color(0xFF34A853);
                        letterTextColor = Colors.white;
                      } else if (isSelected) {
                        cardBgColor = const Color(0xFFFCE8E6);
                        borderColor = const Color(0xFFEA4335);
                        letterBgColor = const Color(0xFFEA4335);
                        letterTextColor = Colors.white;
                      }
                    }

                    return InkWell(
                      onTap: () => _checkAnswer(index),
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: letterBgColor),
                              child: Center(
                                child: Text(optionLetters[index], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: letterTextColor)),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                currentQuestion.options[index],
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                              ),
                            ),
                            Text(currentQuestion.optionEmojis[index], style: const TextStyle(fontSize: 36)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bouton Suivant fixe en bas
              ElevatedButton(
                onPressed: _isAnswered ? _nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFE2E8F0),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: Text(
                  _currentIndex == widget.theme.questions.length - 1 ? "Terminer" : "Suivant",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
