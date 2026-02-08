/// bill model for storing completed bills
class BillModel {
  final int? id;
  final String name;
  final int totalAmount;
  final DateTime createdAt;
  final bool isPinned;

  BillModel({
    this.id,
    required this.name,
    required this.totalAmount,
    required this.createdAt,
    this.isPinned = false,
  });

  /// convert model to map for db storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'total_amount': totalAmount,
      'created_at': createdAt.toIso8601String(),
      'is_pinned': isPinned ? 1 : 0,
    };
  }

  /// create model from db map
  factory BillModel.fromMap(Map<String, dynamic> map) {
    return BillModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      totalAmount: map['total_amount'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      isPinned: (map['is_pinned'] as int?) == 1,
    );
  }

  /// format created date for display
  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  /// create copy with updated fields
  BillModel copyWith({bool? isPinned}) {
    return BillModel(
      id: id,
      name: name,
      totalAmount: totalAmount,
      createdAt: createdAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
