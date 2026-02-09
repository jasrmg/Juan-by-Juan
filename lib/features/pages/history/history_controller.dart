import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/core/data/database_helper.dart';
import 'package:juan_by_juan/core/error/error_handler.dart';
import 'package:juan_by_juan/core/models/bill_model.dart';

/// controller for history screen
/// manages loading and displaying saved bills with pagination
class HistoryController extends GetxController {
  // all bills
  final allBills = <BillModel>[];

  // displayed bills (paginated)
  final bills = <BillModel>[].obs;

  // pagination
  final currentPage = 0.obs;
  final billsPerPage = 10;

  // loading state
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

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

      allBills.clear();
      allBills.addAll(billMaps.map((map) => BillModel.fromMap(map)).toList());

      // sort: pinned bills first then by date
      allBills.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });

      // load first page
      _loadPage(0);
    } catch (e) {
      ErrorHandler.handle(e, fallbackMessage: 'Failed to load bills');
    } finally {
      isLoading.value = false;
    }
  }

  /// load specific page
  void _loadPage(int page) {
    final startIndex = page * billsPerPage;
    final endIndex = (startIndex + billsPerPage).clamp(0, allBills.length);

    if (page == 0) {
      bills.value = allBills.sublist(startIndex, endIndex);
    } else {
      bills.addAll(allBills.sublist(startIndex, endIndex));
    }

    currentPage.value = page;
  }

  /// load next page
  void loadNextPage() {
    if (isLoadingMore.value) return;

    final nextPage = currentPage.value + 1;
    final startIndex = nextPage * billsPerPage;

    // check if there are more bills
    if (startIndex >= allBills.length) return;

    isLoadingMore.value = true;

    // simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _loadPage(nextPage);
      isLoadingMore.value = false;
    });
  }

  /// check if there are more bills to load
  bool get hasMoreBills {
    return (currentPage.value + 1) * billsPerPage < allBills.length;
  }

  /// delete a bill
  Future<void> deleteBill(int billId, String billName) async {
    try {
      final db = DatabaseHelper();
      await db.deleteBill(billId);

      // remove from both lists
      allBills.removeWhere((bill) => bill.id == billId);
      bills.removeWhere((bill) => bill.id == billId);

      Get.snackbar(
        'Bill Deleted',
        '"$billName" has been deleted',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      ErrorHandler.handle(e, fallbackMessage: 'Failed to delete bill');
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

      // update in both lists
      final allIndex = allBills.indexWhere((b) => b.id == bill.id);
      if (allIndex != -1) {
        allBills[allIndex] = bill.copyWith(isPinned: newPinStatus);
      }

      final index = bills.indexWhere((b) => b.id == bill.id);
      if (index != -1) {
        bills[index] = bill.copyWith(isPinned: newPinStatus);
      }

      // sort both lists: pinned bills first
      allBills.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });

      bills.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });

      Get.snackbar(
        newPinStatus ? 'Bill Pinned' : 'Bill Unpinned',
        '"${bill.name}"',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade900,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      ErrorHandler.handle(e, fallbackMessage: 'Could not update pin status');
    }
  }
}
