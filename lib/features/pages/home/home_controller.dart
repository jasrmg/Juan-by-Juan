import 'package:get/get.dart';
import 'package:juan_by_juan/core/configurations/routes.dart';
import 'package:juan_by_juan/core/data/database_helper.dart';
import 'package:juan_by_juan/core/models/bill_model.dart';

/// controller for home screen
/// manages navigation and displays recent bills with pagination
class HomeController extends GetxController {
  // all bills
  final allBills = <BillModel>[];

  // displayed bills (paginated)
  final displayedBills = <BillModel>[].obs;

  // pagination
  final currentPage = 0.obs;
  final billsPerPage = 5;

  // loading state
  final isLoading = true.obs;
  final isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBills();
  }

  /// load all bills from database
  Future<void> loadBills() async {
    try {
      final db = DatabaseHelper();
      final billMaps = await db.getAllBills();

      allBills.clear();
      allBills.addAll(billMaps.map((map) => BillModel.fromMap(map)).toList());

      // load first page
      _loadPage(0);
    } catch (e) {
      // silently fail, show empty state
    } finally {
      isLoading.value = false;
    }
  }

  /// load specific page
  void _loadPage(int page) {
    final startIndex = page * billsPerPage;
    final endIndex = (startIndex + billsPerPage).clamp(0, allBills.length);

    if (page == 0) {
      displayedBills.value = allBills.sublist(startIndex, endIndex);
    } else {
      displayedBills.addAll(allBills.sublist(startIndex, endIndex));
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
