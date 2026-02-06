import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/core/configurations/routes.dart';
import 'package:juan_by_juan/core/models/item_model.dart';
import 'package:juan_by_juan/core/models/person_model.dart';

/// controller for items screen
/// manages item list, validation and navigation
class ItemsController extends GetxController {
  // form key validation
  final formKey = GlobalKey<FormState>();

  // text controllers f or input fields
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  // observable list of items
  final items = <ItemModel>[].obs;

  // loading state
  final isLoading = false.obs;

  // people list to preserve when navigating back and forth
  List<PersonModel> savedPeople = [];

  // validate and add item to list
  Future<void> addItem() async {
    // validate form
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoading.value = true;

    try {
      // parse price input (user enters decimal, store as centavos)
      final priceInput = double.tryParse(priceController.text.trim());

      if (priceInput == null || priceInput <= 0) {
        Get.snackbar(
          'Invalid Price',
          'Please enter a valid price greater than zero',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        isLoading.value = false;
        return;
      }

      // convert to centavos (10.50 -> 1050)
      final priceInCentavos = (priceInput * 100).round();

      // create item
      final item = ItemModel(
        name: nameController.text.trim(),
        price: priceInCentavos,
      );

      // add to list
      items.add(item);

      // clear inputs
      nameController.clear();
      priceController.clear();

      // show success message
      Get.snackbar(
        'Item Added',
        '${item.name} - ${item.formattedPrice}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// remove item from list
  void removeItem(int index) {
    items.removeAt(index);
    Get.snackbar(
      'Item Removed',
      'Item has been removed',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  /// navigate to people screen
  void goToNextScreen() async {
    if (items.isEmpty) {
      Get.snackbar(
        'No Items',
        'Please add ad least one item before continuing',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return;
    }
    // navigate to people screen with items as arguments
    final result = await Get.toNamed(
      AppRoutes.people,
      arguments: {'items': items.toList(), 'people': savedPeople},
    );

    // save people data when coming back
    if (result != null && result is Map<String, dynamic>) {
      savedPeople = result['people'] as List<PersonModel>? ?? [];
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
