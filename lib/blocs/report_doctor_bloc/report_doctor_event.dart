part of 'report_doctor_bloc.dart';

@immutable
sealed class ReportDoctorEvent {}

class OnReportDoctor extends ReportDoctorEvent {
  final String doctorId;
  final String explanation;

  OnReportDoctor({
    required this.doctorId,
    required this.explanation,
  });
}
