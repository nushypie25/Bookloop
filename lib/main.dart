import 'package:flutter/material.dart';
import 'login_page.dart';
import 'create_account_page.dart';
import 'home_page.dart';
void main() {
  runApp(const BookLoopApp());
}

class BookLoopApp extends StatelessWidget {
  const BookLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookLoop',
      home: const SplashScreen(),
    );
  }
}

// ---------------- SPLASH SCREEN ----------------

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.menu_book_rounded,
              size: 100,
            ),

            const SizedBox(height: 20),

            const Text(
              'BookLoop',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Buy • Sell • Exchange • Review',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}