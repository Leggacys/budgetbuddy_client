import 'dart:convert';
import 'package:budgetbuddy_client/core/constants/constants.dart';
import 'package:budgetbuddy_client/core/services/secure_storage_service.dart';
import 'package:budgetbuddy_client/core/services/user_preferences.dart';
import 'package:budgetbuddy_client/features/banking/data/bank_data_source.dart';
import 'package:budgetbuddy_client/core/services/api_service.dart';

class NordingenService {
  static Future<String> createRequisition(String bankId) async {
    final email = await UserPreferences.getEmail();
    final token = await SecureStorageService().getToken();

    final response = await ApiService.post(
      '/nordingen-create-requisition',
      token: token,
      body: {'institution_id': bankId, 'email': email},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);

      if (data['link'] == null) {
        throw Exception('Server response missing redirect_url field');
      }
      if (data['requisition_id'] == null) {
        throw Exception('Server response missing requisition_id field');
      }

      await UserPreferences.saveRequisitionId(data['requisition_id']);
      final redirectUrl = data['link'] as String;
      if (!redirectUrl.startsWith('http://') &&
          !redirectUrl.startsWith('https://')) {
        throw Exception('Invalid redirect URL format: $redirectUrl');
      }
      return redirectUrl;
    } else {
      throw Exception(
        'Failed to get redirect URL: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<bool> addRequisition({
    required String requisitionId,
    required String bankId,
    required String bankName,
    required String email,
  }) async {
    final response = await ApiService.post(
      '/nordigen-add-requisition',
      body: {
        'requisition_id': requisitionId,
        'bank_id': bankId,
        'bank_name': bankName,
        'email': email,
      },
    );
    return response.statusCode == 200;
  }

  static Future<List<Bank>> getBanksList(String countryCode) async {
    final token = await SecureStorageService().getToken();

    final response = await ApiService.get(
      '/nordingen-list-of-banks-from-country',
      queryParams: {'country_code': countryCode},
      token: token,
    );

    if (response.statusCode == 200) {
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

  static Future<String> getRedirectUrl(String bankId) async {
    final email = await UserPreferences.getEmail();
    final token = await SecureStorageService().getToken();

    final response = await ApiService.get(
      "/nordigen-redirect-url",
      queryParams: {'bank_id': bankId, 'email': ?email},
      token: token,
    );

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

  static Future<Map<String, dynamic>> getTransactions() async {
    final email = await UserPreferences.getEmail();
    final token = await SecureStorageService().getToken();

    final response = await ApiService.get(
      "/nordingen-get-transactions",
      queryParams: {'email': ?email},
      token: token,
    );

    if (response.statusCode == 200) {
      logger.d('✅ Transactions retrieved successfully: ${response.body}');
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
        'Failed to get transactions: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
