import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

/// Erreur renvoyée par l'API (ou problème de connexion).
class ApiException implements Exception {
  final String message;

  /// Erreurs par champ (ex. {"nom": "Le champ nom est obligatoire"}).
  final Map<String, String> errors;

  ApiException(this.message, [this.errors = const {}]);

  @override
  String toString() =>
      errors.isEmpty ? message : '$message\n${errors.values.join('\n')}';
}

/// Lance une requête, gère le délai d'attente et décode la réponse JSON.
Future<Map<String, dynamic>> callApi(
    Future<http.Response> Function() request) async {
  final http.Response res;
  try {
    res = await request().timeout(ApiConfig.timeout);
  } on TimeoutException {
    throw ApiException(
        'Le serveur ne répond pas. Vérifie que XAMPP (Apache et MySQL) est démarré.');
  } catch (_) {
    throw ApiException(
        "Impossible de joindre l'API. Vérifie l'adresse dans api_config.dart.");
  }

  Map<String, dynamic> body;
  try {
    body = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
  } catch (_) {
    throw ApiException('Réponse invalide du serveur (code ${res.statusCode}).');
  }

  final ok = res.statusCode >= 200 && res.statusCode < 300;
  if (ok && body['success'] == true) return body;

  final errors = <String, String>{};
  final raw = body['errors'];
  if (raw is Map) {
    raw.forEach((key, value) => errors[key.toString()] = value.toString());
  }
  throw ApiException(
      body['message']?.toString() ?? 'Erreur ${res.statusCode}', errors);
}
