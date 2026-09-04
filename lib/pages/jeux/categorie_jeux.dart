import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/jeux/datas.dart';
import 'package:tolon/models/jeux/quiz_models.dart';
import 'package:tolon/pages/jeux/question.dart';
import 'package:tolon/pages/jeux/widget/baniere.dart';
import 'package:tolon/pages/jeux/widget/entete.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Kids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: context.bgColor,
        fontFamily: 'Poppins',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<QuizTheme> _themes = QuizData.themes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Entete(),
              const SizedBox(height: 28),
              // Bannière Centrale
              Baniere(),
              const SizedBox(height: 32),

               Text(
                "Choisis une catégorie",
                style: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.textDark),
              ),
              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _themes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  final theme = _themes[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPlayScreen(theme: theme),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.bgColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0x7677AF6F), width: .5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.bgColor,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(theme.icon, 
                              height: MediaQuery.of(context).size.width * 0.28 ,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            theme.title,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${theme.quizCount} Question",
                            style: const TextStyle(fontSize: 11, color: Color(0xFFA0AEC0), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
}
