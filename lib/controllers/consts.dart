import '../imports.dart';

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
