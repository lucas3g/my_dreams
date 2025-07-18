import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/constants/constants.dart';

@injectable
class GeminiClient {
  final Dio _dio;

  GeminiClient({required Dio dio}) : _dio = dio {
    _dio.options.baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
    _dio.options.headers['x-goog-api-key'] = GEMINI_API_KEY;
  }

  Future<Response<T>> post<T>(String path, {Map<String, dynamic>? data}) {
    return _dio.post<T>(path, data: data);
  }

  Stream<String> postStream(String path, {Map<String, dynamic>? data}) async* {
    final response = await _dio.post<ResponseBody>(
      path,
      data: data,
      options: Options(responseType: ResponseType.stream),
    );

    final stream = response.data?.stream;
    if (stream == null) return;

    // Aqui está a mudança: decodificação segura da stream UTF-8
    yield* utf8.decoder.bind(stream);
  }
}
