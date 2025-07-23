abstract class ChatAiDatasource {
  Future<String> generateAnswer(
    String prompt, {
    String? summary,
  });

  Future<String> generateConversationSummary(String context);
}
