import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import 'api_client.dart';

/// Inscription, connexion et déconnexion via l'API (table `account`).
class AuthService {
  static const _keyId = 'user_id';
  static const _keyEmail = 'user_email';

  static Future<Map<String, dynamic>> _send(
      String path, String email, String password) {
    return callApi(() => http.post(
          Uri.parse('${ApiConfig.baseUrl}$path'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        ));
  }

  /// Crée un compte dans la base de données.
  static Future<void> register(String email, String password) async {
    await _send('/accounts/register', email, password);
  }

  /// Vérifie l'email et le mot de passe auprès de l'API,
  /// puis mémorise l'utilisateur sur le téléphone.
  static Future<String> login(String email, String password) async {
    final body = await _send('/accounts/login', email, password);
    final data = body['data'] as Map<String, dynamic>;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyId, int.parse(data['id'].toString()));
    await prefs.setString(_keyEmail, data['email'].toString());
    return data['email'].toString();
  }

  /// Email de l'utilisateur connecté, ou null s'il n'y a personne.
  static Future<String?> currentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyId);
    await prefs.remove(_keyEmail);
  }
}
