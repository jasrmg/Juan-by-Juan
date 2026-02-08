import 'package:get/get.dart';
import 'package:juan_by_juan/features/pages/bill_detail/bill_detail_controller.dart';

/// binding for bill detail screen
class BillDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BillDetailController());
  }
}
