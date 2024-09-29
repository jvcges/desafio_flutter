import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng _initialPosition = LatLng(-15.7942, -47.8822); // Coordenadas padrão
  String styleKey = dotenv.env['IOS_MAP_STYLE_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  // Solicitar permissão de localização
  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }

    _getUserLocation();
  }

  // Obter a localização atual do dispositivo
  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return; // Localização desativada
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Obtenha a localização
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });

    _mapController?.moveCamera(
      CameraUpdate.newLatLng(_initialPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          cloudMapId: styleKey,
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 14.0,
          ),
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          myLocationButtonEnabled: false,
        ),
        Positioned(
          top: 50,
          left: 15,
          right: 15,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  spreadRadius: 0.5,
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15.0),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) {
                _searchByCep(value);
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _searchByCep(String cep) async {
    try {
      // Aqui você pode usar o plugin geocoding para buscar as coordenadas pelo CEP
      List<Location> locations = await locationFromAddress(cep);

      if (locations.isNotEmpty) {
        final location = locations.first;
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(location.latitude, location.longitude),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
