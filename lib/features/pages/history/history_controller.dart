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

      // sort: pinned bills first then by date
      bills.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });
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
    Get.toNamed('/bill-detail', arguments: bill);
  }

  /// toggle pin status for a bill
  Future<void> togglePin(BillModel bill) async {
    try {
      final db = DatabaseHelper();
      final newPinStatus = !bill.isPinned;

      await db.updateBillPinStatus(bill.id!, newPinStatus);

      // update in list
      final index = bills.indexWhere((b) => b.id == bill.id);
      if (index != -1) {
        bills[index] = bill.copyWith(isPinned: newPinStatus);

        // sort: pinned bills first
        bills.sort((a, b) {
          if (a.isPinned && !b.isPinned) return -1;
          if (!a.isPinned && b.isPinned) return 1;
          return b.createdAt.compareTo(a.createdAt);
        });
      }

      Get.snackbar(
        newPinStatus ? 'Bill Pinned' : 'Bill Unpinned',
        '"${bill.name}"',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade900,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Failed',
        'Could not update pin status',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }
}
