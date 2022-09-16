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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          index < 10 ? '0$index' : '$index',
          style: const TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ).paddingOnly(right: 16),
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 340,
              child: Text(
                article.title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Text('$readingTimeStr mins'),
                const SizedBox(width: 12.0),
                Text(timeAgo),
              ],
            )
          ],
        ),
      ],
    ).paddingOnly(right: 20, bottom: 24);
  }
}
