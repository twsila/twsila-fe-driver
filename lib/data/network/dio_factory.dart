import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/app_prefs.dart';
import '../../app/constants.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";
const String ACCEPT_LANGUAGE = "Accept-Language";
const String RETRY_COUNTER = "Retry-Count";

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

    // dio.interceptors.add(RetryInterceptor(
    //   dio: dio,
    //   logPrint: print, // specify log function (optional)
    //   retries: 3, // retry count (optional)
    //   retryableExtraStatuses: { 401 },
    //   retryDelays: const [
    //     // set delays between retries (optional)
    //     Duration(seconds: 1), // wait 1 sec before first retry
    //     Duration(seconds: 2), // wait 2 sec before second retry
    //     Duration(seconds: 3), // wait 3 sec before third retry
    //   ],
    // ));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add the access token to the request header
          String token = await _appPreferences.isUserLoggedIn()
              ? "Bearer " + (_appPreferences.getCachedDriver()?.token ?? "")
              : "";
          options.headers[AUTHORIZATION] = token;
          return handler.next(options);
        },
        onError: (DioError error, handler) async {
          if (error.response?.statusCode == 401) {
            // If a 401 response is received, refresh the access token
            if (error.requestOptions.headers[RETRY_COUNTER] == 1) {
              return handler.next(error);
            }
            String newAccessToken = await refreshToken();
            await _appPreferences.setRefreshedToken(newAccessToken);

            // Update the request header with the new access token
            error.requestOptions.headers[AUTHORIZATION] =
                'Bearer $newAccessToken';

            error.requestOptions.headers[RETRY_COUNTER] = 1;

            // Repeat the request with the updated header
            return handler.resolve(await dio.fetch(error.requestOptions));
          }
          return handler.next(error);
        },
      ),
    );

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

  Future<String> refreshToken() async {
    Response response =
        await Dio(BaseOptions(headers: {"Content-Type": "application/json"}))
            .post(Constants.baseUrl + '/refresh-token', data: {
      "mobileNumber": _appPreferences.getCachedDriver()?.mobile ?? ""
    });
    print(response.data["result"]);

    return response.data["result"];
  }
}

// class TokenInterceptor extends Interceptor {
//   final AppPreferences _appPreferences = instance<AppPreferences>();
//
//   @override
//   void onRequest(
//       RequestOptions options, RequestInterceptorHandler handler) async {
//
//     super.onRequest(options, handler);
//   }
//
//   @override
//   Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
//     if (err.response?.statusCode == 401) {
//       // If a 401 response is received, refresh the access token
//       String newAccessToken = await refreshToken();
//
//       // Update the request header with the new access token
//       err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
//
//       // Repeat the request with the updated header
//       return handler.resolve(await dio.fetch(e.requestOptions));
//     }
//     return handler.next(e);
//     super.onError(err, handler);
//   }
// }
