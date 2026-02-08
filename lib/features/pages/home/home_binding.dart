import 'package:get/get.dart';
import 'package:juan_by_juan/features/pages/home/home_controller.dart';

/// binding for home screen
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
