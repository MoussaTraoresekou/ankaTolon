import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/jeux/quiz_models.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizTheme theme;
  final int correctAnswersCount;
  final int totalStarsGained;

  const QuizResultScreen({
    super.key,
    required this.theme,
    required this.correctAnswersCount,
    required this.totalStarsGained,
  });

  @override
  Widget build(BuildContext context) {
    final int totalQuestions = theme.questions.length;
    final double successRate = correctAnswersCount / totalQuestions;

    // Configuration personnalisée selon le score
    String title;
    String message;
    String animationOrEmoji;
    Color scoreColor;

    if (successRate == 1.0) {
      title = "👑 Parfait ! 👑";
      message = "Incroyable ! Tu as trouvé toutes les réponses ! Un vrai champion du Mali !";
      animationOrEmoji = "🏆";
      scoreColor = const Color(0xFF34A853);
    } else if (successRate >= 0.5) {
      title = "🎉 Super ! 🎉";
      message = "Tu as un très bon score. Bien joué, continue comme ça !";
      animationOrEmoji = "⭐";
      scoreColor = const Color(0xFF63B47E);
    } else if (correctAnswersCount > 0) {
      title = "👍 Pas mal ! 👍";
      message = "Tu as de bonnes bases. Réessaie pour décrocher la couronne !";
      animationOrEmoji = "💪";
      scoreColor = const Color(0xFFE67E22);
    } else {
      title = "🙃 Oups... 🙃";
      message = "Aucune bonne réponse cette fois-ci, mais l'important c'est d'apprendre !";
      animationOrEmoji = "📚";
      scoreColor = const Color(0xEA4335FF);
    }

    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Visuel principal (Emoji géant ou illustration)
              Center(
                child: Text(
                  animationOrEmoji,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
              const SizedBox(height: 24),

              // Titre du résultat
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),

              // Message personnalisé
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Encadré du Score final
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Bloc Bonnes réponses
                    Column(
                      children: [
                        const Text("Réponses", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        Text(
                          "$correctAnswersCount/$totalQuestions",
                          style: TextStyle(color: scoreColor, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // Séparateur vertical
                    Container(width: 1, height: 40, color: const Color(0xFFE2E8F0)),
                    // Bloc Étoiles gagnées
                    Column(
                      children: [
                        const Text("Étoiles gagnées", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        Text(
                          "+$totalStarsGained ⭐",
                          style: const TextStyle(color: Color(0xFFF59E0B), fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Bouton Rejouer
              ElevatedButton(
                onPressed: () {
                  // Ferme la page de résultat et réinitialise le jeu actuel
                  Navigator.pop(context, "replay");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF63B47E),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
                child: const Text("Rejouer le Quiz", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),

              // Bouton Quitter / Accueil
              TextButton(
                onPressed: () {
                  // Retourne directement à l'accueil
                  Navigator.pop(context); // Quitte la page résultat
                  Navigator.pop(context); // Quitte la page de quiz
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF64748B),
                  minimumSize: const Size(double.infinity, 54),
                ),
                child: const Text("Retour à l'accueil", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
