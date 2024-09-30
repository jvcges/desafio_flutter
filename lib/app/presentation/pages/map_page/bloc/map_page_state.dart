part of 'map_page_bloc.dart';

sealed class MapPageState {
  final List<AddressDto> addressList;

  MapPageState({required this.addressList});
}

final class MapPageInitial extends MapPageState {
  MapPageInitial({required super.addressList});
}

final class MapPageLoading extends MapPageState {
  MapPageLoading({required super.addressList});
}

final class CurrentLocationState extends MapPageState {
  final GoogleMapController? mapController;
  final LatLng currentPosition;
  final Set<Marker> mapMarkers;
  final AddressDto? searchedAddress;
  final bool showBottomSheet;
  CurrentLocationState({
    required this.mapController,
    required this.currentPosition,
    required this.mapMarkers,
    this.searchedAddress,
    this.showBottomSheet = false,
    required super.addressList,
  });
}

final class MapPageError extends MapPageState {
  final String errorMessage;
  MapPageError({
    required this.errorMessage,
    required super.addressList,
  });
}

final class SearchingLocationState extends MapPageState {
  final String searchString;
  final bool showFloatingButton;
  final GoogleMapController? mapController;
  final LatLng currentPosition;
  final Set<Marker> mapMarkers;
  final List<AddressDto> filteredList;
  SearchingLocationState({
    required this.mapController,
    required this.currentPosition,
    required this.mapMarkers,
    required this.searchString,
    required this.showFloatingButton,
    required super.addressList,
    required this.filteredList,
  });
}
