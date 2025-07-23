import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/data/clients/gemini/gemini_client.dart';
import 'package:my_dreams/core/domain/entities/app_language.dart';

import 'chat_ai_datasource.dart';

@Injectable(as: ChatAiDatasource)
class ChatAiDatasourceImpl implements ChatAiDatasource {
  final GeminiClient _client;

  ChatAiDatasourceImpl({required GeminiClient client}) : _client = client;

  @override
  Future<String> generateAnswer(
    String prompt, {
    String? summary,
    required AppLanguage language,
  }) async {
    final bool isEnglish = language == AppLanguage.english;

    String message = summary != null && summary.isNotEmpty
        ? isEnglish
            ? 'Conversation context summary: $summary\nUser: $prompt'
            : 'Resumo do contexto da conversa: $summary\nUsu\u00E1rio: $prompt'
        : isEnglish
            ? 'Explain the meaning of my dream, provide a short summary: $prompt'
            : 'Fale o significado do meu sonho, fa\u00E7a um pequeno resumo: $prompt';

    final tarotCommand =
        isEnglish ? 'Generate Tarot cards' : 'Gerar cartas de Tarô';

    if (message.contains(tarotCommand)) {
      message = isEnglish
          ? 'Generate Tarot cards, generate from 3 to 5 cards and display "Card 1: [title], Card 2: [title], ...", the titles must not contain **. Ask the user to choose one card and explain only its meaning, then finish the conversation.'
          : 'Gerar cartas de Tarô, gere de 3 a 5 cartas e exiba "Carta 1: [título], Carta 2: [título], ...", os títulos não devem conter ** e peça para o usuario escolher uma carta e explique o significado dela, mas de somente o significado e termine a conversa.';
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
