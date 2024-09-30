import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/app/domain/usecases/get_address_by_cep/get_address_by_cep_usecase.dart';
import 'package:desafio_flutter/app/domain/usecases/get_saved_addresses/get_saved_addresses_usecase.dart';
import 'package:desafio_flutter/shared/exceptions/custom_exception.dart';
import 'package:desafio_flutter/shared/extensions/e_string.dart';
import 'package:desafio_flutter/shared/loggers/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

part 'map_page_event.dart';
part 'map_page_state.dart';

class MapPageBloc extends Bloc<MapPageEvent, MapPageState> {
  final GetAddressByCepUsecase _getAddressByCepUsecase;
  final GetSavedAddressesUsecase _getSavedAddressesUsecase;
  MapPageBloc(
    this._getAddressByCepUsecase,
    this._getSavedAddressesUsecase,
  ) : super(
          MapPageInitial(addressList: []),
        ) {
    on<GetUserLocation>((event, emit) async {
      if (state is! MapPageInitial) return;
      try {
        emit(MapPageLoading(addressList: state.addressList));
        final latlng = await _requestLocationPermission();

        if (latlng == null) {
          emit(MapPageError(
            addressList: state.addressList,
            errorMessage: "Ocorreu um erro ao buscar sua localização atual!",
          ));
          return;
        }

        emit(
          CurrentLocationState(
            mapController: event.mapController,
            currentPosition: latlng,
            addressList: state.addressList,
            mapMarkers: {},
          ),
        );

        add(GetAddressesList());
      } catch (_) {
        emit(MapPageError(
          addressList: state.addressList,
          errorMessage: "Ocorreu um erro ao buscar sua localização atual!",
        ));
      }
    });

    on<SetMapController>((event, emit) {
      final currentState = state;
      if (currentState is CurrentLocationState) {
        emit(CurrentLocationState(
          addressList: state.addressList,
          mapController: event.mapController,
          currentPosition: currentState.currentPosition,
          mapMarkers: currentState.mapMarkers,
          searchedAddress: currentState.searchedAddress,
        ));

        add(MoveMapCamera(currentState.currentPosition));
      }
    });

    on<MoveMapCamera>((event, emit) async {
      final currentState = state;

      if (currentState is CurrentLocationState) {
        final mapController = currentState.mapController;
        await mapController?.moveCamera(CameraUpdate.newLatLng(event.position));
        emit(CurrentLocationState(
          addressList: state.addressList,
          mapController: mapController,
          currentPosition: currentState.currentPosition,
          mapMarkers: currentState.mapMarkers,
          searchedAddress: currentState.searchedAddress,
        ));
      }
    });

    on<SearchByCEP>((event, emit) {
      final currentState = state;
      final filteredList = state.addressList.where(
        (element) =>
            element.cep != null &&
            element.cep!
                .justNumbers()
                .contains(event.searchString.justNumbers()),
      );
      if (currentState is CurrentLocationState) {
        emit(SearchingLocationState(
          addressList: state.addressList,
          filteredList: filteredList.toList(),
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
            addressList: state.addressList,
            mapController: currentState.mapController,
            currentPosition: currentState.currentPosition,
            mapMarkers: {},
          ));
          return;
        }

        emit(SearchingLocationState(
          filteredList: filteredList.toList(),
          addressList: state.addressList,
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
      List<Location> locations = await locationFromAddress(event.cep);
      final location = locations.first;
      final newPosition = LatLng(
        location.latitude,
        location.longitude,
      );
      if (currentState is SearchingLocationState) {
        final markers = currentState.mapMarkers;
        markers.clear();
        markers.add(
          Marker(
            markerId: const MarkerId('searchedLocation'),
            position: newPosition,
            infoWindow: InfoWindow(
              title: 'CEP: ${event.cep}',
              snippet: 'Localização pesquisada',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );

        try {
          emit(MapPageLoading(
            addressList: state.addressList,
          ));
          final result = await _getAddressByCepUsecase.call(event.cep);
          final address = result?.copyWith(
            latLng: newPosition,
          );
          appLog(result);
          emit(
            CurrentLocationState(
              addressList: state.addressList,
              mapController: null,
              currentPosition: newPosition,
              mapMarkers: markers,
              searchedAddress: address,
              showBottomSheet: true,
            ),
          );
        } on CustomException catch (e) {
          emit(MapPageError(
            errorMessage: e.message ?? 'Ocorreu um erro!',
            addressList: state.addressList,
          ));
        }
      }
    });

    on<GetAddressesList>((event, emit) async {
      final currentState = state;
      if (currentState is! CurrentLocationState) return;
      try {
        final list = await _getSavedAddressesUsecase();
        emit(CurrentLocationState(
          mapController: currentState.mapController,
          currentPosition: currentState.currentPosition,
          mapMarkers: currentState.mapMarkers,
          addressList: list,
        ));
      } catch (_) {}
    });

    on<MoveToSavedAddress>((event, emit) async {
      final currentState = state;
      if (currentState is SearchingLocationState) {
        final markers = currentState.mapMarkers;
        markers.clear();
        markers.add(
          Marker(
            markerId: const MarkerId('searchedLocation'),
            position: event.newPosition,
            infoWindow: InfoWindow(
              title: 'CEP: ${event.cep}',
              snippet: 'Localização pesquisada',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );

        emit(
          CurrentLocationState(
            addressList: state.addressList,
            mapController: null,
            currentPosition: event.newPosition,
            mapMarkers: markers,
          ),
        );
      }
    });

    on<ResetBloc>((event, emit) {
      emit(MapPageInitial(addressList: []));
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
