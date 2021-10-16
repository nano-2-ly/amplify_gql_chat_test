class Chat {
  String id;
  String content;
  String title;


  Chat(this.id, this.content, this.title);

  Chat.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        title = json['title'];

  Map<String, dynamic> toJson() =>
      {
        'id' : id,
        'content': content,
        'title': title,
      };
}