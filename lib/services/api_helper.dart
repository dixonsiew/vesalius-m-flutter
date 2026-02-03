import 'package:dio/dio.dart';
import 'package:vesalius_m_flutter/models/auth_manager.dart';

class ApiHelper {
  
  static final Dio _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 30), receiveTimeout: const Duration(seconds: 55)));
  static final Dio _tokenDio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 30), receiveTimeout: const Duration(seconds: 55)));

  static Dio get dio {
    // (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
    //   client.badCertificateCallback = (X509Certificate cert, String host, int port) {
    //     return true;
    //   };
    // };
    return _dio;
  }

  static Dio get tokenDioInterceptor {
    // (_tokenDio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
    //   client.badCertificateCallback = (X509Certificate cert, String host, int port) {
    //     return true;
    //   };
    // };
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
