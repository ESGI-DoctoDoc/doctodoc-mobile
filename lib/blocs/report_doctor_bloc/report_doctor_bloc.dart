import 'package:bloc/bloc.dart';
import 'package:doctodoc_mobile/services/repositories/report_doctor_repository/report_doctor_repository.dart';
import 'package:meta/meta.dart';

import '../../exceptions/app_exception.dart';

part 'report_doctor_event.dart';
part 'report_doctor_state.dart';

class ReportDoctorBloc extends Bloc<ReportDoctorEvent, ReportDoctorState> {
  final ReportDoctorRepository reportDoctorRepository;

  ReportDoctorBloc({
    required this.reportDoctorRepository,
  }) : super(ReportDoctorState()) {
    on<OnReportDoctor>((event, emit) async {
      try {
        emit(state.copyWith(status: ReportDoctorStatus.loading));
        await reportDoctorRepository.report(event.doctorId, event.explanation);
        emit(state.copyWith(status: ReportDoctorStatus.success));
      } catch (error) {
        emit(state.copyWith(
          status: ReportDoctorStatus.error,
          exception: AppException.from(error),
        ));
      }
    });
  }
}
