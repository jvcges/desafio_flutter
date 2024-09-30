part of 'locations_list_bloc.dart';

sealed class LocationsListEvent {}

class GetSavedAddressesList extends LocationsListEvent {}

class SearchCEP extends LocationsListEvent {
  final String searchString;

  SearchCEP({required this.searchString});
}

class ResetLocationsBloc extends LocationsListEvent {}
