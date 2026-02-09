import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/core/configurations/routes.dart';
import 'package:juan_by_juan/core/error/error_handler.dart';
import 'package:juan_by_juan/core/error/exceptions.dart';
import 'package:juan_by_juan/core/models/item_model.dart';
import 'package:juan_by_juan/core/models/person_model.dart';

/// controller for people screen
/// manages people list, validation and navigation
class PeopleController extends GetxController {
  // form key validation
  final formKey = GlobalKey<FormState>();

  // text controller for name input
  final nameController = TextEditingController();

  // observable list of people
  final people = <PersonModel>[].obs;

  // loading state
  final isLoading = false.obs;

  // items passed from previous screen
  late List<ItemModel> items;

  // saved split selections to preserve when navigating back and forth
  Map<int, List<int>> savedSplitSelections = {};

  // track original people count to detect changes
  int originalPeopleCount = 0;

  @override
  void onInit() {
    super.onInit();
    // get data from previous screen
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    // get items from previous screen
    items = args['items'] as List<ItemModel>? ?? [];

    // restore people list if coming back from next screen
    final existingPeople = args['people'] as List<PersonModel>? ?? [];
    if (existingPeople.isNotEmpty) {
      people.addAll(existingPeople);
    }

    // restore split selections if coming back from split screen
    final existingSelections =
        args['savedSelections'] as Map<int, List<int>>? ?? {};

    if (existingSelections.isNotEmpty) {
      savedSplitSelections = existingSelections;
    }

    if (items.isEmpty) {
      Get.snackbar(
        'Error',
        'No items found. Please add items first.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      Get.back();
    }
  }

  /// validate and add person to list
  Future<void> addPerson() async {
    // validate form
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final name = nameController.text.trim();

      // check for duplicate names
      if (people.any((p) => p.name.toLowerCase() == name.toLowerCase())) {
        throw ValidationException('This person has already been added');
      }

      // create person
      final person = PersonModel(name: name);

      // add to list
      people.add(person);
      // clear input
      nameController.clear();
      // show success message
      Get.snackbar(
        'Person Added',
        person.name,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      ErrorHandler.handle(e, fallbackMessage: 'Failed to add person');
    } finally {
      isLoading.value = false;
    }
  }

  /// remove person from list
  void removePerson(int index) {
    final personName = people[index].name;
    people.removeAt(index);
    Get.snackbar(
      'Person Removed',
      '$personName has been removed',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  /// go back to items screen
  void goBack() {
    Get.back(
      result: {
        'people': people.toList(),
        'savedSelections': savedSplitSelections,
      },
    );
  }

  /// navigate to split screen
  void goToNextScreen() async {
    if (people.length < 2) {
      Get.snackbar(
        'Need More People',
        'Please add at least 2 to split the bill',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return;
    }

    // detect if people count changed
    final peopleCountChanged =
        originalPeopleCount != 0 && originalPeopleCount != people.length;

    // update original count for next time
    originalPeopleCount = people.length;

    // navigate to split screen with items, people and saved selections
    final result = await Get.toNamed(
      AppRoutes.split,
      arguments: {
        'items': items,
        'people': people.toList(),
        'savedSelections': savedSplitSelections,
        'peopleCountChanged': peopleCountChanged, // pass the flag
      },
    );

    // save split selections when coming back
    if (result != null && result is Map<String, dynamic>) {
      savedSplitSelections =
          result['savedSelections'] as Map<int, List<int>>? ?? {};
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
