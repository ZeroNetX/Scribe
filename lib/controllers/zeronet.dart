import '../imports.dart';

final zeroNetController = ZeroNetController();

Future<void> init() async {
  await ZeroNet.instance.connect(
    kSiteAddr,
    onEventMessage: zeroNetController.onMessage,
  );
  await ZeroNet.instance.channelJoinFuture(['siteChanged']);
  await zeroNetController.loadSiteInfo();

  initFetch();
}

void initFetch() {
  zeroNetController.fetchAllArticles();
  zeroNetController.fetchRecentArticles();
  zeroNetController.fetchMostLikedArticles();
}

class ZeroNetController extends GetxController {
  final allArticles = <Article>[].obs;
  final recentArticles = <Article>[].obs;
  final mostLikedArticles = <Article>[].obs;
  final commentsList = <Comment>[].obs;
  final articleVotesCount = <int, int>{}.obs;
  final articleCommentsCount = <int, int>{}.obs;
  User userObject = User(
    nextCommentId: 0,
    comments: [],
    commentVotes: {},
    postVotes: {},
  );

  Rx<SiteInfo?> siteInfo = Rx(null);

  void onMessage(message) {
    var msg = jsonDecode(message);

    var msg2 = msg['params'];
    if (msg2 is Map) {
      if (msg2['event'] is List) {
        final event = msg2['event'];

        final name = event[0];
        final param = event[1];

        if (name == 'file_done') {
          var path = param.toString();

          var pattern = 'data/users/';

          if (path.startsWith('${pattern}1') && path.endsWith('.json')) {
            debugPrint('User Data Changed');
            final userFile = path.replaceFirst(pattern, '');
            final dataOrContentJsonFile =
                userFile.replaceFirst(RegExp(r'1\w+'), '');
            if (dataOrContentJsonFile == "/data.json") {}
          }
        } else if (name == 'cert_changed') {
          loadSiteInfo();
        } else {
          debugPrint('Event Message : $name :: $param');
        }
      } else if (msg['cmd'] == 'peerReceive') {}
    } else {}
  }

  Future<void> loadSiteInfo() async {
    var res = await ZeroNet.instance.siteInfoFuture();
    if (res.isMsg) {
      siteInfo.value = res.message!.siteInfo;
      await loadUserDataJson();
      siteInfo.refresh();
    }
  }

//   Future<void> addNewUserDefaultData() async {
//     String path = "data/users/${siteInfo.value!.authAddress}";
//     var res = await ZeroNet.instance.dirListFuture(path);
//     String defaultData = '''{
// 	"next_comment_id": 1,
// 	"comment": [],
// 	"comment_vote": {},
// 	"post_vote": {}
// }''';
//     if (!res.isMsg) {
//       await ZeroNet.instance.fileWriteFuture(
//         "$path/data.json",
//         base64.encode(
//           utf8.encode(defaultData),
//         ),
//       );
//     }
//     loadUserDataJson();
//   }

  Future<void> loadUserDataJson() async {
    String path = "data/users/${siteInfo.value!.authAddress}";
    var isDirAvailable = await ZeroNet.instance.dirListFuture(path);
    if (isDirAvailable.isMsg) {
      var res = await ZeroNet.instance.fileGetFuture("$path/data.json");
      if (res.isMsg && siteInfo.value!.certUserId != null) {
        if (res.message!.result != null) {
          userObject = User.fromJson(json.decode(res.message!.result));
        }
      }
    }
  }

  void fetchRecentArticles() {
    fetchArticles(recentFetchQuery(), addRecentArticle);
  }

  void fetchMostLikedArticles() {
    fetchArticles(mostLikedQuery(), addMostLikedArticle);
  }

  void fetchAllArticles() {
    fetchArticles(kARTICLESQUERY, addArticle);
  }

  void fetchArticles(String query, Function(Article article) adder) async {
    final result = await ZeroNet.instance.dbQueryFuture(query);

    if (result.isMsg) {
      for (var json in result.message!.result) {
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

  void likeArticle(int postId) async {
    if (siteInfo.value!.certUserId != null) {
      final path = 'data/users/${siteInfo.value!.authAddress}/data.json';

      menuController.currentArticle.value!.likesCount =
          menuController.currentArticle.value!.likesCount + 1;
      menuController.currentArticle.refresh();

      userObject.postVotes["$postId"] = 1;
      await ZeroNet.instance.fileWriteFuture(
        path,
        base64.encode(
          utf8.encode(
            json.encode(userObject.toMap()),
          ),
        ),
      );
      sitePublishToNetwork();
    }
  }

  Future<void> loadComments(int id) async {
    var res = await ZeroNet.instance.dbQueryFuture(commentQuery(id));
    if (res.isMsg) {
      List<Comment> commentsList = [];
      for (var obj in res.message!.result) {
        commentsList.add(Comment.fromJson(obj));
      }
      zeroNetController.commentsList.clear();
      zeroNetController.commentsList.addAll(commentsList);
    }
  }

  Future<void> addComment(Comment comment) async {
    commentsList.insert(0, comment);
    userObject.comments.add({
      "comment_id": userObject.nextCommentId,
      "body": comment.body,
      "post_id": comment.commentId,
      "date_added": comment.dateAdded
    });
    userObject.nextCommentId += 1;
    final path = 'data/users/${siteInfo.value!.authAddress}/data.json';
    await ZeroNet.instance.fileWriteFuture(
      path,
      base64.encode(
        utf8.encode(
          json.encode(userObject.toMap()),
        ),
      ),
    );

    commentsList.refresh();
    menuController.currentArticle.value!.commentsCount += 1;
    menuController.currentArticle.refresh();
    sitePublishToNetwork();
  }

  Future sitePublishToNetwork() async {
    String path = 'data/users/${siteInfo.value!.authAddress}/content.json';
    await ZeroNet.instance.sitePublishFuture(
      inner_path: path,
      sign: true,
      update_changed_files: true,
    );
  }
}

String recentFetchQuery() {
  return """
SELECT post.*,  COUNT(comment_id) AS comments,
(SELECT COUNT(*) FROM post_vote WHERE post_vote.post_id = post.post_id) AS votes
FROM post
LEFT JOIN comment USING (post_id)
GROUP BY post_id
ORDER BY date_published DESC
LIMIT ${themeController.recentArticles.value}
""";
}

String mostLikedQuery() => """
SELECT post.*,  COUNT(comment_id) AS comments,
(SELECT COUNT(*) FROM post_vote WHERE post_vote.post_id = post.post_id) AS votes
FROM post
LEFT JOIN comment USING (post_id)
GROUP BY post_id
ORDER BY votes DESC
LIMIT ${themeController.likedArticles.value}
""";

const kARTICLESQUERY = """
SELECT post.*,  COUNT(comment_id) AS comments,
(SELECT COUNT(*) FROM post_vote WHERE post_vote.post_id = post.post_id) AS votes
FROM post
LEFT JOIN comment USING (post_id)
GROUP BY post_id
ORDER BY votes DESC
""";
String commentQuery(int postId) {
  return """SELECT comment.*, json_content.json_id AS content_json_id, keyvalue.value AS cert_user_id, json.directory,
			(SELECT COUNT(*) FROM comment_vote WHERE comment_vote.comment_uri = comment.comment_id || '@' || json.directory) AS votes
			FROM comment
			LEFT JOIN json USING (json_id)
			LEFT JOIN json AS json_content ON (json_content.directory = json.directory AND json_content.file_name='content.json')
			LEFT JOIN keyvalue ON (keyvalue.json_id = json_content.json_id AND key = 'cert_user_id')
			WHERE post_id = $postId ORDER BY date_added DESC
   """;
}
