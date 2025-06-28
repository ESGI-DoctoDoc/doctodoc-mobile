import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/exceptions/app_exception.dart';
import 'package:doctodoc_mobile/models/care_tracking.dart';
import 'package:doctodoc_mobile/services/repositories/care_tracking_repository/care_tracking_repository.dart';
import 'package:meta/meta.dart';

part 'care_tracking_detail_event.dart';
part 'care_tracking_detail_state.dart';

class CareTrackingDetailBloc extends Bloc<CareTrackingDetailEvent, CareTrackingDetailState> {
  final CareTrackingRepository careTrackingRepository;

  CareTrackingDetailBloc({
    required this.careTrackingRepository,
  }) : super(CareTrackingDetailInitial()) {
    on<OnGetCareTrackingDetail>((event, emit) async {
      try {
        emit(CareTrackingDetailLoading());
        CareTrackingDetailed careTrackingDetailed = await careTrackingRepository.getById(event.id);
        emit(CareTrackingDetailLoaded(careTracking: careTrackingDetailed));
      } catch (error) {
        emit(CareTrackingDetailError(exception: AppException.from(error)));
      }
    });
  }
}
