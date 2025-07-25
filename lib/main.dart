import 'package:flutter/material.dart';
import 'package:wispurr/app/screens/home_screen.dart';

import 'app/screens/auth/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const isLogged = false;

    return const MaterialApp(
      home: isLogged ? HomeScreen() : AuthScreen(),
    );
  }
}
