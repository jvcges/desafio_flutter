import 'package:desafio_flutter/app/presentation/pages/main_wrapper/bloc/main_wrapper_bloc.dart';
import 'package:desafio_flutter/app/presentation/pages/main_wrapper/main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MainWrapperBloc(),
          ),
        ],
        child: const MainWrapper(),
      ),
    );
  }
}
