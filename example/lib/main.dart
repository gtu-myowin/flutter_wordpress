import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const WordPressApp());
}

class WordPressApp extends StatelessWidget {
  const WordPressApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WordPress Demo',
      theme: ThemeData.light(),
      home: const LoginPage(),
    );
  }
}
