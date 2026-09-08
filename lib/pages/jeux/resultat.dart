import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tolon/controller/enfant/ProviderPoint/points_provider.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/jeux/quiz_models.dart';

class QuizResultScreen extends ConsumerStatefulWidget {
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
  ConsumerState<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen> {
  @override
  void initState() {
    super.initState();
    // Ajout local des étoiles dès l'affichage de la page de résultat
    Future.microtask(() {
      if (widget.totalStarsGained > 0) {
        ref
            .read(enfantPointsProvider.notifier)
            .ajouterEtoiles(widget.totalStarsGained);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalQuestions = widget.theme.questions.length;
    final double successRate = widget.correctAnswersCount / totalQuestions;

    String title;
    String message;
    String animationOrEmoji;
    Color scoreColor;

    if (successRate == 1.0) {
      title = "👑 Parfait ! 👑";
      message =
          "Incroyable ! Tu as trouvé toutes les réponses ! Un vrai champion du Mali !";
      animationOrEmoji = "🏆";
      scoreColor = const Color(0xFF34A853);
    } else if (successRate >= 0.5) {
      title = "🎉 Super ! 🎉";
      message = "Tu as un très bon score. Bien joué, continue comme ça !";
      animationOrEmoji = "⭐";
      scoreColor = const Color(0xFF63B47E);
    } else if (widget.correctAnswersCount > 0) {
      title = "👍 Pas mal ! 👍";
      message = "Tu as de bonnes bases. Réessaie pour décrocher la couronne !";
      animationOrEmoji = "💪";
      scoreColor = const Color(0xFFE67E22);
    } else {
      title = "🙃 Oups... 🙃";
      message =
          "Aucune bonne réponse cette fois-ci, mais l'important c'est d'apprendre !";
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

              Center(
                child: Text(
                  animationOrEmoji,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
              const SizedBox(height: 24),

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
                    Column(
                      children: [
                        const Text(
                          "Réponses",
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${widget.correctAnswersCount}/$totalQuestions",
                          style: TextStyle(
                            color: scoreColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: const Color(0xFFE2E8F0),
                    ),
                    Column(
                      children: [
                        const Text(
                          "Étoiles gagnées",
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "+${widget.totalStarsGained} ⭐",
                          style: const TextStyle(
                            color: Color(0xFFF59E0B),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, "replay");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF63B47E),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Rejouer le Quiz",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF64748B),
                  minimumSize: const Size(double.infinity, 54),
                ),
                child: const Text(
                  "Retour à l'accueil",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
