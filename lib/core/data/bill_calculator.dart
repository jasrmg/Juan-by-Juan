import 'package:juan_by_juan/core/models/item_model.dart';
import 'package:juan_by_juan/core/models/person_model.dart';

/// bill calculating service handles splitting items among people using integer math (centavos)
class BillCalculator {
  // private constructor to prevent instantiation
  BillCalculator._();

  /// calculate each persons total amount and percentage
  /// returns list of PersonModel with updated totalAmount
  static List<PersonModel> calculateSplits({
    required List<ItemModel> items,
    required List<PersonModel> people,
    required Map<int, List<int>> selectedPeoplePerItem,
  }) {
    // initialize totals map person index -> total centavos
    final Map<int, int> personTotals = {};
    for (int i = 0; i < people.length; i++) {
      personTotals[i] = 0;
    }

    // calculate split for each item
    for (int itemIndex = 0; itemIndex < items.length; itemIndex++) {
      final item = items[itemIndex];
      final selectedPeople = selectedPeoplePerItem[itemIndex] ?? [];

      if (selectedPeople.isEmpty) continue;

      // split item price among selected people
      final splitCount = selectedPeople.length;
      final baseAmount = item.price ~/ splitCount; // integer division
      final remainder = item.price % splitCount; // remainder to distribute

      // distribute base amount to all selected people
      for (int personIndex in selectedPeople) {
        personTotals[personIndex] =
            (personTotals[personIndex] ?? 0) + baseAmount;
      }

      // distribute remainder (1 centavo each) to first N people
      for (int i = 0; i < remainder; i++) {
        final personIndex = selectedPeople[i];
        personTotals[personIndex] = (personTotals[personIndex] ?? 0) + 1;
      }
    }

    // create  updated person models with totals
    final List<PersonModel> updatedPeople = [];
    for (int i = 0; i < people.length; i++) {
      updatedPeople.add(
        PersonModel(
          id: people[i].id,
          name: people[i].name,
          totalAmount: personTotals[i] ?? 0,
        ),
      );
    }

    return updatedPeople;
  }

  /// calculate total bill amount
  static int calculateTotalBill(List<ItemModel> items) {
    return items.fold(0, (sum, item) => sum + item.price);
  }

  /// calculate percentage of total bill for a person
  /// returns percentage as double (e.g 33.33)
  static double calculatePercentage(int personTotal, int billTotal) {
    if (billTotal == 0) return 0.0;
    return (personTotal / billTotal) * 100;
  }
}
