class Document {
  final String id;
  final String name;
  final String url;

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

class DocumentDetailed {
  final Document document;
  final String type;
  final String uploadedAt;

// final String uploadedBy;

  DocumentDetailed({
    required this.document,
    required this.type,
    required this.uploadedAt,
  });

  factory DocumentDetailed.fromJson(Map<String, dynamic> json) {
    Document document = Document.fromJson(json);
    return DocumentDetailed(
      document: document,
      type: json['type'],
      uploadedAt: json['uploadedAt'],
    );
  }
}
