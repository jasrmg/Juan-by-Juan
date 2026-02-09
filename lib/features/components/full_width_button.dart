import 'package:flutter/material.dart';

/// reusable full-width button for navigation/actions
class FullWidthButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isPrimary;

  const FullWidthButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(label),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(label),
            ),
    );
  }
}
