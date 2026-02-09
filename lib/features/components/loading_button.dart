import 'package:flutter/material.dart';
import 'package:juan_by_juan/core/constants/app_constants.dart';

/// reusable button with loading state
class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String label;
  final String loadingLabel;
  final IconData? icon;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.label,
    this.loadingLabel = 'Loading...',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: AppConstants.spinnerSize,
                height: AppConstants.spinnerSize,
                child: CircularProgressIndicator(
                  strokeWidth: AppConstants.spinnerStrokeWidth,
                ),
              )
            : Icon(icon ?? Icons.check),
        label: Text(isLoading ? loadingLabel : label),
      ),
    );
  }
}
