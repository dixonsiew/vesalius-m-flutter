import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';

class ApiHelper {
  
  static final Dio _dio = Dio(BaseOptions(connectTimeout: 5000, receiveTimeout: 15000));
  static final Dio _tokenDio = Dio(BaseOptions(connectTimeout: 5000, receiveTimeout: 15000));

  static Dio get dio {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
      return null;
    };
    return _dio;
  }

  static Dio get tokenDioInterceptor {
    (_tokenDio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
      return null;
    };
    _tokenDio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        options.headers['Authorization'] = 'Bearer ${AuthManager.token}';
        return handler.next(options);
      },
      onResponse:(Response response, ResponseInterceptorHandler handler) async {
        return handler.next(response); // continue
      },
      onError: (DioError e, ErrorInterceptorHandler handler) async {
        return handler.next(e);//continue
      }
    ));
    return _tokenDio;
  }
}
