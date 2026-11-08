import 'package:dio/dio.dart';

class HttpClient {
  HttpClient._();

  static Dio create() {
    return Dio(
      BaseOptions(
        baseUrl: 'https://viacep.com.br/ws',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );
  }
}
