import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  // Change this to your machine's IP when testing on a real Android device
  static const String _baseUrl = 'http://10.0.2.2:8080/api';

  static Future<RecommendationResult> recommend({
    required double targetCapacity,
    required int bolts,
    required int rows,
  }) async {
    final uri = Uri.parse('$_baseUrl/recommend');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'targetCapacity': targetCapacity,
        'bolts': bolts,
        'rows': rows,
      }),
    );

    if (response.statusCode == 200) {
      return RecommendationResult.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('No matching section found. Try different parameters.');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
