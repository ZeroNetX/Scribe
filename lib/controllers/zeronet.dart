import '../imports.dart';

void init() async {
  await ZeroNet.instance.connect("1SCribeHs1nz8m3vXipP84oyXUy4nf2ZD");
  initFetch();
}

void initFetch() {
  zeroNetController.fetchAllArticles();
  zeroNetController.fetchRecentArticles();
  zeroNetController.fetchMostLikedArticles();
}

final zeroNetController = ZeroNetController();

class ZeroNetController extends GetxController {
  final allArticles = <Article>[].obs;
  final recentArticles = <Article>[].obs;
  final mostLikedArticles = <Article>[].obs;
  final articleVotesCount = <int, int>{}.obs;
  final articleCommentsCount = <int, int>{}.obs;

  void fetchRecentArticles() {
    fetchArticles(kRECENT_ARTICLES_QUERY, addRecentArticle);
  }

  void fetchMostLikedArticles() {
    fetchArticles(kMOST_LIKED_QUERY, addMostLikedArticle);
  }

  void fetchAllArticles() {
    fetchArticles(kARTICLES_QUERY, addArticle);
  }

  void fetchArticles(String query, Function(Article article) adder) async {
    final result = await ZeroNet.instance.dbQueryFuture(query);

    if (result.result is List) {
      for (var json in result.result) {
        Article article = Article.fromJson(json);
        articleCommentsCount.update(
          article.id,
          (_) => json['comments'],
          ifAbsent: () => json['comments'],
        );
        articleVotesCount.update(
          article.id,
          (_) => json['votes'],
          ifAbsent: () => json['votes'],
        );
        adder(article);
      }
    }
  }

  void addRecentArticle(Article article) {
    recentArticles.addIf(
      !recentArticles.any((a) => a.id == article.id),
      article,
    );
    removeArticle(article);
  }

  void addMostLikedArticle(Article article) {
    mostLikedArticles.addIf(
      !mostLikedArticles.any((a) => a.id == article.id),
      article,
    );
    removeArticle(article);
  }

  void addArticle(Article article) {
    allArticles.addIf(
      !allArticles.any((a) => a.id == article.id),
      article,
    );
  }

  void removeArticle(Article article) {
    allArticles.removeWhere(((e) => e.id == article.id));
  }
}

const kRECENT_ARTICLES_QUERY = """
SELECT post.*,  COUNT(comment_id) AS comments,
(SELECT COUNT(*) FROM post_vote WHERE post_vote.post_id = post.post_id) AS votes
FROM post
LEFT JOIN comment USING (post_id)
GROUP BY post_id
ORDER BY date_published DESC
LIMIT 2
""";

const kMOST_LIKED_QUERY = """
SELECT post.*,  COUNT(comment_id) AS comments,
(SELECT COUNT(*) FROM post_vote WHERE post_vote.post_id = post.post_id) AS votes
FROM post
LEFT JOIN comment USING (post_id)
GROUP BY post_id
ORDER BY votes DESC
LIMIT 4
""";

const kARTICLES_QUERY = """
SELECT post.*,  COUNT(comment_id) AS comments,
(SELECT COUNT(*) FROM post_vote WHERE post_vote.post_id = post.post_id) AS votes
FROM post
LEFT JOIN comment USING (post_id)
GROUP BY post_id
ORDER BY votes DESC
""";
