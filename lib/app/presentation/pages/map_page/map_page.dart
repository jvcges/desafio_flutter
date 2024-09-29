import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  String styleKey = dotenv.env['IOS_MAP_STYLE_KEY'] ?? '';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          cloudMapId: styleKey,
          initialCameraPosition: CameraPosition(
            target: LatLng(-15.7942, -47.8822),
            zoom: 14.0,
          ),
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          myLocationButtonEnabled: false,
        ),
      ],
    );
  }
}
