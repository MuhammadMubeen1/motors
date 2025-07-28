import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:motors_app/core/constants/preferences_name.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  static const encoder = JsonEncoder.withIndent('\t');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    String? apiToken = preferences.getString(PreferencesName.apiToken);

    if (apiToken != null && apiToken.isNotEmpty) {
      // options.headers.addAll({'token': PreferencesName.apiToken});
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data.runtimeType == ResponseBody) {
      logger.i('''RESPONSE: ''');
    } else {
      logger.i('''RESPONSE:
      URL: ${response.requestOptions.uri}
      Method: ${response.requestOptions.method}
      Headers: ${encoder.convert(response.requestOptions.headers)}
      Data: ${encoder.convert(response.data)}
      ''');
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response != null && err.response?.statusCode != null && err.response?.statusCode == 401) {}
    return handler.next(err);
  }
}
