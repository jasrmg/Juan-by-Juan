import 'package:get/get.dart';
import 'package:juan_by_juan/core/configurations/routes.dart';

/// controller for splash screen
/// handles animation and navigation to home
class SplashController extends GetxController {
  // animation opacity
  final opacity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
  }

  /// start fade-in animation then navigate to home
  Future<void> _startAnimation() async {
    // wait a bit before starting animation
    await Future.delayed(const Duration(milliseconds: 500));

    // fade in
    opacity.value = 1.0;

    // wait 2 seconds then navigate to home
    await Future.delayed(const Duration(milliseconds: 2000));

    // navigate to home and remove splash from stack
    Get.offAllNamed(AppRoutes.home);
  }
}
