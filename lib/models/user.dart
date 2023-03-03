class User {
  int nextCommentId;
  List comments;
  Map commentVotes;
  Map postVotes;

  User({
    required this.nextCommentId,
    required this.comments,
    required this.commentVotes,
    required this.postVotes,
  });

  factory User.fromJson(Map map) {
    return User(
      nextCommentId: map["next_comment_id"],
      comments: map["comment"],
      commentVotes: map["comment_vote"],
      postVotes: map["post_vote"] ?? {},
    );
  }

  Map toMap() {
    return {
      "next_comment_id": nextCommentId,
      "comment": comments,
      "comment_vote": commentVotes,
      "post_vote": postVotes
    };
  }
}
