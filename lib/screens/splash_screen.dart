
// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // sau 3s thì chuyển sang màn HomeScreen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });

    return Scaffold(
      body: Stack(
        children: [
           Center(
            child: Image.asset(
              'assets/images/cart.png',
               width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Text(
              '© ${DateTime.now().year} Design by Minh Hieu',
              textAlign: TextAlign.center,
              
            ),
            
          ),
        ],
      ),
    );
  }
}
