import '../imports.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Column(
        children: [
          ArticleList(
            'Recent Articles',
            zeroNetController.recentArticles,
            zeroNetController.fetchRecentArticles,
          ),
          ArticleList(
            'Most Likes Articles',
            zeroNetController.mostLikedArticles,
            customIndex: zeroNetController.articleVotesCount,
            zeroNetController.fetchMostLikedArticles,
          ),
          ArticleList(
            'Previous',
            zeroNetController.allArticles,
            zeroNetController.fetchAllArticles,
          ),
        ],
      ),
    );
  }
}
