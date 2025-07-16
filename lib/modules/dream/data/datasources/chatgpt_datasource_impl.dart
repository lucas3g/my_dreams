import 'package:dio/dio.dart';
import 'package:my_dreams/core/data/clients/chatgpt/chat_gpt_client.dart';

import 'chatgpt_datasource.dart';

class ChatGptDatasourceImpl implements ChatGptDatasource {
  final ChatGptClient _client;

  ChatGptDatasourceImpl({required ChatGptClient client}) : _client = client;

  @override
  Future<String> getMeaning(String dreamText) async {
    final Response<Map<String, dynamic>> response = await _client.post(
      '/chat/completions',
      data: {
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'user', 'content': dreamText}
        ],
      },
    );

    return response.data?['choices'][0]['message']['content'] as String? ?? '';
  }
}
