import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/models/jeux/datas.dart';
import 'package:tolon/models/jeux/quiz_models.dart';
import 'package:tolon/pages/jeux/question.dart';

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
        scaffoldBackgroundColor: const Color(0xFFFBFBFE),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu_rounded, size: 28, color: Color(0xFF2D3748)),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, size: 28, color: Color(0xFF2D3748)),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text("Quiz, ", style: TextStyle(fontSize: 22, color: Color(0xFF718096), fontWeight: FontWeight.w500)),
                          Text("👋", style: TextStyle(fontSize: 22)),
                        ],
                      ),
                      const Text(
                        "Petit(e) champion(ne) !",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A202C)),
                      ),
                    ],
                  ),
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppStyles.bgColor,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Center(
                      child: Image.asset("assets/images/avatars/avatar1.png"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 3. Bannière Centrale
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xFAFFFB),
                  /*gradient: LinearGradient(
                    colors: [const Color(0xFF6C5CE7).withOpacity(0.06), const Color(0xFFa29bfe).withOpacity(0.03)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),*/
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppStyles.navbarColor, width: 1.5),
                ),
                child: Column(
                  children: [
                    const Text("🏆", style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 12),
                    const Text(
                      "Apprends en t'amusant",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A202C)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Réponds aux quiz et gagne\ndes étoiles !",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF718096), height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 4. Section Titre
              const Text(
                "Choisis un thème",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A202C)),
              ),
              const SizedBox(height: 16),

              // 5. Grille des thèmes (Fermetures de blocs réparées)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _themes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFFEDF2F7), width: 1.5),
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
                            child: Text(theme.icon, style: const TextStyle(fontSize: 28)),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            theme.title,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "${theme.quizCount} Quiz",
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
