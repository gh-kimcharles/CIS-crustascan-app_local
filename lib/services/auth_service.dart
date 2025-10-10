import 'dart:convert';
import 'dart:io';
import 'package:crustascan_app/services/config.dart';
import 'package:crustascan_app/models/history_model.dart';
import 'package:crustascan_app/providers/history_provider.dart';
import 'package:crustascan_app/providers/user_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:crustascan_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Save token and user data
  Future<void> _saveAuthData(
    String token,
    Map<String, dynamic> userData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  // Get saved token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Clear auth data (logout)
  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Get auth headers with token
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  Future<bool> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String username,
    String? birthday,
    String? gender,
    String? location,
    String? role,
    String? imagePath,
  }) async {
    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}/auth/register');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'birthday': birthday,
          'gender': gender,
          'location': location,
          'role': role,
          'imagePath': imagePath ?? 'assets/images/user/default_profile.png',
        }),
      );

      if (response.statusCode == 201) {
        debugPrint('✅ User registered successfully');
        return true;
      } else {
        final error = jsonDecode(response.body);
        debugPrint('Register Error: ${error['error']}');
        return false;
      }
    } catch (e) {
      debugPrint('AuthService Error: $e');
      return false;
    }
  }

  Future<bool> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}/auth/login');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!data['success']) {
          debugPrint('Login failed: ${data['error']}');
          return false;
        }

        final token = data['token'];
        final userData = data['user'];

        // Save token and user data
        await _saveAuthData(token, userData);

        // Create user model
        final userModel = User(
          imagePath:
              userData['imagePath'] ?? 'assets/images/user/default_profile.png',
          firstName: userData['firstName'] ?? '',
          lastName: userData['lastName'] ?? '',
          birthday: userData['birthday'] ?? '',
          gender: userData['gender'] ?? '',
          location: userData['location'] ?? '',
          role: userData['role'] ?? '',
          email: userData['email'] ?? '',
          username: userData['username'] ?? '',
          favorites: userData['favorites'] != null
              ? List<String>.from(userData['favorites'])
              : [],
          history: (userData['history'] as List<dynamic>? ?? [])
              .map((h) => History.fromMap(h as Map<String, dynamic>))
              .toList(),
        );

        // Update providers
        userProvider.updateUser(context, userModel);
        Provider.of<HistoryProvider>(
          context,
          listen: false,
        ).initializeHistory(userModel.history);

        debugPrint('✅ LOGIN SUCCESS');
        debugPrint('==== Favorites: ${userModel.favorites}');
        debugPrint('==== History: ${userModel.history.length} items');
        return true;
      } else {
        debugPrint('Login error: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}/auth/update-password');
      final headers = await _getAuthHeaders();

      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode({
          'oldPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("Password updated successfully!");
        return true;
      } else {
        final error = jsonDecode(response.body);
        if (error['error'].toString().contains('incorrect')) {
          debugPrint("Old password is incorrect.");
          throw Exception('invalid-credential');
        }
        return false;
      }
    } catch (e) {
      debugPrint("Error updating password: $e");
      rethrow;
    }
  }

  // FIXED: Separate method for updating user profile
  Future<bool> updateUserProfile(User newUser) async {
    debugPrint('====== UPDATE USER PROFILE CALLED ==========');

    try {
      final uri = Uri.parse('${AppConfig.apiBaseUrl}/user/profile');
      final headers = await _getAuthHeaders();

      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode({
          'firstName': newUser.firstName,
          'lastName': newUser.lastName,
          'birthday': newUser.birthday,
          'gender': newUser.gender,
          'location': newUser.location,
          'role': newUser.role,
          'username': newUser.username,
          'email': newUser.email,
          'imagePath': newUser.imagePath,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('User profile updated successfully');
        return true;
      } else {
        debugPrint('Error updating user: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error updating user: $e');
      return false;
    }
  }

  // FIXED: Toggle favorite - calls the correct endpoint
  Future<void> toggleFavorite(String speciesId) async {
    try {
      final uri = Uri.parse(
        '${AppConfig.apiBaseUrl}/user/favorites/$speciesId',
      );

      debugPrint('Full URL: $uri');
      debugPrint('Token: ${(await getToken())?.substring(0, 20)}...');

      final headers = await _getAuthHeaders();

      final response = await http.post(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Favorite toggled: ${data['action']}');
      } else {
        debugPrint('Toggle favorite error: ${response.body}');
        throw Exception('Failed to toggle favorite');
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      rethrow;
    }
  }

  // Keep for backward compatibility but mark as deprecated
  @deprecated
  Future<bool> updateUser(User newUser) async {
    return await updateUserProfile(newUser);
  }

  Future<String> uploadHistoryImage(String imagePath) async {
    try {
      final file = File(imagePath);

      if (!await file.exists()) {
        throw Exception('File does not exist at $imagePath');
      }

      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      // upload to server
      final uri = Uri.parse('${AppConfig.apiBaseUrl}/history/image');
      final headers = await _getAuthHeaders();

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode({'image': 'data:image/jpeg;base64,$base64Image'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['imagePath']; // Returns server URL "/uploads/history_*.jpg"
      } else {
        throw Exception('Upload failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('History image upload failed: $e');
      rethrow;
    }
  }

  Future<String> uploadProfileImage(String imagePath) async {
    try {
      final file = File(imagePath);

      if (!await file.exists()) {
        throw Exception('File does not exist at $imagePath');
      }

      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      final uri = Uri.parse('${AppConfig.apiBaseUrl}/user/profile/image');
      final headers = await _getAuthHeaders();

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode({'image': 'data:image/jpeg;base64,$base64Image'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['imagePath'];
      } else {
        throw Exception('Upload failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('Profile image upload failed: $e');
      rethrow;
    }
  }

  // FIXED: Simplified uploadHistory - just sends the new item
  Future<void> uploadHistory(List<History> newHistory) async {
    try {
      final headers = await _getAuthHeaders();

      if (newHistory.isNotEmpty) {
        final latestHistory = newHistory.last;

        final response = await http.post(
          Uri.parse('${AppConfig.apiBaseUrl}/history'),
          headers: headers,
          body: jsonEncode({
            'date': latestHistory.date.toIso8601String(),
            'imagePath': latestHistory.imagePath,
            'name': latestHistory.name,
            'confidence': latestHistory.confidence,
            'speciesId': latestHistory.speciesId,
          }),
        );

        if (response.statusCode == 201) {
          debugPrint('History uploaded successfully');
        } else {
          debugPrint('Error uploading history: ${response.body}');
        }
      }
    } catch (e) {
      debugPrint('Error uploading history: $e');
    }
  }

  Future<List<History>> downloadHistory() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/history'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!data['success']) {
          return [];
        }

        final historyData = data['history'] as List<dynamic>?;

        if (historyData == null) return [];

        return historyData
            .map((item) => History.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching history: $e');
      return [];
    }
  }

  // Auto-login from saved token
  Future<bool> tryAutoLogin(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final userDataStr = prefs.getString(_userKey);

      if (token == null || userDataStr == null) {
        return false;
      }

      // Verify token is still valid by fetching fresh user data
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!data['success']) {
          await clearAuthData();
          return false;
        }

        final userData = data['user'];

        // Create user model
        final userModel = User(
          imagePath:
              userData['imagePath'] ?? 'assets/images/user/default_profile.png',
          firstName: userData['firstName'] ?? '',
          lastName: userData['lastName'] ?? '',
          birthday: userData['birthday'] ?? '',
          gender: userData['gender'] ?? '',
          location: userData['location'] ?? '',
          role: userData['role'] ?? '',
          email: userData['email'] ?? '',
          username: userData['username'] ?? '',
          favorites: userData['favorites'] != null
              ? List<String>.from(userData['favorites'])
              : [],
          history: (userData['history'] as List<dynamic>? ?? [])
              .map((h) => History.fromMap(h as Map<String, dynamic>))
              .toList(),
        );

        // Update providers
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).updateUser(context, userModel);
        Provider.of<HistoryProvider>(
          context,
          listen: false,
        ).initializeHistory(userModel.history);

        debugPrint('✅ Auto-login successful');
        return true;
      } else {
        // Token expired or invalid
        await clearAuthData();
        return false;
      }
    } catch (e) {
      debugPrint('Auto-login error: $e');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await clearAuthData();
  }
}
