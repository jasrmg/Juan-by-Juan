import 'package:get/get.dart';
import 'package:juan_by_juan/features/pages/summary/summary_controller.dart';

/// binding for summary screen sets up dependencies for summary page
class SummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SummaryController());
  }
}
