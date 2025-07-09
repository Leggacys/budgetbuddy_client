import 'dart:convert';
import 'package:budgetbuddy_client/core/constants/app_constants.dart';
import 'package:budgetbuddy_client/features/banking/models/bank_model.dart';
import 'package:budgetbuddy_client/features/auth/services/user_preferences_service.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class NordigenService {
  /// Get list of banks for a specific country
  static Future<List<Bank>> getBanksList(String countryCode) async {
    final url = Uri.parse(
      '$devServerUrl/nordingen-list-of-banks-from-country?country_code=$countryCode',
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

  /// Get redirect URL for bank OAuth flow
  static Future<String> createRequisition(String bankId) async {
    final email = await UserPreferences.getEmail();
    final url = Uri.parse('$devServerUrl/nordingen-create-requisition');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'institution_id': bankId, 'email': email}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      logger.d('✅ Redirect URL retrieved successfully: ${response.body}');

      final data = jsonDecode(response.body);

      // 🔧 Add safety checks
      if (data['link'] == null) {
        throw Exception('Server response missing redirect_url field');
      }

      if (data['requisition_id'] == null) {
        throw Exception('Server response missing requisition_id field');
      }

      // Save requisition ID
      await UserPreferences.saveRequisitionId(data['requisition_id']);

      final redirectUrl = data['link'] as String;

      // 🔧 Validate URL format
      if (!redirectUrl.startsWith('http://') &&
          !redirectUrl.startsWith('https://')) {
        throw Exception('Invalid redirect URL format: $redirectUrl');
      }

      logger.d('🔗 Extracted redirect URL: $redirectUrl');
      return redirectUrl;
    } else {
      throw Exception(
        'Failed to get redirect URL: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Send requisition ID to server after OAuth completion
  static Future<bool> addRequisition({
    required String requisitionId,
    required String bankId,
    required String bankName,
    required String email,
  }) async {
    final url = Uri.parse('$devServerUrl/nordigen-add-requisition');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'requisition_id': requisitionId,
        'bank_id': bankId,
        'bank_name': bankName,
        'email': email,
      }),
    );

    logger.d('📡 Server response:');
    logger.d('  - Status Code: ${response.statusCode}');
    logger.d('  - Response Body: ${response.body}');

    return response.statusCode == 200;
  }
}
