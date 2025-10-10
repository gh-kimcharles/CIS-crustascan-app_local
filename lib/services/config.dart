class AppConfig {
  // Pull value from --dart-define or fallback to localhost
  static const String apiBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://127.0.0.1:5000',
  );

  // Helper method to check if using local development
  static bool get isLocalDevelopment =>
      apiBaseUrl.contains('localhost') ||
      apiBaseUrl.contains('127.0.0.1') ||
      apiBaseUrl.contains('10.0.2.2');

  // Helper method to get base URL without trailing slash
  static String get baseUrl => apiBaseUrl.endsWith('/')
      ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
      : apiBaseUrl;
}
