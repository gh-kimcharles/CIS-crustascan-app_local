import 'dart:convert';
import 'package:crustascan_app/providers/user_provider.dart';
import 'package:crustascan_app/services/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_model.dart';

class HistoryProvider with ChangeNotifier {
  List<History> _historyList = [];

  List<History> get historyList => _historyList;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  Future<void> addHistory(BuildContext context, History history) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final imagePath = history.imagePath;

      // Convert confidence string to double before sending
      String confStr = history.confidence.replaceAll('%', '').trim();
      double confidenceValue = double.parse(confStr);

      final uri = Uri.parse('${AppConfig.apiBaseUrl}/history');
      final headers = await _getAuthHeaders();

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode({
          'date': history.date.toIso8601String(),
          'imagePath': imagePath,
          'name': history.name,
          'confidence': confidenceValue,
          'speciesId': history.speciesId,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          final serverHistory = data['history'];

          final updatedHistory = History(
            id: serverHistory['id'],
            date: DateTime.parse(serverHistory['date']),
            imagePath: serverHistory['imagePath'],
            name: serverHistory['name'],
            confidence: "${serverHistory['confidence']}%",
            speciesId: serverHistory['speciesId'],
          );

          _historyList.add(updatedHistory);
          userProvider.user.history = _historyList;

          debugPrint('Added new history entry');
          notifyListeners();
        }
      } else {
        debugPrint('Error adding history: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error adding history: $e');
    }
  }

  /// Remove a history entry and sync with backend
  Future<void> removeHistory(BuildContext context, History history) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}/history/${history.id}');
      final headers = await _getAuthHeaders();

      final response = await http.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        // Remove locally
        _historyList.removeWhere((h) => h.id == history.id);
        userProvider.user.history = _historyList;

        debugPrint('History entry removed');
        notifyListeners();
      } else {
        debugPrint('Error deleting history: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error deleting history: $e');
    }
  }

  /// Clear all history records
  Future<void> clearHistory(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}/history/clear');
      final headers = await _getAuthHeaders();

      final response = await http.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        // Clear local list
        _historyList.clear();
        userProvider.user.history = [];

        debugPrint('History cleared successfully');
        notifyListeners();
      } else {
        debugPrint('Error clearing history: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error clearing history: $e');
    }
  }

  /// Initialize history when logging in or loading from backend
  void initializeHistory(List<History> newHistory) {
    _historyList = newHistory;
    notifyListeners();
  }

  /// Fetch history from backend (e.g., after login)
  Future<void> fetchHistoryFromBackend() async {
    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}/history');
      final headers = await _getAuthHeaders();

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          final historyData = data['history'] as List<dynamic>?;

          if (historyData != null) {
            _historyList = historyData
                .map((item) => History.fromMap(item as Map<String, dynamic>))
                .toList();

            debugPrint(
              'History downloaded from backend (${_historyList.length} items)',
            );
            notifyListeners();
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching history: $e');
    }
  }
}
