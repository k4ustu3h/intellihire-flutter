import "dart:convert";

import "package:http/http.dart" as http;

class ApiService {
  static const _baseUrl = "https://intellihire-backend.vercel.app";
  static const _timeout = Duration(seconds: 10);

  static Future<List<Map<String, dynamic>>> _getList(String path) async {
    final uri = Uri.parse("$_baseUrl$path");
    http.Response res;

    try {
      res = await http.get(uri).timeout(_timeout);
    } catch (e) {
      throw Exception("Network error while fetching $path: $e");
    }

    if (res.statusCode == 200) {
      try {
        final data = json.decode(res.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        } else {
          throw Exception("Unexpected response format for $path: ${res.body}");
        }
      } catch (e) {
        throw Exception("Failed to parse response for $path: $e");
      }
    } else {
      throw Exception("Failed to fetch $path: ${res.statusCode} - ${res.body}");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchJobs() =>
      _getList("/api/jobs");

  static Future<List<Map<String, dynamic>>> fetchTests() =>
      _getList("/api/tests");

  static Future<List<Map<String, dynamic>>> fetchTestQuestions(String testId) =>
      _getList("/api/tests/$testId");
}
