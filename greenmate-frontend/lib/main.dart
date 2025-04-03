import 'package:flutter/material.dart';
import 'package:green_mate/pages/auth_page.dart';
import 'package:green_mate/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:green_mate/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GreenMateApp());
}

class GreenMateApp extends StatelessWidget {
  const GreenMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
