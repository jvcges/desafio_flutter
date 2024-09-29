import 'package:desafio_flutter/app/presentation/components/app_search_bar.dart';
import 'package:desafio_flutter/app/presentation/pages/map_page/bloc/map_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String styleKey = dotenv.env['IOS_MAP_STYLE_KEY'] ?? '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mapBloc = context.read<MapPageBloc>();
      mapBloc.add(GetUserLocation());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = context.read<MapPageBloc>();
    return BlocBuilder<MapPageBloc, MapPageState>(
      builder: (context, state) {
        if (state is MapPageLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is MapPageError) {
          return Center(
            child: Text(state.errorMessage),
          );
        }
        if (state is CurrentLocationState) {
          return Stack(
            children: [
              GoogleMap(
                cloudMapId: styleKey,
                initialCameraPosition: CameraPosition(
                  target: state.currentPosition,
                  zoom: 17.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  mapBloc.add(SetMapController(controller));
                },
                myLocationButtonEnabled: false,
                markers: state.mapMarkers,
                myLocationEnabled: true,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SafeArea(
                  child: AppSearchBar(
                    searchFunction: (value) {},
                    textController: TextEditingController(),
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
