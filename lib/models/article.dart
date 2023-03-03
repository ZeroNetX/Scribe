class Article {
  int id;
  String title;
  String body;
  DateTime dateTime;
  int commentsCount;
  int likesCount;
  Article(
    this.id,
    this.title,
    this.body,
    this.dateTime,
    this.commentsCount,
    this.likesCount,
  );

  static Article fromJson(Map<String, dynamic> json) {
    final id = json["post_id"];
    final title = json["title"];
    final body = json["body"];
    final millis = json['date_published'];
    final commentsCount = json['comments'] ?? 0;
    final likesCount = json['votes'] ?? 0;
    final date = DateTime.fromMillisecondsSinceEpoch(
      (millis is double ? millis.floor() : millis) * 1000,
    );
    return Article(id, title, body, date, commentsCount, likesCount);
  }
}
