import 'package:doctodoc_mobile/models/document.dart';

abstract class MedicalRecordDataSource {
  Future<List<Document>> getAll();
}
