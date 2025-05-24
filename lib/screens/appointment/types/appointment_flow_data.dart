import 'package:doctodoc_mobile/screens/appointment/types/appointment_flow_answer_data.dart';
import 'package:doctodoc_mobile/screens/appointment/types/appointment_flow_doctor_data.dart';
import 'package:doctodoc_mobile/screens/appointment/types/appointment_flow_patient_data.dart';
import 'package:doctodoc_mobile/screens/appointment/types/appointment_flow_slot_data.dart';

class AppointmentFlowData {
  AppointmentFlowDoctorData? doctorData;
  AppointmentFlowPatientData? patientData;
  String? medicalConcernId;
  String? careTrackingId;
  AppointmentFlowSlotData? slotData;
  List<AppointmentFlowAnswerData> answers = [];

  AppointmentFlowDataReview toReview() {
    return AppointmentFlowDataReview(
      doctorData: doctorData!,
      patientData: patientData!,
      medicalConcernId: medicalConcernId,
      careTrackingId: careTrackingId,
      slotData: slotData!,
      answers: answers,
    );
  }
}

class AppointmentFlowDataReview {
  final AppointmentFlowDoctorData doctorData;
  final AppointmentFlowPatientData patientData;
  final String? medicalConcernId;
  final String? careTrackingId;
  final AppointmentFlowSlotData slotData;
  final List<AppointmentFlowAnswerData> answers;

  const AppointmentFlowDataReview({
    required this.doctorData,
    required this.patientData,
    this.medicalConcernId,
    this.careTrackingId,
    required this.slotData,
    required this.answers,
  });
}