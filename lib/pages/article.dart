import '../imports.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage(
    this.article, {
    super.key,
  });
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Text(
          article.title,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        // const SizedBox(width: 36),
        MarkdownBody(
          data: article.body,
          shrinkWrap: true,
        ).paddingSymmetric(vertical: 20)
      ],
    );
  }
}
