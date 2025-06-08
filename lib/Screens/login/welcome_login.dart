import 'package:ankush_bichewar_centralogic_assinment/Screens/login/Register_page.dart';
import 'package:ankush_bichewar_centralogic_assinment/Screens/login/login_page.dart';
import 'package:flutter/material.dart';

class WelcomePagetwo extends StatelessWidget {
  const WelcomePagetwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Search & Discover Movies',
              style: TextStyle(
                fontSize: 24,
                
                fontWeight: FontWeight.w700,
                color: Color(0xFFD4AF37), // Gold color
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/welcome.png',
              height: 349,
            ),
            const SizedBox(height: 50),
            // Register Button
            SizedBox(
              width: 297,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37), // Gold
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  RegisterPage()));
                },
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Login Button
            SizedBox(
              width: 297,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFD4AF37), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  LoginPage()));
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
