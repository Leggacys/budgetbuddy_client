import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: 'refresh_token');
  }

  Future<void> saveTokenExpiry(DateTime expiry) async {
    await _storage.write(key: "token_expiry", value: expiry.toIso8601String());
  }

  Future<DateTime?> getTokenExpiry() async {
    final expiryString = await _storage.read(key: "token_expiry");
    if (expiryString != null) {
      return DateTime.parse(expiryString);
    }
    return null;
  }
}
