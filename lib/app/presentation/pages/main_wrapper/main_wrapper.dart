import 'package:desafio_flutter/app/presentation/components/custom_bottom_navigation_bar.dart';
import 'package:desafio_flutter/app/presentation/pages/locations_list_page/locations_list_page.dart';
import 'package:desafio_flutter/app/presentation/pages/main_wrapper/bloc/main_wrapper_bloc.dart';
import 'package:desafio_flutter/app/presentation/pages/map_page/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final wrapperBloc = context.read<MainWrapperBloc>();

    return BlocSelector<MainWrapperBloc, MainWrapperState, int>(
      selector: (state) => state.index,
      builder: (context, state) {
        return Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: pagesList[state],
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            onTapIndex: (value) {
              wrapperBloc.add(ChangePage(index: value));
            },
            currentIndex: state,
          ),
        );
      },
    );
  }
}
