import 'package:juan_by_juan/utils/currency_formatter.dart';

/// person model for bill splitting
/// represents a person involded in the bill
class PersonModel {
  final int? id;
  final String name;
  final int totalAmount; // total amount the person owes(in centavos)

  PersonModel({this.id, required this.name, this.totalAmount = 0});

  /// convert model to map for db storage
  Map<String, dynamic> toMap({int? billId}) {
    return {
      'id': id,
      'bill_id': billId,
      'name': name,
      'total_amount': totalAmount,
    };
  }

  /// create model from db map
  factory PersonModel.fromMap(Map<String, dynamic> map) {
    return PersonModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      totalAmount: map['total_amount'] as int? ?? 0,
    );
  }

  /// format total amount for display with thousand separators
  String get formattedTotal => CurrencyFormatter.format(totalAmount);
}
