import 'package:get/get.dart';

class DetailScreenCategoryController extends GetxController {
  var isMenuOpen = false.obs;

  void toggleMenu() {
    isMenuOpen.value = !isMenuOpen.value;
  }
}
