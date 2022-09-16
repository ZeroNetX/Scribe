import '../imports.dart';

class ArticleList extends StatelessWidget {
  const ArticleList(
    this.title,
    this.articles,
    this.loader, {
    super.key,
    this.customIndex,
  });
  final String title;
  final RxList<Article> articles;
  final RxMap<int, int>? customIndex;
  final Function()? loader;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          // color: Colors.blueAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                onPressed: loader,
                child: const Text("Refresh"),
              ),
            ],
          ).paddingSymmetric(vertical: 24),
        ),
        Obx(() {
          final articlesL = <Widget>[];
          for (var a in articles) {
            var idx = customIndex != null
                ? customIndex![a.id]!
                : articles.indexOf(a) + 1;

            articlesL.add(RecentArticle(idx, a));
          }
          return Wrap(
            alignment: WrapAlignment.spaceBetween,
            // runAlignment: WrapAlignment.center,
            // spacing: 180,
            // runAlignment: WrapAlignment.spaceEvenly,
            // crossAxisAlignment: WrapCrossAlignment.center,
            children: articlesL,
          );
        })
      ],
    );
  }
}
