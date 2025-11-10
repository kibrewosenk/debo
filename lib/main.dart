import 'package:flutter/material.dart';
import 'home_page.dart';
import 'theme.dart';

void main() {
  runApp(const DeboApp());
}

class DeboApp extends StatelessWidget {
  const DeboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debo',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const HomePage(),
    );
  }
}
