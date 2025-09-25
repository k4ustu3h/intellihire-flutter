import "dart:convert";

import "package:http/http.dart" as http;

class ApiService {
  static const _baseUrl = "https://intellihire-backend.vercel.app";

  static Future<List<Map<String, dynamic>>> fetchJobs() async {
    final uri = Uri.parse("$_baseUrl/api/jobs");
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List;
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to fetch jobs: ${res.statusCode}");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchTests() async {
    final uri = Uri.parse("$_baseUrl/api/tests");
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List;
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Failed to fetch tests: ${res.statusCode}");
    }
  }
}
