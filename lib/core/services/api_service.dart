// HTTP service for API calls
import 'dart:convert';
import 'package:budgetbuddy_client/core/constants/constants.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _devUrl = devServerUrl;

  static String get baseUrl => _devUrl;

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> _headersWithAuth(String token) => {
    ..._headers,
    'Authorization': 'Bearer $token',
  };

  static Future<http.Response> get(
    String endpoint, {
    String? token,
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final uriWithQuery = queryParams != null
        ? uri.replace(queryParameters: queryParams)
        : uri;

    final response = await http.get(
      uriWithQuery,
      headers: token != null ? _headersWithAuth(token) : _headers,
    );

    return response;
  }

  static Future<http.Response> post(
    String endpoint, {
    String? token,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    final response = await http.post(
      uri,
      headers: token != null ? _headersWithAuth(token) : _headers,
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  static Future<http.Response> put(
    String endpoint, {
    String? token,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    final response = await http.put(
      uri,
      headers: token != null ? _headersWithAuth(token) : _headers,
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  static Future<http.Response> delete(String endpoint, {String? token}) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    final response = await http.delete(
      uri,
      headers: token != null ? _headersWithAuth(token) : _headers,
    );

    return response;
  }

  static Map<String, dynamic> handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
