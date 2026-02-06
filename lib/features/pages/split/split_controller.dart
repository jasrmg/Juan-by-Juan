import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/core/models/item_model.dart';
import 'package:juan_by_juan/core/models/person_model.dart';

/// controller for split assignment screen, manages item by item split selection
class SplitController extends GetxController {
  // data from previous screens
  late List<ItemModel> items;
  late List<PersonModel> people;

  // current item index being split
  final currentItemIndex = 0.obs;

  // map of item index to selected person indices
  // ex. {0: [0, 2], 1: [1]} - item 0 is shared between person 0 and 2
  final selectedPeoplePerItem = <int, List<int>>{}.obs;

  // loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // get data from previous screen
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    items = args['items'] as List<ItemModel>? ?? [];
    people = args['people'] as List<PersonModel>? ?? [];
    final savedSelections =
        args['savedSelections'] as Map<int, List<int>>? ?? {};
    final peopleCountChanged = args['peopleCountChanged'] as bool? ?? false;

    // restore saved selections
    if (savedSelections.isNotEmpty) {
      selectedPeoplePerItem.value = Map.from(savedSelections);

      // if people count changed, start at item 1 to review all items
      // otherwise jump to first unsplit item
      if (peopleCountChanged) {
        currentItemIndex.value = 0;
      } else {
        // jump to first unsplit item
        for (int i = 0; i < items.length; i++) {
          if (!selectedPeoplePerItem.containsKey(i) ||
              selectedPeoplePerItem[i]!.isEmpty) {
            currentItemIndex.value = i;
            break;
          }
        }
      }
    }

    // validate data
    if (items.isEmpty || people.isEmpty) {
      Get.snackbar(
        'Error',
        'Missing items or people data',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      Get.back();
      return;
    }
  }

  /// get current item being split
  ItemModel get currentItem => items[currentItemIndex.value];

  /// check if a person is selected for current item
  bool isPersonSelected(int personIndex) {
    return selectedPeoplePerItem[currentItemIndex.value]?.contains(
          personIndex,
        ) ??
        false;
  }

  /// toggle person selection for current item
  void togglePersonSelection(int personIndex) {
    final currentSelections =
        selectedPeoplePerItem[currentItemIndex.value] ?? [];

    if (currentSelections.contains(personIndex)) {
      // remove person
      currentSelections.remove(personIndex);
    } else {
      // add person
      currentSelections.add(personIndex);
    }

    selectedPeoplePerItem[currentItemIndex.value] = currentSelections;
    selectedPeoplePerItem.refresh();
  }

  /// check if current item has at least one person selected
  bool get hasSelection {
    final selections = selectedPeoplePerItem[currentItemIndex.value] ?? [];
    return selections.isNotEmpty;
  }

  /// go to next item or calculate if last item
  void goToNextItem() {
    if (!hasSelection) {
      Get.snackbar(
        'No Selection',
        'Please select at least one person for this item',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return;
    }

    if (currentItemIndex.value < items.length - 1) {
      // move to next item
      currentItemIndex.value++;
    } else {
      // last item - go to calculation
      calculateAndNavigate();
    }
  }

  /// go to previous item
  void goToPreviousItem() {
    if (currentItemIndex.value > 0) {
      currentItemIndex.value--;
    }
  }

  /// calculate splits and navigate to summary
  void calculateAndNavigate() {
    // todo
  }

  /// go back to people screen
  void goBack() {
    Get.back(result: {'savedSelections': selectedPeoplePerItem});
  }
}
