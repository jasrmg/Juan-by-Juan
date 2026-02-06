import 'package:get/get.dart';

/// centralized route management for the app
/// all nagivation paths are defined for consistency
class AppRoutes {
  // private constructor to prevent instantiation
  AppRoutes._();

  // route paths
  static const String home = '/';
  static const String items = '/items';
  static const String people = '/people';
  static const String split = '/split';
  static const String summary = '/summary';
  static const String history = '/history';
}

/// GetX route config
/// maps rotue names to pages
class AppPages {
  // private constructor to prevent instantiation
  AppPages._();

  static final routes = <GetPage>[
    // routes will be added here
  ];
}
