import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tolon/pages/categorieAdmin/categorie.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MonApplication());
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'CRUD Catégories',

      home: const CategoriePage(),
    );
  }
}