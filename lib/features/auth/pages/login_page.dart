import 'package:budgetbuddy_client/features/banking/pages/link_bank_page.dart';
import 'package:budgetbuddy_client/features/auth/services/google_auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 57, 49),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/Fox.png', width: 200, height: 200),
            SizedBox(height: 40),
            Text(
              'budget\n buddy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 70,
                color: Colors.white,
                height: 0.8,
              ),
            ),
            SizedBox(height: 60),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: TextStyle(fontSize: 20),
                  foregroundColor: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/GoogleLogo.png',
                      width: 37,
                      height: 37,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 10),
                    Text('Sign in with Google', style: TextStyle(fontSize: 20)),
                  ],
                ),
                onPressed: () async {
                  final user = await signInWithGoogle();
                  if (user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LinkYourBankPage()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
