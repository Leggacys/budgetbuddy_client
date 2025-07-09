import 'dart:convert';

import 'package:budgetbuddy_client/constants.dart';
import 'package:budgetbuddy_client/services/google_auth.dart';
import 'package:budgetbuddy_client/services/user_preferences.dart';
import 'package:http/http.dart' as http;

Future<String> getRedirectUrl(String bankId) async {
  final email = await UserPreferences.getEmail();
  final url = Uri.parse(
    '$devServerUrl/nordigen-redirect-url?bank_id=$bankId&email=$email',
  );
  final response = await http.get(url);
  if (response.statusCode == 200) {
    logger.d('✅ Redirect URL retrieved successfully: ${response.body}');
    final data = json.decode(response.body);
    final redirectUrl = data['redirect_url'];
    return redirectUrl;
  } else {
    throw Exception(
      'Failed to get redirect URL: ${response.statusCode} - ${response.body}',
    );
  }
}
