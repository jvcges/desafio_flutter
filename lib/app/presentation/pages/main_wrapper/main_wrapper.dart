import 'package:desafio_flutter/app/presentation/pages/locations_list_page/locations_list_page.dart';
import 'package:desafio_flutter/app/presentation/pages/main_wrapper/bloc/main_wrapper_bloc.dart';
import 'package:desafio_flutter/app/presentation/pages/map_page/map_page.dart';
import 'package:desafio_flutter/main.dart';
import 'package:desafio_flutter/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  @override
  Widget build(BuildContext context) {
    final wrapperBloc = context.read<MainWrapperBloc>();

    return BlocSelector<MainWrapperBloc, MainWrapperState, int>(
      selector: (state) => state.index,
      builder: (context, state) {
        return Scaffold(
          body: state == 0 ? MapScreen() : const LocationsListPage(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state,
            onTap: (value) {
              wrapperBloc.add(ChangePage(index: value));
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), label: 'Locations'),
            ],
          ),
        );
      },
    );
  }
}
