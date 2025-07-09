import 'package:budgetbuddy_client/core/constants/app_constants.dart';
import 'package:budgetbuddy_client/features/auth/services/user_preferences_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

final logger = Logger();

Future<bool> signInWithGoogle() async {
  try {
    // Step 1: Trigger Google Sign-In
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      logger.e('❌ User cancelled Google sign-in.');
      return false;
    }

    // Step 2: Get authentication tokens
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Step 3: Create Firebase credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Step 4: Sign in with Firebase
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user == null || user.email == null) {
      logger.e('❌ Sign-in failed or email not available.');
      return false;
    }

    final email = user.email!;
    logger.d('✅ Logged in as: $email');

    UserPreferences.setEmail(email);
    logger.d('✅ Email saved to user preferences: $email');

    // Step 5: Send email to Flask backend
    final response = await http.post(
      Uri.parse('$devServerUrl/login'), // or use your real server IP/domain
      headers: {'Content-Type': 'application/json'},
      body: '{"email": "$email"}',
    );

    if (response.statusCode == 200) {
      logger.d('✅ Email sent to server.');
      return true;
    } else {
      logger.e(
        '❌ Failed to send email. Status: ${response.statusCode}, Body: ${response.body}',
      );
      return false;
    }
  } catch (e) {
    logger.e('❌ Error during sign-in and send: $e');
    return false;
  }
}
