part of 'map_page_bloc.dart';

sealed class MapPageState {}

final class MapPageInitial extends MapPageState {}

final class MapPageLoading extends MapPageState {}

final class CurrentLocationState extends MapPageState {
  final GoogleMapController? mapController;
  final LatLng currentPosition;
  final Set<Marker> mapMarkers;
  final AddressDto? searchedAddress;
  CurrentLocationState({
    required this.mapController,
    required this.currentPosition,
    required this.mapMarkers,
    this.searchedAddress,
  });
}

final class MapPageError extends MapPageState {
  final String errorMessage;
  MapPageError({
    required this.errorMessage,
  });
}

final class SearchingLocationState extends MapPageState {
  final String searchString;
  final bool showFloatingButton;
  final GoogleMapController? mapController;
  final LatLng currentPosition;
  final Set<Marker> mapMarkers;
  SearchingLocationState({
    required this.mapController,
    required this.currentPosition,
    required this.mapMarkers,
    required this.searchString,
    required this.showFloatingButton,
  });
}
