import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/constants/constants.dart';

@injectable
class GeminiClient {
  final Dio _dio;

  GeminiClient({required Dio dio}) : _dio = dio {
    _dio.options.baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
    _dio.options.headers['X-Goog-Api-Key'] = GEMINI_API_KEY;
  }

  Future<Response<T>> post<T>(String path, {Map<String, dynamic>? data}) {
    return _dio.post<T>(path, data: data);
  }
}
