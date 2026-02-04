import 'package:flutter/material.dart';
import 'package:flutter_game_of_flags/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          toolbarHeight: 70,
          iconTheme: IconThemeData(
            size: 40,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}