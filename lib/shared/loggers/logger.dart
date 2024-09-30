import 'dart:developer';

import 'package:flutter/foundation.dart';

//Criado para debugar e evitar prints em códigos de produção
void appLog(
  Object? object, {
  String? name,
  StackTrace? stackTrace,
  Object? error,
}) {
  if (kDebugMode) {
    log(
      '$object',
      error: error,
      name: name ?? '',
      stackTrace: stackTrace,
    );
  }
}
