import 'package:get/get.dart';
import 'package:juan_by_juan/features/pages/history/history_controller.dart';

/// binding for history screen sets up dep for history page
class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HistoryController());
  }
}
