import 'package:desafio_flutter/app/presentation/components/app_search_bar.dart';
import 'package:desafio_flutter/app/presentation/pages/map_page/bloc/map_page_bloc.dart';
import 'package:desafio_flutter/core/Theme/app_colors.dart';
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
  final _searchController = TextEditingController();

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
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return BlocBuilder<MapPageBloc, MapPageState>(
      builder: (context, state) {
        if (state is MapPageLoading || state is MapPageInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is MapPageError) {
          return Center(
            child: Text(state.errorMessage),
          );
        }
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.white,
              ),
            ),
            if (state is CurrentLocationState)
              GoogleMap(
                cloudMapId: styleKey,
                initialCameraPosition: CameraPosition(
                  target: state.currentPosition,
                  zoom: 17.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  if (state.mapController == null) {
                    mapBloc.add(SetMapController(controller));
                  }
                },
                myLocationButtonEnabled: false,
                markers: state.mapMarkers,
                myLocationEnabled: true,
                onTap: (value) {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  }
                },
              ),
            if (state is SearchingLocationState) ...[
              Container(),
              if (state.showFloatingButton)
                Positioned(
                  bottom: bottomPadding > kBottomNavigationBarHeight
                      ? bottomPadding - kBottomNavigationBarHeight
                      : 0,
                  right: 20,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                )
            ],
            Padding(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: AppSearchBar(
                  searchFunction: (value) {
                    mapBloc.add(SearchByCEP(value));
                  },
                  textController: _searchController,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
