import 'package:flutter/material.dart';
import 'package:tolon/commun_widget/bottom_navigation_bar.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("page1"),),
      bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}
