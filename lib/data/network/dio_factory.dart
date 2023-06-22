import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';

import '../../app/app_prefs.dart';
import '../../app/constants.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";
const String ACCEPT_LANGUAGE = "Accept-Language";

class DioFactory {
  final AppPreferences _appPreferences;

  DioFactory(this._appPreferences);

  Future<Dio> getDio() async {
    Dio dio = Dio();

    String language = await _appPreferences.getAppLanguage();
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: await _appPreferences.isUserLoggedIn()
          ? "Bearer " + (_appPreferences.getCachedDriver()?.token ?? "")
          : "",
      ACCEPT_LANGUAGE: language
    };

    dio.options = BaseOptions(
        baseUrl: Constants.baseUrl,
        headers: headers,
        receiveTimeout: Constants.apiTimeOut,
        sendTimeout: Constants.apiTimeOut);

    dio.interceptors.add(TokenInterceptor());

    if (!kReleaseMode) {
      // its debug mode so print app logs
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    return dio;
  }
}

class TokenInterceptor extends Interceptor {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String token = await  _appPreferences.isUserLoggedIn()
        ? "Bearer " + (_appPreferences.getCachedDriver()?.token ?? "")
        : "";
    options.headers[AUTHORIZATION] = token;
    super.onRequest(options, handler);
  }
}
