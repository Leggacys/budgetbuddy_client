// HTTP service for API calls
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class ApiService {
  static const String _devUrl = AppConstants.devServerUrl;

  // Use dev URL for development, can switch to production later
  static String get baseUrl => _devUrl;

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> _headersWithAuth(String token) => {
    ..._headers,
    'Authorization': 'Bearer $token',
  };

  // GET request
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

  // POST request
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

  // PUT request
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

  // DELETE request
  static Future<http.Response> delete(String endpoint, {String? token}) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    final response = await http.delete(
      uri,
      headers: token != null ? _headersWithAuth(token) : _headers,
    );

    return response;
  }

  // Handle API response
  static Map<String, dynamic> handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
