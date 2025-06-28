import 'dart:async';

import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/care_tracking.dart';
import 'package:doctodoc_mobile/services/data_sources/care_tracking_data_source/care_tracking_data_source.dart';

class CareTrackingRepository {
  final CareTrackingDataSource careTrackingDataSource;

  CareTrackingRepository({
    required this.careTrackingDataSource,
  });

  Future<List<CareTracking>> getAll(int page) async {
    try {
      return await careTrackingDataSource.getAll(page);
    } catch (error) {
      throw UnknownException();
    }
  }
}
