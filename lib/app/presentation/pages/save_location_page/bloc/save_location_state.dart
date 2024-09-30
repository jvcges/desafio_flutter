part of 'save_location_bloc.dart';

sealed class SaveLocationState {}

final class SaveLocationInitial extends SaveLocationState {}

final class SaveLocationLoading extends SaveLocationState {}

final class SaveLocationSuccess extends SaveLocationState {}

final class SaveLocationError extends SaveLocationState {
  final String errorMessage;

  SaveLocationError(this.errorMessage);
}
