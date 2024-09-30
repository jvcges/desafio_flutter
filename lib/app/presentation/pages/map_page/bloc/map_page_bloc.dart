import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/app/domain/usecases/get_address_by_cep/get_address_by_cep_usecase.dart';
import 'package:desafio_flutter/shared/exceptions/custom_exception.dart';
import 'package:desafio_flutter/shared/extensions/e_string.dart';
import 'package:desafio_flutter/shared/loggers/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

part 'map_page_event.dart';
part 'map_page_state.dart';

class MapPageBloc extends Bloc<MapPageEvent, MapPageState> {
  final GetAddressByCepUsecase _getAddressByCepUsecase;
  MapPageBloc(this._getAddressByCepUsecase)
      : super(
          MapPageInitial(),
        ) {
    on<GetUserLocation>((event, emit) async {
      if (state is! MapPageInitial) return;
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

    on<SearchByCEP>((event, emit) {
      final currentState = state;
      if (currentState is CurrentLocationState) {
        emit(SearchingLocationState(
          searchString: event.searchString,
          showFloatingButton: false,
          mapController: currentState.mapController,
          currentPosition: currentState.currentPosition,
          mapMarkers: currentState.mapMarkers,
        ));
        return;
      }

      if (currentState is SearchingLocationState) {
        if (event.searchString.isEmpty) {
          emit(CurrentLocationState(
            mapController: currentState.mapController,
            currentPosition: currentState.currentPosition,
            mapMarkers: currentState.mapMarkers,
          ));
          return;
        }

        emit(SearchingLocationState(
          searchString: event.searchString,
          showFloatingButton:
              event.searchString.justNumbers().length == 8 ? true : false,
          mapController: currentState.mapController,
          currentPosition: currentState.currentPosition,
          mapMarkers: currentState.mapMarkers,
        ));
      }
    });

    on<GetAddressByCep>((event, emit) async {
      final currentState = state;
      if (currentState is SearchingLocationState) {
        try {
          emit(MapPageLoading());
          final result = await _getAddressByCepUsecase.call(event.cep);
          appLog(result);
          emit(
            CurrentLocationState(
              mapController: currentState.mapController,
              currentPosition: currentState.currentPosition,
              mapMarkers: currentState.mapMarkers,
              searchedAddress: result,
            ),
          );
        } on CustomException catch (e) {
          emit(MapPageError(errorMessage: e.message ?? 'Ocorreu um erro!'));
        }
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
