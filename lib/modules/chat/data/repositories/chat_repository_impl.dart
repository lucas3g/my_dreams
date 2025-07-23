import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';

import '../../domain/entities/chat_exception.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_datasource.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatDatasource _datasource;

  ChatRepositoryImpl({required ChatDatasource datasource})
      : _datasource = datasource;

  @override
  Future<EitherOf<AppFailure, List<ConversationEntity>>> getConversations(
      String userId) async {
    try {
      final data = await _datasource.getConversations(userId);
      return resolve(data);
    } catch (e) {
      return reject(ChatException(e.toString()));
    }
  }

  @override
  Future<EitherOf<AppFailure, List<MessageEntity>>> getMessages({
    required String conversationId,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final data = await _datasource.getMessages(
        conversationId: conversationId,
        limit: limit,
        offset: offset,
      );
      return resolve(data);
    } catch (e) {
      return reject(ChatException(e.toString()));
    }
  }

  @override
  Future<EitherOf<AppFailure, List<MessageEntity>>> sendMessage({
    required String userId,
    String? conversationId,
    required String content,
  }) async {
    try {
      final data = await _datasource.sendMessage(
        userId: userId,
        conversationId: conversationId,
        content: content,
      );
      return resolve(data);
    } catch (e) {
      return reject(ChatException(e.toString()));
    }
  }
}
