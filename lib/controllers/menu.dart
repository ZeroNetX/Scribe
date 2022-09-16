import '../imports.dart';

final menuController = MenuController();

class MenuController extends GetxController {
  final currentRoute = Menu.homePage.obs;

  void goto(Menu menu) => currentRoute.value = menu;
}
