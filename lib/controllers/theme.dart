import '../imports.dart';

final themeController = ThemeController();

class ThemeController extends GetxController {
  final debugWidgets = false;
  final deviceWidth = 0.0.obs;
  final deviceHeight = 0.0.obs;

  final runSpacing = 0.0.obs;

  final pagePadding = 0.obs;
  final bodyFlex = 10.obs;

  final recentArticles = 2.obs;
  final likedArticles = 4.obs;

  final RxDouble articleListWidgetWidth = 0.0.obs;

  void layoutChanged(Size size) {
    deviceHeight.value = size.height;
    deviceWidth.value = size.width;
    pagePadding.value = 1;

    if (size.width < 728) {
      articleListWidgetWidth.value = size.width * 0.6;
      pagePadding.value = 1;
      bodyFlex.value = 10;
    } else if (size.width < 1080) {
      bodyFlex.value = 12;
      runSpacing.value = size.width * 0.075;
      articleListWidgetWidth.value = size.width * 0.35;
      pagePadding.value = 1;
    } else if (size.width < 1280) {
      bodyFlex.value = 15;
      runSpacing.value = size.width * 0.05;
      articleListWidgetWidth.value = size.width * 0.26;
      pagePadding.value = 1;
      recentArticles.value = 3;
      likedArticles.value = 6;
      initFetch();
    } else {
      bodyFlex.value = 15;
      runSpacing.value = size.width * 0.02;
      articleListWidgetWidth.value = size.width * 0.28;
      pagePadding.value = 1;
      recentArticles.value = 3;
      likedArticles.value = 6;
      initFetch();
    }
  }

  MarkdownStyleSheet getMarkdownStyleSheet() {
    const borderSide = BorderSide(color: Colors.transparent, width: 2);
    Color markdownColor = Colors.amber;
    return MarkdownStyleSheet().copyWith(
      a: TextStyle(color: Colors.orange.shade900),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 2.0,
            color: Colors.amber.shade200,
          ),
        ),
      ),
      blockquotePadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      blockquoteDecoration: BoxDecoration(
        color: Colors.amber.shade100,
        border: Border(
          left: BorderSide(
            color: markdownColor,
            width: 2,
          ),
          right: borderSide,
          bottom: borderSide,
          top: borderSide,
        ),
      ),
      codeblockDecoration: BoxDecoration(
        color: markdownColor.withAlpha(10),
      ),
      code: const TextStyle(
        backgroundColor: Colors.transparent,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
