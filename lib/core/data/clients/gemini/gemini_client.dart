import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/app_config.dart';

@injectable
class GeminiClient {
  final Dio _dio;

  GeminiClient({required Dio dio}) : _dio = dio {
    _dio.options.baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
    _dio.options.headers['x-goog-api-key'] = AppConfig.geminiApiKey;
  }

  Future<Response<T>> post<T>(String path, {Map<String, dynamic>? data}) {
    return _dio.post<T>(path, data: data);
  }

  /// Sends a POST request and returns the response body as a stream of lines.
  ///
  /// Gemini streaming API returns data as a Server Sent Event (SSE) where each
  /// event is separated by a new line. To properly handle this format the raw
  /// byte stream is first decoded using UTF-8 and then split into individual
  /// lines.
  Stream<String> postStream(String path, {Map<String, dynamic>? data}) async* {
    final response = await _dio.post<ResponseBody>(
      path,
      data: data,
      options: Options(responseType: ResponseType.stream),
    );

    final stream = response.data?.stream;
    if (stream == null) return;

    // Decode the UTF-8 bytes and split into lines for SSE parsing.
    yield* utf8.decoder.bind(stream).transform(const LineSplitter());
  }
}
