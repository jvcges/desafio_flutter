part of 'map_page_bloc.dart';

sealed class MapPageState {}

final class MapPageLoading extends MapPageState {}

final class CurrentLocationState extends MapPageState {
  final GoogleMapController? mapController;
  final LatLng currentPosition;
  final Set<Marker> mapMarkers;
  CurrentLocationState({
    required this.mapController,
    required this.currentPosition,
    required this.mapMarkers,
  });
}

final class MapPageError extends MapPageState {
  final String errorMessage;
  MapPageError({
    required this.errorMessage,
  });
}
