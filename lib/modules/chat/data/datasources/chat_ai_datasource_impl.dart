import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/data/clients/gemini/gemini_client.dart';

import 'chat_ai_datasource.dart';

@Injectable(as: ChatAiDatasource)
class ChatAiDatasourceImpl implements ChatAiDatasource {
  final GeminiClient _client;

  ChatAiDatasourceImpl({required GeminiClient client}) : _client = client;

  @override
  Future<String> generateAnswer(String prompt) async {
    final data = {
      'contents': [
        {
          'parts': [
            {
              'text':
                  'Fale o significado do meu sonho, faça um resumo pequeno: $prompt',
            },
          ],
        },
      ],
    };

    final response = await _client.post(
      '/models/gemini-2.0-flash:generateContent',
      data: data,
    );

    final json = response.data as Map<String, dynamic>;
    final text =
        json['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
    return text ?? '';
  }
}
