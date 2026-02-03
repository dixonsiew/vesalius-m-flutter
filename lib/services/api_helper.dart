import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';

class ApiHelper {
  
  static final Dio _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5), receiveTimeout: const Duration(seconds: 15), contentType: Headers.jsonContentType));
  static final Dio _tokenDio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5), receiveTimeout: const Duration(seconds: 15), contentType: Headers.jsonContentType));

  static Dio get dio {
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
      return client;
    };
    return _dio;
  }

  static Dio get tokenDioInterceptor {
    (_tokenDio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      HttpClient client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
      return client;
    };
    _tokenDio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        options.headers['Authorization'] = 'Bearer ${AuthManager.token}';
        return handler.next(options);
      },
      onResponse:(Response response, ResponseInterceptorHandler handler) async {
        return handler.next(response); // continue
      },
      onError: (DioException e, ErrorInterceptorHandler handler) async {
        return handler.next(e);//continue
      }
    ));
    return _tokenDio;
  }
}
