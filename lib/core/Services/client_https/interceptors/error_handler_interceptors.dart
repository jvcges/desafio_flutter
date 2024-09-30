import 'package:dio/dio.dart';

class ErrorsHandleInterceptors extends InterceptorsWrapper {
  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    bool isStatusSuccess = response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! <= 299;

    if (isStatusSuccess) return handler.next(response);

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.unknown,
    );
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final error = DioException(
      error: err.message,
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
    );

    handler.next(error);
  }
}
