part of 'map_page_bloc.dart';

sealed class MapPageEvent {}

class GetUserLocation extends MapPageEvent {
  final GoogleMapController? mapController;
  final LatLng? currentPosition;

  GetUserLocation({
    this.mapController,
    this.currentPosition,
  });
}

class SetMapController extends MapPageEvent {
  final GoogleMapController mapController;

  SetMapController(this.mapController);
}

class MoveMapCamera extends MapPageEvent {
  final LatLng position;

  MoveMapCamera(this.position);
}

class SearchByCEP extends MapPageEvent {
  final String searchString;

  SearchByCEP(this.searchString);
}
