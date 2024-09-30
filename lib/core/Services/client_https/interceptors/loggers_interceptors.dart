import 'dart:convert';

import 'package:desafio_flutter/shared/loggers/logger.dart';
import 'package:dio/dio.dart';

//Criado para ajudar no desenvolvimento e debug, fica mais fácil de visualizar no console cada chamada sendo realizada e seu respectivo retorno.
//Só aparece em debug mode
class LoggersInterceptors extends InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log(
      tag: 'ERROR',
      message: err.error?.toString(),
    );
    _log(
      tag: 'ERROR',
      message: err.message.toString(),
    );
    _log(
      tag: 'ERROR',
      message: err.response?.data?.toString() ??
          err.response?.statusMessage ??
          'ERRO NÃO IDENTIFICADO',
    );

    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log(
      tag: 'RESPONSE',
      message: (response.statusCode ?? 500).toString(),
    );
    if (response.data != null) {
      _log(
        tag: 'RESPONSE',
        message: response.requestOptions.path.contains("get-file")
            ? response.data.toString().substring(0, 300)
            : response.data.toString(),
      );
    }

    return handler.next(response);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _log(
      tag: 'REQUEST',
      message: options.method,
    );
    _log(
      tag: 'REQUEST',
      message: "${options.baseUrl}${options.path}",
    );
    if (options.queryParameters.isNotEmpty) {
      _log(
        tag: 'REQUEST',
        message: "Query: ${options.queryParameters}",
      );
    }
    if (options.data != null) {
      _log(
        tag: 'REQUEST',
        message: options.data is FormData
            ? options.data.files.first.value.filename
            : jsonEncode(options.data),
      );
    }

    super.onRequest(options, handler);
  }

  _log({String? tag, String? message}) => appLog(
        message ?? '',
        name: tag?.toUpperCase() ?? ' ',
      );
}
