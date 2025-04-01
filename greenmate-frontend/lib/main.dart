import 'package:flutter/material.dart';
import 'package:green_mate/pages/intro_page.dart';
import 'package:green_mate/pages/login_page.dart';

void main() {
  runApp(const GreenMateApp());
}

class GreenMateApp extends StatelessWidget {
  const GreenMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
