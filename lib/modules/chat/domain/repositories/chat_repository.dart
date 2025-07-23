import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';

import '../entities/conversation_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  Future<EitherOf<AppFailure, List<ConversationEntity>>> getConversations(
      String userId);

  Future<EitherOf<AppFailure, List<MessageEntity>>> getMessages({
    required String conversationId,
    int limit = 20,
    int offset = 0,
  });

  Future<EitherOf<AppFailure, List<MessageEntity>>> sendMessage({
    required String userId,
    String? conversationId,
    required String content,
  });
}
