import 'package:get/get.dart';
import 'package:juan_by_juan/features/pages/split/split_controller.dart';

/// binding for split page initializes splitcontroller when page is accessed

class SplitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplitController());
  }
}
