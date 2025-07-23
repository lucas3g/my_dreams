import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/data/clients/gemini/gemini_client.dart';

import 'chat_ai_datasource.dart';

@Injectable(as: ChatAiDatasource)
class ChatAiDatasourceImpl implements ChatAiDatasource {
  final GeminiClient _client;

  ChatAiDatasourceImpl({required GeminiClient client}) : _client = client;

  @override
  Future<String> generateAnswer(
    String prompt, {
    String? summary,
  }) async {
    final message = summary != null && summary.isNotEmpty
        ? 'Resumo do contexto da conversa: $summary\nUsu\u00E1rio: $prompt'
        : 'Fale o significado do meu sonho, fa\u00E7a um pequeno resumo: $prompt';

    final data = {
      'contents': [
        {
          'parts': [
            {
              'text': message,
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

  @override
  Future<String> generateConversationSummary(String context) async {
    final data = {
      'contents': [
        {
          'parts': [
            {
              'text': 'Resuma brevemente a conversa: $context',
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
