import 'package:get/get.dart';
import 'package:juan_by_juan/core/data/database_helper.dart';

/// initial app-level bindings
/// sets up dependencies that are available all throughout the app lifecycle

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // global dependencies
    // register db helper as a singleton
    // fenix: true menas it will be recreated if disposed
    Get.lazyPut(() => DatabaseHelper(), fenix: true);
  }
}
