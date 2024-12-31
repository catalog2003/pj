import 'package:flutter/material.dart';
import 'package:xyz/pages/home_page.dart'; // Import your home page.

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // Delay and navigate to home page
  Future<void> _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3)); // Show splash screen for 3 seconds.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), // Replace with your home page.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/splash_logo.png'), // Add your splash screen logo image.
            SizedBox(height: 20),
            Text(
              'Your App Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
