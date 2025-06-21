class Document {
  String id;
  String name;
  String url;

  Document({
    required this.id,
    required this.name,
    required this.url,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      name: json['name'],
      url: json['url'],
    );
  }
}
