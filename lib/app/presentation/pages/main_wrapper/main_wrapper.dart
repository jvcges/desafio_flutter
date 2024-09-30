import 'package:desafio_flutter/app/presentation/components/app_bottom_navigation_bar.dart';
import 'package:desafio_flutter/app/presentation/pages/locations_list_page/locations_list_page.dart';
import 'package:desafio_flutter/app/presentation/pages/main_wrapper/bloc/main_wrapper_bloc.dart';
import 'package:desafio_flutter/app/presentation/pages/map_page/bloc/map_page_bloc.dart';
import 'package:desafio_flutter/app/presentation/pages/map_page/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  List<Widget> pagesList = const [
    MapPage(),
    LocationsListPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => Modular.get<MainWrapperBloc>(),
        ),
        BlocProvider(
          create: (context) => Modular.get<MapPageBloc>(),
        ),
      ],
      child: BlocSelector<MainWrapperBloc, MainWrapperState, int>(
        selector: (state) => state.index,
        builder: (context, state) {
          final wrapperBloc = Modular.get<MainWrapperBloc>();
          return Material(
            child: Column(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: pagesList[state],
                  ),
                ),
                AppBottomNavigationBar(
                  onTapIndex: (value) {
                    wrapperBloc.add(ChangePage(index: value));
                  },
                  currentIndex: state,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
