import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/data/clients/gemini/gemini_client.dart';

import 'gemini_datasource.dart';

@Injectable(as: GeminiDatasource)
class GeminiDatasourceImpl implements GeminiDatasource {
  final GeminiClient _client;

  GeminiDatasourceImpl({required GeminiClient client}) : _client = client;

  @override
  Stream<String> getMeaning(String dreamText) async* {
    final data = {
      'contents': [
        {
          'parts': [
            {'text': 'Fale o significado do meu sonho: $dreamText'},
          ],
        },
      ],
    };

    await for (final chunk in _client.postStream(
      '/models/gemini-2.0-flash:streamGenerateContent',
      data: data,
    )) {
      try {
        final Map<String, dynamic> json = jsonDecode(chunk);
        final String? text =
            json['candidates']?[0]?['content']?['parts']?[0]?['text']
                as String?;
        if (text != null) yield text;
      } catch (_) {
        // ignore invalid chunks
      }
    }
  }
}
