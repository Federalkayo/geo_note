
class Note {
  final String id;
  final String title;
  final String content;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'latitude': latitude,
        'longitude': longitude,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}