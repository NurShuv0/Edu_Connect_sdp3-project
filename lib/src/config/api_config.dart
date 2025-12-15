class ApiConfig {
  // Use --dart-define=API_BASE_URL=<url> to override in build/run
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000',
  );
}
