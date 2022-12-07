class AnimeModel {
  final DateTime date;
  final String title;
  final String description;
  final String link;

  AnimeModel({
    required this.date,
    required this.title,
    required this.description,
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'title': title,
      'description': description,
      'link': link,
    };
  }

  factory AnimeModel.fromMap(Map<String, dynamic> map) {
    return AnimeModel(
      date: DateTime.parse(map['date']),
      title: map['title']['rendered'],
      description: map['yoast_head_json']['og_description'],
      link: map['link'],
    );
  }
}
