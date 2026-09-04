import 'package:flutter/material.dart';

class QuizQuestion {
  final String text;
  final List<String> options;
  final List<String> optionEmojis;
  final int correctAnswerIndex;

  const QuizQuestion({
    required this.text,
    required this.options,
    required this.optionEmojis,
    required this.correctAnswerIndex,
  });
}

class QuizTheme {
  final String id;
  final String title;
  final String icon;
  final Color bgColor;
  final List<QuizQuestion> questions;

  const QuizTheme({
    required this.id,
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.questions,
  });

  int get quizCount => questions.length;
}
