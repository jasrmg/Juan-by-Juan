import 'package:get/get.dart';
import 'package:juan_by_juan/features/pages/people/people_controller.dart';

/// binding for peple page, initializes controller when page is accessed

class PeopleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PeopleController());
  }
}
