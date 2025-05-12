import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'data_sources/local_auth_data_source/local_auth_data_source.dart';

class DioClient {
  final Dio _dio = Dio();

  final LocalAuthDataSource localAuthDataSource;

  DioClient({required this.localAuthDataSource}) {
    _dio.options.baseUrl = dotenv.env['BASE_URL_API'] ?? '';
    _dio.options.headers = {
      "Content-Type": "application/json",
    };

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await localAuthDataSource.retrieveToken();

        if (token != null) {
          options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
        }

        String method = options.method;
        String url = options.path;
        String query = options.queryParameters.isEmpty
            ? ''
            : '?${options.queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&')}';
        String payload = options.data != null ? options.data.toString() : '';

        print("[$method] $url$query -- with payload = $payload");
        return handler.next(options);
      },
      onResponse: (options, handler) {
        String method = options.requestOptions.method;
        String url = options.requestOptions.path;
        String query = options.requestOptions.queryParameters.isEmpty
            ? ''
            : '?${options.requestOptions.queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&')}';
        String payload = options.data != null ? options.data.toString() : '';

        print("[$method] $url$query -- with payload = $payload");
        return handler.next(options);
      },
    ));
  }

  Dio get dio => _dio;
}
