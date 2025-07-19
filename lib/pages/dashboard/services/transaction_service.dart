import 'dart:convert';

import 'package:budgetbuddy_client/core/constants/constants.dart';
import 'package:budgetbuddy_client/pages/dashboard/models/transaction_model.dart';
import 'package:budgetbuddy_client/services/user_preferences.dart';
import 'package:http/http.dart';

class TransactionService {
  static Future<Map<String, dynamic>> fetchTransactions() async {
    try {
      final email = await UserPreferences.getEmail();
      final url = Uri.parse(
        '$devServerUrl/nordingen-get-transactions?email=${Uri.encodeComponent(email ?? "")}',
      );

      final response = await get(url);

      if (response.statusCode == 200) {
        final dynamic jsonData = json.decode(response.body);

        // if (jsonData is Map<String, dynamic>) {
        //   // Response is an object like: {"transactions": [...], "status": "success"}
        //   transactionsList = jsonData['transactions'] ?? [];
        // } else if (jsonData is List) {
        //   // Response is directly an array like: [{"category": "food"}, {"category": "gas"}]
        //   transactionsList = jsonData;
        // } else {
        //   logger.d('Unexpected response format: $jsonData');
        //   return [];
        // }

        // List<Transaction> transactions = transactionsList
        //     .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
        //     .toList();

        logger.d('Fetched ${jsonData['total_count']} transactions');
        return {
          'categories': jsonData['categories'],
          'summary': jsonData['summary'],
        };
      }
    } catch (e) {
      logger.d('Error fetching transactions: $e');
      return {'categories': [], 'summary': {}};
    }
    return {'categories': [], 'summary': {}};
  }

  static double calculateTotalExpenses(List<Transaction> transactions) {
    double total = 0.0;
    for (var transaction in transactions) {
      logger.d(transaction.amount);
      final amount = double.tryParse(transaction.amount) ?? 0.0;
      if (amount < 0) {
        total += amount;
      }
    }
    return total * -1;
  }
}
