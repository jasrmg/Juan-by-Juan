import 'package:flutter_dotenv/flutter_dotenv.dart';

/// app flavor config
/// manage env specific settings (UAT, QAT, PROD)
enum Flavor { uat, qat, prod }

/// flavor config manager
/// loads and provides access to env variables
class FlavorConfig {
  final Flavor flavor;
  final String appName;

  FlavorConfig._({required this.flavor, required this.appName});

  static FlavorConfig? _instance;

  // get the current flavor config
  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception('FlavorConfig not initialized');
    }
    return _instance!;
  }

  /// check if instance is initialized
  static bool get isInitialized => _instance != null;

  /// initialize flavor config by loading the appropriate .env file
  static Future<void> initialize(Flavor flavor) async {
    // load correct .env file based on flavor
    String envFile;
    switch (flavor) {
      case Flavor.uat:
        envFile = 'assets/environments/.env.uat';
        break;
      case Flavor.qat:
        envFile = 'assets/environments/.env.qat';
        break;
      case Flavor.prod:
        envFile = 'assets/environments/.env.prod';
        break;
    }

    // load environment var from file
    await dotenv.load(fileName: envFile);

    // create flavor config instance
    _instance = FlavorConfig._(
      flavor: flavor,
      appName: dotenv.env['APP_NAME'] ?? 'Juan-by-Juan',
    );
  }

  // check if current flavor is production
  bool get isProduction => flavor == Flavor.prod;
  // flavor = uat
  bool get isUAT => flavor == Flavor.uat;
  // flavor = qat
  bool get isQAT => flavor == Flavor.qat;
  // get flavor name as str
  String get flavorName => flavor.name.toUpperCase();
}
