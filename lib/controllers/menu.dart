import '../imports.dart';

final menuController = MenuController();

class MenuController extends GetxController {
  final currentRoute = Menu.homePage.obs;
  late final Rx<Article?> currentArticle = Rx(null);

  void setCurrentArticle(Article article) => currentArticle.value = article;

  void goto(Menu menu) => currentRoute.value = menu;
}
