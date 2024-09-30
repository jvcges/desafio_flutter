import 'package:desafio_flutter/core/start/app_module.dart';
import 'package:desafio_flutter/core/start/app_root.dart';
import 'package:desafio_flutter/core/start/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await AppSettings.init(module: AppModule());
  const app = AppRoot();
  runApp(app);
}
