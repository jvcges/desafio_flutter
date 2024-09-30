import 'package:desafio_flutter/app/presentation/components/app_search_bar.dart';
import 'package:desafio_flutter/app/presentation/pages/locations_list_page/bloc/locations_list_bloc.dart';
import 'package:desafio_flutter/core/routes/app_routes.dart';
import 'package:desafio_flutter/shared/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

class LocationsListPage extends StatefulWidget {
  const LocationsListPage({super.key});

  @override
  State<LocationsListPage> createState() => _LocationsListPageState();
}

class _LocationsListPageState extends State<LocationsListPage> {
  final _searchController = TextEditingController();
  final _locationsBloc = Modular.get<LocationsListBloc>();

  @override
  void initState() {
    _locationsBloc.add(GetSavedAddressesList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationsListBloc, LocationsListState>(
      listener: (context, state) {
        if (state is LocationsListError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
            ),
          );
        }

        if (state is LocationsListInitial) {
          _locationsBloc.add(GetSavedAddressesList());
        }
      },
      builder: (context, state) {
        if (state is LocationsListLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppSearchBar(
                    searchFunction: (value) {
                      _locationsBloc.add(SearchCEP(searchString: value));
                    },
                    textController: _searchController,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        if (state is LocationsLoaded)
                          ...state.filteredList.map(
                            (e) => Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  AppRouters.goToSaveLocationPage(
                                    e,
                                    isEditing: true,
                                  );
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      trailing: SvgPicture.asset(
                                        AppIcons.bookMark,
                                      ),
                                      title: Text(
                                        e.cep ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Color(0xFF141514),
                                        ),
                                      ),
                                      subtitle: Text(
                                        e.address ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: 0.25,
                                          color: Color(0xFF49454F),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      minTileHeight: 76,
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
