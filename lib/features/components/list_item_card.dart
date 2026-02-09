import 'package:flutter/material.dart';
import 'package:juan_by_juan/core/constants/app_constants.dart';

/// reusable list item card with number badge and delete button
class ListItemCard extends StatelessWidget {
  final int index;
  final String title;
  final String? subtitle;
  final VoidCallback onDelete;

  const ListItemCard({
    super.key,
    required this.index,
    required this.title,
    this.subtitle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: AppConstants.cardMarginBottom,
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
