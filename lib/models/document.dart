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

class UploadedBy {
  final String firstName;
  final String lastName;

  UploadedBy({
    required this.firstName,
    required this.lastName,
  });

  factory UploadedBy.fromJson(Map<String, dynamic> json) {
    return UploadedBy(
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}

class DocumentDetailed {
  final Document document;
  final String type;
  final String uploadedAt;
  final UploadedBy uploadedBy;

  DocumentDetailed({
    required this.document,
    required this.type,
    required this.uploadedAt,
    required this.uploadedBy,
  });

  factory DocumentDetailed.fromJson(Map<String, dynamic> json) {
    Document document = Document.fromJson(json);
    UploadedBy uploadedBy = UploadedBy.fromJson(json['uploadedByUser']);

    return DocumentDetailed(
      document: document,
      type: json['type'],
      uploadedAt: json['uploadedAt'],
      uploadedBy: uploadedBy,
    );
  }
}
