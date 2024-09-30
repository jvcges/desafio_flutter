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

class GetAddressByCep extends MapPageEvent {
  final String cep;

  GetAddressByCep(this.cep);
}

class ResetBloc extends MapPageEvent {}

class GetAddressesList extends MapPageEvent {}

class MoveToSavedAddress extends MapPageEvent {
  final LatLng newPosition;
  final String cep;

  MoveToSavedAddress(
    this.newPosition,
    this.cep,
  );
}
