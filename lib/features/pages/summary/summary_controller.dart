import 'package:get/get.dart';
import 'package:juan_by_juan/core/data/bill_calculator.dart';
import 'package:juan_by_juan/core/models/item_model.dart';
import 'package:juan_by_juan/core/models/person_model.dart';

/// controller for summary screen
/// manages leaderboard display and person detail modal
class SummaryController extends GetxController {
  // data from previous screen
  late List<ItemModel> items;
  late List<PersonModel> people;
  late Map<int, List<int>> selectedPeoplePerItem;

  // total bill amount in centavos
  late int totalBill;

  @override
  void onInit() {
    super.onInit();

    // get data from previous screen
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    items = args['items'] as List<ItemModel>? ?? [];
    people = args['people'] as List<PersonModel>? ?? [];
    selectedPeoplePerItem =
        args['selectedPeoplePerItem'] as Map<int, List<int>>? ?? {};

    // calculate total bill
    totalBill = BillCalculator.calculateTotalBill(items);

    // sort people by total amount (highest to lowest)
    people.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
  }

  /// get items that a person is paying for
  List<ItemModel> getPersonItems(int personIndex) {
    final personItems = <ItemModel>[];

    selectedPeoplePerItem.forEach((itemIndex, selectedPeople) {
      if (selectedPeople.contains(personIndex)) {
        personItems.add(items[itemIndex]);
      }
    });

    return personItems;
  }

  /// get percentage of total bill for a person
  double getPersonPercentage(PersonModel person) {
    return BillCalculator.calculatePercentage(person.totalAmount, totalBill);
  }

  /// navigate back to items screen. start new bill
  void startNewBill() {
    // go back to items screen and clear navigation stack
    Get.until((route) => route.settings.name == '/items');
  }
}
