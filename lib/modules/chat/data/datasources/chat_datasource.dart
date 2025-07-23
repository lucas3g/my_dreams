import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';

abstract class ChatDatasource {
  Future<List<ConversationEntity>> getConversations(String userId);

  Future<List<MessageEntity>> getMessages({
    required String conversationId,
    int limit,
    int offset,
  });

  Future<List<MessageEntity>> sendMessage({
    required String userId,
    String? conversationId,
    required String content,
  });
}
