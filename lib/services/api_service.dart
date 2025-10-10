import 'dart:convert';
import 'dart:typed_data';
import 'config.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> sendImageForPrediction(
    Uint8List originalBytes,
  ) async {
    // Convert original bytes directly to Base64
    final String base64Image = base64Encode(originalBytes);

    // Endpoint that uses --dart-define
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/predict');

    try {
      // Send POST request
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception during prediction: $e');
      rethrow;
    }
  }
}
