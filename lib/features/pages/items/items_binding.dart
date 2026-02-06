import 'package:get/get.dart';
import 'package:juan_by_juan/features/pages/items/items_controller.dart';

/// binding for items page
/// initialize itemcontroller when page is accessed
class ItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ItemsController());
  }
}
