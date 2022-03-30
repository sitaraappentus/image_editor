import 'package:flutter/material.dart';
import 'package:image_editor/crop_screen.dart';
import 'package:image_editor/result_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResultScreen(),
    );
  }
}



