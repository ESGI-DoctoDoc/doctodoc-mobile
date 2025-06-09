part of 'display_specialities_bloc.dart';

enum DisplaySpecialitiesStatus { initial, loading, success, error }

class DisplaySpecialitiesState {
  final DisplaySpecialitiesStatus status;
  final List<Speciality> specialities;
  final AppException? exception;

  DisplaySpecialitiesState({
    this.status = DisplaySpecialitiesStatus.initial,
    this.specialities = const [],
    this.exception,
  });

  DisplaySpecialitiesState copyWith({
    DisplaySpecialitiesStatus? status,
    List<Speciality>? specialities,
    AppException? exception,
  }) {
    return DisplaySpecialitiesState(
      specialities: specialities ?? this.specialities,
      status: status ?? this.status,
      exception: exception ?? this.exception,
    );
  }
}
