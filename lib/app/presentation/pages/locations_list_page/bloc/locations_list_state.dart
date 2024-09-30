part of 'locations_list_bloc.dart';

sealed class LocationsListState {
  final List<AddressDto> locationsList;

  LocationsListState({required this.locationsList});
}

final class LocationsListInitial extends LocationsListState {
  LocationsListInitial({required super.locationsList});
}

final class LocationsLoaded extends LocationsListState {
  final List<AddressDto> filteredList;
  LocationsLoaded({
    required this.filteredList,
    required super.locationsList,
  });
}

final class LocationsListLoading extends LocationsListState {
  LocationsListLoading({required super.locationsList});
}

final class LocationsListError extends LocationsListState {
  final String errorMessage;
  LocationsListError({
    required super.locationsList,
    required this.errorMessage,
  });
}
