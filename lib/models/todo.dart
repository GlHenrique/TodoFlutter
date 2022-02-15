class Todo {
  Todo({required this.title, required this.date});

  Todo.fromJson(Map<String, dynamic> json)
      : date = DateTime.parse(json['date']),
        title = json['title'];

  String title;
  DateTime date;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date.toIso8601String(),
    };
  }
}
