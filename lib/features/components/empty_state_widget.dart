import 'package:flutter/material.dart';
import 'package:juan_by_juan/core/constants/app_constants.dart';

/// reusable empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;

  const EmptyStateWidget({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: AppConstants.iconSizeLarge,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: AppConstants.spacingMedium),
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppConstants.textSizeBody,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
