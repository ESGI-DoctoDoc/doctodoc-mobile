enum MedicalConcernQuestionType {
  list('list'),
  yesNo('yes_no'),
  text('text');

  final String label;

  const MedicalConcernQuestionType(this.label);

  static MedicalConcernQuestionType from(String value) {
    return MedicalConcernQuestionType.values.firstWhere(
      (e) => e.label == value,
      orElse: () => throw ArgumentError('Invalid value: $value'),
    );
  }
}

class MedicalConcernQuestion {
  final String id;
  final MedicalConcernQuestionType type;
  final String question;
  final bool required;
  final List<String> options;

  MedicalConcernQuestion({
    required this.id,
    required this.type,
    required this.question,
    required this.required,
    this.options = const [],
  });

  factory MedicalConcernQuestion.fromJson(Map<String, dynamic> json) {
    final jsonOptions = (json['options'] as List?) ?? [];

    return MedicalConcernQuestion(
      id: json['id'],
      type: MedicalConcernQuestionType.from(json['type']),
      question: json['question'],
      required: json['isMandatory'],
      options: List.from(jsonOptions),
    );
  }
}
