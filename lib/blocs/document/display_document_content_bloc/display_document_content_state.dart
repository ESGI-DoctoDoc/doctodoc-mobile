part of 'display_document_content_bloc.dart';

// class DisplayDocumentContentState {}

enum DisplayDocumentContentOfMedicalRecordStatus { initial, loading, success, error }

enum DisplayDocumentContentOfCareTrackingStatus { initial, loading, success, error }

class DisplayDocumentContentState {
  final Document? document;
  final DisplayDocumentContentOfMedicalRecordStatus displayDocumentContentOfMedicalRecordStatus;
  final DisplayDocumentContentOfCareTrackingStatus displayDocumentContentOfCareTrackingStatus;
  final AppException? exception;

  DisplayDocumentContentState({
    this.document,
    this.displayDocumentContentOfMedicalRecordStatus =
        DisplayDocumentContentOfMedicalRecordStatus.initial,
    this.displayDocumentContentOfCareTrackingStatus =
        DisplayDocumentContentOfCareTrackingStatus.initial,
    this.exception,
  });

  DisplayDocumentContentState copyWith({
    DisplayDocumentContentOfMedicalRecordStatus? displayDocumentContentOfMedicalRecordStatus,
    DisplayDocumentContentOfCareTrackingStatus? displayDocumentContentOfCareTrackingStatus,
    Document? document,
    AppException? exception,
  }) {
    return DisplayDocumentContentState(
      displayDocumentContentOfMedicalRecordStatus: displayDocumentContentOfMedicalRecordStatus ??
          this.displayDocumentContentOfMedicalRecordStatus,
      displayDocumentContentOfCareTrackingStatus: displayDocumentContentOfCareTrackingStatus ??
          this.displayDocumentContentOfCareTrackingStatus,
      document: document ?? this.document,
      exception: exception ?? this.exception,
    );
  }
}

//
// class DisplayDocumentContentOfCareTrackingState extends DisplayDocumentContentState {
//   final Document? document;
//   final DisplayDocumentContentOfCareTrackingStatus status;
//   final AppException? exception;
//
//   DisplayDocumentContentOfCareTrackingState({
//     this.document,
//     this.status = DisplayDocumentContentOfCareTrackingStatus.initial,
//     this.exception,
//   });
//
//   DisplayDocumentContentOfCareTrackingState copyWith({
//     DisplayDocumentContentOfCareTrackingStatus? status,
//     Document? document,
//     AppException? exception,
//   }) {
//     return DisplayDocumentContentOfCareTrackingState(
//       status: status ?? this.status,
//       document: document ?? this.document,
//       exception: exception ?? this.exception,
//     );
//   }
// }
