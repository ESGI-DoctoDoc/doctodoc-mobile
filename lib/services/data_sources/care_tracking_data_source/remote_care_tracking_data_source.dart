import 'package:dio/dio.dart';
import 'package:doctodoc_mobile/models/care_tracking.dart';

import 'care_tracking_data_source.dart';

class RemoteCareTrackingDataSource implements CareTrackingDataSource {
  final Dio dio;

  RemoteCareTrackingDataSource({required this.dio});

  @override
  Future<List<CareTracking>> getAll(int page) async {
    int defaultSize = 10;
    final response = await dio.get("/patients/care-trackings?page=$page&size=$defaultSize");

    final jsonList = (response.data["data"] as List?) ?? [];
    return jsonList.map((jsonElement) => CareTracking.fromJson(jsonElement)).toList();
  }

  @override
  Future<CareTrackingDetailed> getById(String id) async {
    final response = await dio.get("/patients/care-trackings/$id");
    return CareTrackingDetailed.fromJson(response.data["data"]);
  }
}
