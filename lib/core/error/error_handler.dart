import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/core/configurations/flavors.dart';
import 'package:juan_by_juan/core/error/exceptions.dart';

/// centralized error handler, handles all app errors consistently with user-friendly colored messages
class ErrorHandler {
  ErrorHandler._();

  /// handle any error and show appropriate message to user
  static void handle(dynamic error, {String? fallbackMessage}) {
    String userMessage;
    String? debugInfo;

    // determine user message based on error type
    if (error is AppException) {
      userMessage = error.message;
      debugInfo = error.debugMessage ?? error.toString();
    } else {
      userMessage =
          fallbackMessage ?? 'Something went wrong. Please try again.';
      debugInfo = error.toString();
    }

    // log error in debug mode only (security)
    if (kDebugMode && !FlavorConfig.instance.isProduction) {
      debugPrint('ERROR: $debugInfo');
    }

    // show user-friendly colored snackbar
    Get.snackbar(
      'Error',
      userMessage,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      duration: const Duration(seconds: 2),
    );
  }
}
