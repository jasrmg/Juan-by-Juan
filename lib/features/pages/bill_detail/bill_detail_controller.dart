import 'package:get/get.dart';
import 'package:juan_by_juan/core/data/database_helper.dart';
import 'package:juan_by_juan/core/models/bill_model.dart';
import 'package:juan_by_juan/core/models/item_model.dart';
import 'package:juan_by_juan/core/models/person_model.dart';

/// controller for bill detail screen - loads and saved bill data
class BillDetailController extends GetxController {
  // bill data
  late BillModel bill;
  final items = <ItemModel>[].obs;
  final people = <PersonModel>[].obs;

  // loading state
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    // get bill from arguments
    bill = Get.arguments as BillModel;
    loadBillDetails();
  }

  /// load bill items and people from database
  Future<void> loadBillDetails() async {
    try {
      final db = DatabaseHelper();

      // load items
      final itemMaps = await db.getItemsForBill(bill.id!);
      items.value = itemMaps.map((map) => ItemModel.fromMap(map)).toList();

      // load people (sorted by total amount)
      final peopleMaps = await db.getPeopleForBill(bill.id!);
      people.value = peopleMaps.map((map) => PersonModel.fromMap(map)).toList();

      people.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
    } catch (e) {
      // show empty list
    } finally {
      isLoading.value = false;
    }
  }

  /// calculate percentage for a person
  double getPersonPercentage(PersonModel person) {
    if (bill.totalAmount == 0) return 0.0;
    return (person.totalAmount / bill.totalAmount) * 100;
  }
}
