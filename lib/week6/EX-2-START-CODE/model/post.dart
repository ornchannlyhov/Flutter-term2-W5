class Post {
  final int id;
  final String title;
  final String description;

  Post({required this.id, required this.title, required this.description});

  factory Post.fromJson(Map<String, dynamic> json) {
    try {
      assert(json['id'] is int);
      return Post(
        id: json['id'],
        title: json['title'],
        description: json['body'],
      );
    } catch (e) {
      throw Exception('Error parsing Post from JSON: $e');
    }
  }
}