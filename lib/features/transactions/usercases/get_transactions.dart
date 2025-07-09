import 'dart:convert';

import 'package:budgetbuddy_client/services/user_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> getTransactions() async {
  final email = await UserPreferences.getEmail();
  final startDate = '2023-12-01'; // Example start date
  final endDate = '2023-12-31'; // Example end date

  final url = Uri.parse(
    'http://10.0.2.2:5000/transactions'
    '?email=$email&start_date=$startDate&end_date=$endDate',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final transactions = jsonDecode(response.body);
    print('✅ Transactions retrieved successfully: $transactions');
  } else {
    print(
      '❌ Failed to retrieve transactions: ${response.statusCode} - ${response.body}',
    );
    throw Exception('Failed to retrieve transactions');
  }
}
