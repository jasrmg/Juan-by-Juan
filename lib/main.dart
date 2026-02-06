import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/core/configurations/app_binding.dart';
import 'package:juan_by_juan/core/configurations/flavors.dart';
import 'package:juan_by_juan/core/configurations/routes.dart';
import 'package:juan_by_juan/core/theme/app_theme.dart';

void main() async {
  // ensure flutter is initialized before loading env
  WidgetsFlutterBinding.ensureInitialized();

  // initialize flavors config
  await FlavorConfig.initialize(Flavor.uat);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // get the loaded flavor config
    final flavorConfig = FlavorConfig.instance;

    return GetMaterialApp(
      title: flavorConfig.appName,
      debugShowCheckedModeBanner: false,

      // theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // follows system theme
      // GetX config
      initialBinding: AppBinding(),
      getPages: AppPages.routes,

      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                flavorConfig.appName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Show flavor badge (only for non-prod)
              if (!flavorConfig.isProduction)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: flavorConfig.isUAT ? Colors.orange : Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'ENV: ${flavorConfig.flavorName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              const Text(
                'Bootstrap Complete! ✅',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
