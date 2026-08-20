import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tolon/cor/router/routes.dart';
import 'package:tolon/cor/theme/app_theme.dart';
import 'package:tolon/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation obligatoire de votre projet Firebase 'ankatolon' lié à l'étape précédente
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://zoagjvcjrolrrlhdkhob.supabase.co',
    anonKey: 'sb_publishable_KDK3Dxx_1XfarmHK1CI5YA_c4aRncjy',
  );
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écoute dynamique de la configuration de votre GoRouter d'équipe
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Ankan Tolon - Éveil Enfant',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      
      // Configuration des thèmes Material Design requis par le sujet
      themeMode: ThemeMode.system, // Bascule automatique Clair / Sombre
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAFBF9),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppStyles.bgColor,
          iconTheme: IconThemeData(color: Colors.white, size: 28),
        ),
        
      ),
    );
  }
}
