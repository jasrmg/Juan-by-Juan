import 'package:get/get.dart';
import 'package:juan_by_juan/features/pages/splash/splash_controller.dart';

/// binding for splash screen
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}
