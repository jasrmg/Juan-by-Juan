import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/core/configurations/app_binding.dart';
import 'package:juan_by_juan/core/configurations/routes.dart';
import 'package:juan_by_juan/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Juan-by-Juan',
      debugShowCheckedModeBanner: false,

      // theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // follows system theme
      // GetX config
      initialBinding: AppBinding(),
      getPages: AppPages.routes,

      home: const Scaffold(
        body: Center(
          child: Text(
            'Juan-by-Juan\nBootstrap Complete!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
