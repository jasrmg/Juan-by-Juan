import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:juan_by_juan/core/configurations/app_binding.dart';
import 'package:juan_by_juan/core/configurations/flavors.dart';
import 'package:juan_by_juan/core/configurations/routes.dart';
import 'package:juan_by_juan/core/theme/app_theme.dart';

void main() async {
  // ensure flutter is initialized before loading env
  WidgetsFlutterBinding.ensureInitialized();

  // detect flavor from build config
  // await FlavorConfig.initialize(Flavor.uat);
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'uat');
  final flavorEnum = Flavor.values.firstWhere(
    (e) => e.name == flavor,
    orElse: () => Flavor.uat,
  );

  // initialize flavors config
  await FlavorConfig.initialize(flavorEnum);

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

      initialRoute: AppRoutes.splash,
    );
  }
}
