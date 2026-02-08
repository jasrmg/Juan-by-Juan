import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/core/data/database_helper.dart';
import 'package:juan_by_juan/core/models/bill_model.dart';

/// controller for history screen
/// manages loading and displaying saved bills
class HistoryController extends GetxController {
  // observable list of bills
  final bills = <BillModel>[].obs;

  // loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBills();
  }

  /// load all bills from database
  Future<void> loadBills() async {
    isLoading.value = true;

    try {
      final db = DatabaseHelper();
      final billMaps = await db.getAllBills();

      bills.value = billMaps.map((map) => BillModel.fromMap(map)).toList();
    } catch (e) {
      Get.snackbar(
        'Load Failed',
        'Failed to load bills',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// delete a bill
  Future<void> deleteBill(int billId, String billName) async {
    try {
      final db = DatabaseHelper();
      await db.deleteBill(billId);

      // remove from list
      bills.removeWhere((bill) => bill.id == billId);

      Get.snackbar(
        'Bill Deleted',
        '"$billName" has been deleted',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Delete Failed',
        'Failed to delete bill',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  /// open a saved bill (view-only)
  void openBill(BillModel bill) {
    // open bill functionalities...
  }
}
