import 'package:flutter/material.dart';
import 'package:tolon/cor/theme/app_theme.dart';

class Jouetdetail extends StatefulWidget {
  const Jouetdetail({super.key});

  @override
  State<Jouetdetail> createState() => _JouetdetailState();
}

class _JouetdetailState extends State<Jouetdetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
        appBar: AppBar(
            title: Text("Detail d'un joouet"),

        ),
    );
  }
}