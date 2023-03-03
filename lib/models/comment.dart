class Comment {
  final String body;
  final int dateAdded;
  final int commentId;
  final int jsonId;
  final String userId;
  final String directory;
  int commentVotes;
  Comment({
    required this.body,
    required this.dateAdded,
    required this.commentId,
    required this.commentVotes,
    required this.directory,
    required this.jsonId,
    required this.userId,
  });

  factory Comment.fromJson(Map map) {
    return Comment(
      body: map['body'],
      dateAdded: map['date_added'],
      commentId: map['comment_id'],
      commentVotes: map['votes'],
      directory: map['directory'],
      jsonId: map['json_id'],
      userId: map['cert_user_id'] ?? 'UnkownUser',
    );
  }
}
