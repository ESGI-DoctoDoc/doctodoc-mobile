import 'package:doctodoc_mobile/models/care_tracking.dart';

abstract class CareTrackingDataSource {
  Future<List<CareTracking>> getAll(int page);

  Future<CareTrackingDetailed> getById(String id);
}
