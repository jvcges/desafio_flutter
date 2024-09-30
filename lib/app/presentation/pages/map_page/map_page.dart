import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:desafio_flutter/app/presentation/components/app_search_bar.dart';
import 'package:desafio_flutter/app/presentation/pages/map_page/bloc/map_page_bloc.dart';
import 'package:desafio_flutter/app/presentation/pages/map_page/components/save_address_bottom_sheet.dart';
import 'package:desafio_flutter/core/Theme/app_colors.dart';

class MapPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const MapPage({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String styleKey = Platform.isAndroid
      ? dotenv.env['ANDROID_MAP_STYLE_KEY'] ?? ''
      : dotenv.env['IOS_MAP_STYLE_KEY'] ?? '';
  final _searchController = TextEditingController();
  final mapBloc = Modular.get<MapPageBloc>();

  @override
  void initState() {
    mapBloc.add(GetUserLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    PersistentBottomSheetController? bottomSheetController;
    return BlocConsumer<MapPageBloc, MapPageState>(
      listener: (context, state) {
        if (state is CurrentLocationState && state.showBottomSheet) {
          bottomSheetController =
              widget.scaffoldKey.currentState?.showBottomSheet(
            (_) => SaveAddressBottomSheet(
              cep: state.searchedAddress?.cep ?? '',
              address: state.searchedAddress?.address ?? '',
              latLng: state.searchedAddress?.latLng,
              onAddressSaved: () {},
            ),
          );
        }
      },
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
                  zoom: 18.0,
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
              if (state.showFloatingButton)
                Scaffold(
                  resizeToAvoidBottomInset: false,
                  floatingActionButton: Padding(
                    padding: EdgeInsets.only(
                      bottom: bottomPadding / 2,
                    ),
                    child: Material(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(9999),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(9999),
                        onTap: () {
                          mapBloc.add(
                            GetAddressByCep(
                              state.searchString,
                            ),
                          );
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
            Padding(
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  children: [
                    AppSearchBar(
                      searchFunction: (value) {
                        mapBloc.add(SearchByCEP(value));
                      },
                      onTap: () {
                        if (bottomSheetController != null) {
                          bottomSheetController!.close();
                        }
                      },
                      textController: _searchController,
                    ),
                    if (state is SearchingLocationState) ...[
//TODO - colocar lista com os listtiles
                    ]
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
