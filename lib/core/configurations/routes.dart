import 'package:get/get.dart';
import 'package:juan_by_juan/features/pages/bill_detail/bill_detail_binding.dart';
import 'package:juan_by_juan/features/pages/bill_detail/bill_detail_page.dart';
import 'package:juan_by_juan/features/pages/items/items_binding.dart';
import 'package:juan_by_juan/features/pages/items/items_page.dart';

import 'package:juan_by_juan/features/pages/people/people_binding.dart';
import 'package:juan_by_juan/features/pages/people/people_page.dart';

import 'package:juan_by_juan/features/pages/split/split_binding.dart';
import 'package:juan_by_juan/features/pages/split/split_page.dart';

import 'package:juan_by_juan/features/pages/summary/summary_binding.dart';
import 'package:juan_by_juan/features/pages/summary/summary_page.dart';

import 'package:juan_by_juan/features/pages/history/history_binding.dart';
import 'package:juan_by_juan/features/pages/history/history_page.dart';

import 'package:juan_by_juan/features/pages/home/home_binding.dart';
import 'package:juan_by_juan/features/pages/home/home_page.dart';

/// centralized route management for the app
/// all nagivation paths are defined for consistency
class AppRoutes {
  // private constructor to prevent instantiation
  AppRoutes._();

  // route paths
  static const String home = '/';
  static const String items = '/items';
  static const String people = '/people';
  static const String split = '/split';
  static const String summary = '/summary';
  static const String history = '/history';
  static const String billDetail = '/bill-detail';
}

/// GetX route config
/// maps rotue names to pages
class AppPages {
  // private constructor to prevent instantiation
  AppPages._();

  static final routes = <GetPage>[
    // routes will be added here
    GetPage(
      name: AppRoutes.items,
      page: () => const ItemsPage(),
      binding: ItemsBinding(),
    ),
    GetPage(
      name: AppRoutes.people,
      page: () => const PeoplePage(),
      binding: PeopleBinding(),
    ),
    GetPage(
      name: AppRoutes.split,
      page: () => const SplitPage(),
      binding: SplitBinding(),
    ),
    GetPage(
      name: AppRoutes.summary,
      page: () => const SummaryPage(),
      binding: SummaryBinding(),
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => const HistoryPage(),
      binding: HistoryBinding(),
    ),

    GetPage(
      name: AppRoutes.billDetail,
      page: () => const BillDetailPage(),
      binding: BillDetailBinding(),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
