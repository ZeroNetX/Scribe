import '../imports.dart';

class RecentArticle extends StatelessWidget {
  const RecentArticle(
    this.index,
    this.article, {
    super.key,
  });
  final Article article;
  final int index;

  @override
  Widget build(BuildContext context) {
    final readingTimeStr = readingTime(article.body).minutes.ceil().toString();
    final timeAgo = format(article.dateTime);
    return Obx(() {
      return SizedBox(
        width: themeController.articleListWidgetWidth.value,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              index < 10 ? '0$index' : '$index',
              style: const TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ).contained(color: Colors.brown).paddingOnly(right: 16),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: themeController.articleListWidgetWidth.value * 0.75,
                  child: InkWell(
                    onTap: () {
                      menuController.setCurrentArticle(article);
                      menuController.goto(Menu.article);
                    },
                    child: Text(
                      article.title,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ).contained(color: Colors.amber),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text('$readingTimeStr mins'),
                    const SizedBox(width: 12.0),
                    Text(timeAgo),
                  ],
                )
              ],
            ).contained(color: Colors.red),
          ],
        ),
      );
    });
  }
}
