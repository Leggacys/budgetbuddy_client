import 'dart:convert';

import 'package:budgetbuddy_client/core/services/api_service.dart';
import 'package:budgetbuddy_client/core/services/secure_storage_service.dart';

class TokenService {
  static Future<bool> _isTokenValid() async {
    final DateTime? expiry = await SecureStorageService().getTokenExpiry();
    if (expiry == null) {
      return false;
    }
    return expiry.isAfter(DateTime.now());
  }

  static Future<void> _refreshTokenIfNeeded() async {
    final bool isValid = await _isTokenValid();
    if (!isValid) {
      final response = await ApiService.post(
        '/refresh-token',
        body: {'refresh_token': await SecureStorageService().getRefreshToken()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await SecureStorageService().saveToken(data['access_token']);
        await SecureStorageService().saveTokenExpiry(
          DateTime.parse(data['expires_at']),
        );
      } else {
        throw Exception('Failed to refresh token: ${response.statusCode}');
      }
    }
  }

  static Future<String?> getToken() async {
    await _refreshTokenIfNeeded();
    return await SecureStorageService().getToken();
  }
}
