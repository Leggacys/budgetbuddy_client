import 'dart:convert';

import 'package:budgetbuddy_client/services/user_preferences.dart';
import 'package:http/http.dart' as http;

Future<int> SentCode(String code) async {
  final email = await UserPreferences.getEmail();
  final data = {'code': code, 'email': email};
  final body = jsonEncode(data);
  final url = Uri.parse('http://10.0.2.2:5000/code');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (response.statusCode == 200) {
    print('✅ Code sent successfully: ${response.body}');
    return response.statusCode;
  } else {
    print('❌ Failed to send code: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to send code');
  }
}
