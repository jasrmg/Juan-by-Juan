import 'package:get/get.dart';
import 'package:juan_by_juan/core/data/bill_calculator.dart';
import 'package:juan_by_juan/core/models/item_model.dart';
import 'package:juan_by_juan/core/models/person_model.dart';
import 'package:juan_by_juan/core/data/database_helper.dart';
import 'package:juan_by_juan/core/models/bill_model.dart';
import 'package:flutter/material.dart';

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

  /// save bill to db
  Future<void> saveBill(String billName) async {
    try {
      final db = DatabaseHelper();

      // create bill record
      final bill = BillModel(
        name: billName,
        totalAmount: totalBill,
        createdAt: DateTime.now(),
      );

      // insert bill and get id
      final billId = await db.insertBill(bill.toMap());

      // insert items and and store their db ids
      final itemDbIds = <int>[];
      for (var item in items) {
        final itemId = await db.insertItem(item.toMap(billId: billId));
        itemDbIds.add(itemId);
      }

      // insert people and store their db ids
      final peopleDbIds = <int>[];
      for (var person in people) {
        final personId = await db.insertPerson(person.toMap(billId: billId));
        peopleDbIds.add(personId);
      }

      // insert splits using db ids
      for (var entry in selectedPeoplePerItem.entries) {
        final itemIndex = entry.key;
        final personIndices = entry.value;

        for (var personIndex in personIndices) {
          await db.insertSplit({
            'item_id': itemDbIds[itemIndex],
            'person_id': peopleDbIds[personIndex],
            'split_amount': 0,
          });
        }
      }
      Get.snackbar(
        'Bill Saved',
        'Bill "$billName" saved successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } catch (e) {
      Get.snackbar(
        'Save Failed',
        'Failed to save bill. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  /// navigate back to items screen. start new bill
  void startNewBill() {
    // go back to items screen and clear navigation stack
    Get.until((route) => route.settings.name == '/items');
  }
}
