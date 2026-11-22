/// Configuration de l'API.
/// Change UNIQUEMENT [baseUrl] selon l'endroit où tu lances l'app (voir étape 2.3).
class ApiConfig {
  // Émulateur Android : 10.0.2.2 = le "localhost" de ton PC
  // Téléphone réel   : remplace par l'IP de ton PC, ex. http://192.168.1.15/api-test/public
  // Windows desktop  : http://localhost/api-test/public
  static const String baseUrl = 'http://127.0.0.1/api-test/public';

  /// Temps maximum d'attente d'une réponse.
  static const Duration timeout = Duration(seconds: 15);
}
