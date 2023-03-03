import '../imports.dart';

final menuController = MenuController();

class MenuController extends GetxController {
  final currentRoute = Menu.homePage.obs;
  var showCommentBox = false.obs;
  var isFullScreen = false.obs;
  final Rx<Article?> currentArticle = Rx(null);

  void setCurrentArticle(Article article) {
    currentArticle.value = article;
  }

  void goto(Menu menu) {
    if ((Menu.article == menu && currentArticle.value != null) ||
        menu != Menu.article) {
      currentRoute.value = menu;
      if (Menu.article == menu) {
        zeroNetController.loadComments(currentArticle.value!.id);
      }
    }
  }
}
