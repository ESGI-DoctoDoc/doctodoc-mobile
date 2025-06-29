enum DocumentType {
  medicalReport("Rapport médical"),
  prescription("Ordonnance"),
  medicalCertificate("Certificat médical"),
  analysesResult("Résultats d\'analyses"),
  other("Autre");

  final String label;

  const DocumentType(this.label);

  factory DocumentType.of(String value) {
    return DocumentType.values.firstWhere((type) => type.name == value);
  }
}

class Document {
  final String id;
  final String name;
  final String url;
  final String type;

  Document({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      type: json['type'],
    );
  }
}

class DocumentUser {
  final String firstName;
  final String lastName;

  DocumentUser({
    required this.firstName,
    required this.lastName,
  });

  factory DocumentUser.fromJson(Map<String, dynamic> json) {
    return DocumentUser(
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}

class DocumentTrace {
  final String type;
  final String description;
  final String date;
  final DocumentUser user;

  DocumentTrace({
    required this.type,
    required this.description,
    required this.date,
    required this.user,
  });

  factory DocumentTrace.fromJson(Map<String, dynamic> json) {
    DocumentUser user = DocumentUser.fromJson(json['user']);

    return DocumentTrace(
      type: json['type'],
      description: json['description'],
      date: json['date'],
      user: user,
    );
  }
}

class DocumentDetailed {
  final Document document;
  final String type;
  final String uploadedAt;
  final DocumentUser uploadedBy;

  DocumentDetailed({
    required this.document,
    required this.type,
    required this.uploadedAt,
    required this.uploadedBy,
  });

  factory DocumentDetailed.fromJson(Map<String, dynamic> json) {
    Document document = Document.fromJson(json);
    DocumentUser uploadedBy = DocumentUser.fromJson(json['uploadedByUser']);

    return DocumentDetailed(
      document: document,
      type: json['type'],
      uploadedAt: json['uploadedAt'],
      uploadedBy: uploadedBy,
    );
  }
}
