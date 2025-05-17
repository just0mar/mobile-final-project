import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<Map<String, String>> get _headers async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<Map<String, String>> getAuthHeaders(String token) async {
    final headers = await _headers;
    headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? customHeaders}) async {
    try {
      final headers = await _headers;
      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }
      
      final response = await _client.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('GET request failed: $e');
    }
  }

  Future<dynamic> post(String endpoint, dynamic data, {Map<String, String>? customHeaders}) async {
    try {
      final headers = await _headers;
      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }

      final response = await _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('POST request failed: $e');
    }
  }

  Future<dynamic> put(String endpoint, dynamic data, {Map<String, String>? customHeaders}) async {
    try {
      final headers = await _headers;
      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }

      final response = await _client.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('PUT request failed: $e');
    }
  }

  Future<dynamic> delete(String endpoint, {Map<String, String>? customHeaders}) async {
    try {
      final headers = await _headers;
      if (customHeaders != null) {
        headers.addAll(customHeaders);
      }

      final response = await _client.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('DELETE request failed: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw ApiException(
        'Request failed with status: ${response.statusCode}\nBody: ${response.body}',
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
} 