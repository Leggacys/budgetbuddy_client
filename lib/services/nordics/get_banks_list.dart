import 'dart:convert';

import 'package:budgetbuddy_client/constants.dart';
import 'package:budgetbuddy_client/features/transactions/data/data_source/bank_data_source.dart';
import 'package:budgetbuddy_client/services/google_auth.dart';
import 'package:http/http.dart' as http;

Future<List<Bank>> getBanksList(String countryCode) async {
  final url = Uri.parse(
    '$devServerUrl/list-of-banks-from-country?country_code=$countryCode',
  );
  final response = await http.get(url);

  if (response.statusCode == 200) {
    logger.d('✅ Banks list retrieved successfully: ${response.body}');
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((bankData) => Bank.fromJson(bankData as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception(
      'Failed to load banks list: ${response.statusCode} - ${response.body}',
    );
  }
}
