import 'package:doctodoc_mobile/models/appointment/medical_concern.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern_appointment_availability.dart';
import 'package:doctodoc_mobile/models/appointment/medical_concern_questions.dart';

import '../../../models/appointment/care_tracking_for_appointment.dart';

abstract class AppointmentFlowDataSource {
  Future<List<MedicalConcern>> getMedicalConcernsByDoctorId(String doctorId);

  Future<List<MedicalConcernQuestion>> getQuestionsByMedicalConcernId(String medicalConcernId);

  Future<List<MedicalConcernAppointmentAvailability>>
      getAppointmentsAvailabilityByMedicalConcernIdAndDate(String medicalConcernId, String date);

  Future<List<CareTrackingForAppointment>> getCareTrackings();
}
