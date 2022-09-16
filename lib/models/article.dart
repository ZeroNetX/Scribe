class Article {
  int id;
  String title;
  String body;
  DateTime dateTime;
  Article(
    this.id,
    this.title,
    this.body,
    this.dateTime,
  );

  static Article fromJson(Map<String, dynamic> json) {
    final id = json["post_id"];
    final title = json["title"];
    final body = json["body"];
    final millis = json['date_published'];
    final date = DateTime.fromMillisecondsSinceEpoch(
      (millis is double ? millis.floor() : millis) * 1000,
    );
    return Article(id, title, body, date);
  }
}
