import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/data/clients/gemini/gemini_client.dart';

import 'gemini_datasource.dart';

@Injectable(as: GeminiDatasource)
class GeminiDatasourceImpl implements GeminiDatasource {
  final GeminiClient _client;

  GeminiDatasourceImpl({required GeminiClient client}) : _client = client;

  @override
  Future<String> getMeaning(String dreamText) async {
    final data = {
      'contents': [
        {
          'parts': [
            {
              'text':
                  'Fale o significado do meu sonho, faça um resumo pequeno: $dreamText',
            },
          ],
        },
      ],
    };

    final response = await _client.post(
      '/models/gemini-2.0-flash:generateContent',
      data: data,
    );

    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    final String? text =
        json['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
    return text ?? '';
  }

  @override
  Future<String> createImage(String dreamText) async {
    final data = {
      'prompt': {
        'text':
            'Create an image that represents the following dream: $dreamText',
      },
    };

    final response = await _client.post(
      '/models/gemini-pro:generateImage',
      data: data,
    );

    final Map<String, dynamic> json = response.data as Map<String, dynamic>;
    return json['imageUrl'] as String? ?? '';
  }
}
