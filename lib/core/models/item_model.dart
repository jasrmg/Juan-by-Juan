import 'package:juan_by_juan/utils/currency_formatter.dart';

// item model for bill splitting
// represents a single item with name and price (stored as centavos)
class ItemModel {
  final int? id;
  final String name;
  final int price; // stored as cent (e.g. 1050 = P10.50)

  ItemModel({this.id, required this.name, required this.price});

  /// convert model to map for db storage
  Map<String, dynamic> toMap({int? billId}) {
    return {'id': id, 'bill_id': billId, 'name': name, 'price': price};
  }

  /// create model from db map
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      price: map['price'] as int,
    );
  }

  /// format price for display (e.g 1050 -> P10.50, 100000 -> P1,000.00)
  String get formattedPrice => CurrencyFormatter.format(price);
}
