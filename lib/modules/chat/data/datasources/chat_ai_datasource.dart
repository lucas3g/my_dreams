import 'package:my_dreams/core/domain/entities/app_language.dart';

abstract class ChatAiDatasource {
  Future<String> generateAnswer(
    String prompt, {
    String? summary,
    required AppLanguage language,
  });

  Future<String> generateConversationSummary(String context);
}
