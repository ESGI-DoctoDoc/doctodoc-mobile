import 'package:doctodoc_mobile/models/document.dart';
import 'package:doctodoc_mobile/services/data_sources/medical_record_data_source/medical_record_data_source.dart';

import '../../../exceptions/app_exception.dart';

class MedicalRecordRepository {
  final MedicalRecordDataSource medicalRecordDataSource;

  MedicalRecordRepository({
    required this.medicalRecordDataSource,
  });

  Future<List<Document>> getAll() async {
    try {
      return await medicalRecordDataSource.getAll();
    } catch (error) {
      throw UnknownException();
    }
  }
}
