import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final _secureStorage = const FlutterSecureStorage();
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final String _token = dotenv.env['API_TOKEN']!;

  // ✅ Save token securely
  Future<void> setToken(String token) async {
    await _secureStorage.write(key: _token, value: token);
  }

  // 🔍 (Optional) Retrieve token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _token);
  }

  // Unified error-handling wrapper that returns full response
  Future<http.Response> _handleRequest(
      Future<http.Response> Function() request) async {
    try {
      final response = await request();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        throw Exception(
            '[HTTP] ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('[HTTP] Request failed: $e');
    }
  }

  // GET
  Future<http.Response> get(String endpoint, {Map<String, String>? headers}) {
    return _handleRequest(() => http.get(
          Uri.parse('$baseUrl/$endpoint'),
          headers: headers,
        ));
  }

  // POST
  Future<http.Response> post(String endpoint,
      {Map<String, String>? headers, Object? body}) {
    return _handleRequest(() => http.post(
          Uri.parse('$baseUrl/$endpoint'),
          headers: headers,
          body: body,
        ));
  }

  // PUT
  Future<http.Response> put(String endpoint,
      {Map<String, String>? headers, Object? body}) {
    return _handleRequest(() => http.put(
          Uri.parse('$baseUrl/$endpoint'),
          headers: headers,
          body: body,
        ));
  }

  // DELETE
  Future<http.Response> delete(String endpoint,
      {Map<String, String>? headers}) {
    return _handleRequest(() => http.delete(
          Uri.parse('$baseUrl/$endpoint'),
          headers: headers,
        ));
  }
}
