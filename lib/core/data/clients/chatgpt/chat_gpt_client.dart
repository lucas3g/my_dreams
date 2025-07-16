import 'package:dio/dio.dart';
import '../../constants/constants.dart';

class ChatGptClient {
  final Dio _dio;

  ChatGptClient({required Dio dio}) : _dio = dio {
    _dio.options.baseUrl = 'https://api.openai.com/v1';
    _dio.options.headers['Authorization'] = 'Bearer $CHATGPT_API_KEY';
  }

  Future<Response<T>> post<T>(String path, {Map<String, dynamic>? data}) {
    return _dio.post<T>(path, data: data);
  }
}
