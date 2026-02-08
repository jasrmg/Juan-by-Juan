import 'package:get/get.dart';
import 'package:juan_by_juan/core/configurations/routes.dart';
import 'package:juan_by_juan/core/data/database_helper.dart';
import 'package:juan_by_juan/core/models/bill_model.dart';

/// controller for home screen manages nav and display recent bills
class HomeController extends GetxController {
  // recent bills (max 3)
  final recentBills = <BillModel>[].obs;

  // loading state
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentBills();
  }

  /// load 3 most recent bills
  Future<void> loadRecentBills() async {
    try {
      final db = DatabaseHelper();
      final billMaps = await db.getAllBills();

      // take 3 bills only
      final bills = billMaps.map((map) => BillModel.fromMap(map)).toList();
      recentBills.value = bills.take(3).toList();
    } catch (e) {
      //
    } finally {
      isLoading.value = false;
    }
  }

  /// navigate to new bill flow
  void startNewBill() {
    Get.toNamed(AppRoutes.items);
  }

  /// navigate to bill history
  void goToHistory() {
    Get.toNamed(AppRoutes.history);
  }

  /// open a bill detail
  void openBill(BillModel bill) {
    Get.toNamed(AppRoutes.billDetail, arguments: bill);
  }
}
