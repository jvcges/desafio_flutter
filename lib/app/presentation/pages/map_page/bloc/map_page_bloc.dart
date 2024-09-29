import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

part 'map_page_event.dart';
part 'map_page_state.dart';

class MapPageBloc extends Bloc<MapPageEvent, MapPageState> {
  MapPageBloc()
      : super(
          MapPageLoading(),
        ) {
    on<GetUserLocation>((event, emit) async {
      try {
        emit(MapPageLoading());
        final latlng = await _requestLocationPermission();

        if (latlng == null) {
          emit(MapPageError(
            errorMessage: "Ocorreu um erro ao buscar sua localização atual!",
          ));
          return;
        }

        emit(
          CurrentLocationState(
            mapController: event.mapController,
            currentPosition: latlng,
            mapMarkers: {},
          ),
        );
      } catch (_) {
        emit(MapPageError(
          errorMessage: "Ocorreu um erro ao buscar sua localização atual!",
        ));
      }
    });

    on<SetMapController>((event, emit) {
      final currentState = state;
      if (currentState is CurrentLocationState) {
        emit(CurrentLocationState(
          mapController: event.mapController,
          currentPosition: currentState.currentPosition,
          mapMarkers: currentState.mapMarkers,
        ));

        add(MoveMapCamera(currentState.currentPosition));
      }
    });

    on<MoveMapCamera>((event, emit) {
      final currentState = state;
      if (currentState is CurrentLocationState) {
        final mapController = currentState.mapController;
        mapController?.moveCamera(CameraUpdate.newLatLng(event.position));
        emit(CurrentLocationState(
          mapController: mapController,
          currentPosition: currentState.currentPosition,
          mapMarkers: currentState.mapMarkers,
        ));
      }
    });
  }
}

Future<LatLng?> _requestLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    await Permission.location.request();
  }

  return _getUserLocation();
}

Future<LatLng?> _getUserLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  Position position = await Geolocator.getCurrentPosition(
    locationSettings: locationSettings,
  );

  return LatLng(position.latitude, position.longitude);
}
