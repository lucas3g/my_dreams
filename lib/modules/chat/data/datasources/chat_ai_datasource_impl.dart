import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/data/clients/gemini/gemini_client.dart';

import 'chat_ai_datasource.dart';

@Injectable(as: ChatAiDatasource)
class ChatAiDatasourceImpl implements ChatAiDatasource {
  final GeminiClient _client;

  ChatAiDatasourceImpl({required GeminiClient client}) : _client = client;

  @override
  Future<String> generateAnswer(String prompt, {String? summary}) async {
    String message = summary != null && summary.isNotEmpty
        ? 'Resumo do contexto da conversa: $summary\nUsu\u00E1rio: $prompt'
        : 'Fale o significado do meu sonho, fa\u00E7a um pequeno resumo: $prompt';

    if (message.contains('Gerar uma carta de Taro')) {
      message =
          'Gerar uma carta de Taro, gere de 3 a 5 cartas e exiba "Carta 1: [título], Carta 2: [título], ...". e peça para o usuario escolher uma carta e explique o significado dela, mas de somente o significado e termine a conversa.';
    }

    final data = {
      'contents': [
        {
          'parts': [
            {'text': message},
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
            {'text': 'Resuma brevemente a conversa: $context'},
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
