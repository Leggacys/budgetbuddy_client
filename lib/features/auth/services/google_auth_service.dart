import 'dart:convert';

import 'package:budgetbuddy_client/core/constants/constants.dart';
import 'package:budgetbuddy_client/core/services/secure_storage_service.dart';
import 'package:budgetbuddy_client/features/auth/services/user_preferences_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signInWithGoogle() async {
  try {
    // ✅ Step 1: Initialize Google Sign-In with serverClientId
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'openid'],
      serverClientId:
          '28884617565-99hfhdhmpansfktr5rn8bp2j7aqng4tn.apps.googleusercontent.com',
    );

    // Trigger Google Sign-In
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      logger.e('❌ User cancelled Google sign-in.');
      return false;
    }

    // Step 2: Get authentication tokens
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    logger.d('✅ Google authentication successful: ${googleAuth.accessToken}');
    logger.d('✅ Google ID token: ${googleAuth.idToken}');

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

    // Step 5: Send email to Flask backend
    final response = await http.post(
      Uri.parse('$devServerUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: '{"id_token": "${googleAuth.idToken}"}',
    );

    if (response.statusCode == 200) {
      logger.d('✅ Email sent to server.');
      final email = user.email!;
      logger.d('✅ Logged in as: $email');

      final Map<String, dynamic> responseData =
          json.decode(response.body) as Map<String, dynamic>;

      final tokens = responseData['tokens'];
      final int expiresIn = tokens['expires_in'] as int;
      final int issuedAt = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await SecureStorageService().saveToken(tokens['access_token']);
      await SecureStorageService().saveRefreshToken(tokens['refresh_token']);
      DateTime expiryDate = DateTime.fromMillisecondsSinceEpoch(
        (issuedAt + expiresIn) * 1000,
      );
      await SecureStorageService().saveTokenExpiry(expiryDate);

      await UserPreferences.setEmail(email);

      logger.d('✅ Token, refresh token, and expiry saved successfully.');
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
