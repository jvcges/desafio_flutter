import 'package:desafio_flutter/core/Theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Modular.setObservers([RouteObserver<ModalRoute<void>>()]);
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationParser: Modular.routeInformationParser,
        routerDelegate: Modular.routerDelegate,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          progressIndicatorTheme: ProgressIndicatorThemeData(
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
