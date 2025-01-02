import 'package:flutter/material.dart';
import 'package:xyz/pages/splash_screen.dart'; // Import the splash screen.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Set SplashScreen as the home page.
    );
  }
}
