part of 'save_location_bloc.dart';

sealed class SaveLocationEvent {}

class SaveNewLocation extends SaveLocationEvent {
  final AddressDto newLocation;

  SaveNewLocation(this.newLocation);
}
