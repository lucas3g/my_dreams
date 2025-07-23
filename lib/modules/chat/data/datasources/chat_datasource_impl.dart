import 'dart:ui';

import 'package:injectable/injectable.dart';

import 'package:my_dreams/core/data/clients/supabase/supabase_client_interface.dart';
import 'package:my_dreams/core/domain/entities/tables_db.dart';
import 'package:my_dreams/modules/chat/data/datasources/chat_ai_datasource.dart';
import 'package:my_dreams/modules/chat/domain/entities/conversation_entity.dart';
import 'package:my_dreams/modules/chat/domain/entities/message_entity.dart';
import 'package:my_dreams/core/domain/entities/app_language.dart';

import '../adapters/conversation_adapter.dart';
import '../adapters/message_adapter.dart';
import 'chat_datasource.dart';

@Injectable(as: ChatDatasource)
class ChatDatasourceImpl implements ChatDatasource {
  final ISupabaseClient _client;
  final ChatAiDatasource _ai;

  ChatDatasourceImpl({
    required ISupabaseClient supabaseClient,
    required ChatAiDatasource aiDatasource,
  }) : _client = supabaseClient,
       _ai = aiDatasource;

  @override
  Future<List<ConversationEntity>> getConversations(String userId) async {
    final data = await _client.select(
      table: TablesDB.conversations.name,
      columns: '*',
      orderBy: 'updated_at',
      filters: {'user_id': userId},
    );

    return data
        .map((e) => ConversationAdapter.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MessageEntity>> getMessages({
    required String conversationId,
    int limit = 20,
    int offset = 0,
  }) async {
    final data = await _client.select(
      table: TablesDB.messages.name,
      columns: '*',
      orderBy: 'created_at',
      filters: {'conversation_id': conversationId},
      limit: limit,
      offset: offset,
    );

    return data
        .map((e) => MessageAdapter.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MessageEntity>> sendMessage({
    required String userId,
    String? conversationId,
    required String content,
  }) async {
    String convId = conversationId ?? '';
    String summary = '';
    if (conversationId == null) {
      final conv = await _client.insertReturning(
        table: TablesDB.conversations.name,
        data: {
          'user_id': userId,
          'title': content.length > 30 ? content.substring(0, 30) : content,
          'summary': summary,
        },
      );
      convId = (conv.first)['id'] as String;
    } else {
      final conv = await _client.select(
        table: TablesDB.conversations.name,
        columns: 'summary',
        filters: {'id': conversationId},
      );
      if (conv.isNotEmpty) {
        summary = conv.first['summary'] as String? ?? '';
      }
      await _client.update(
        table: TablesDB.conversations.name,
        data: {'updated_at': DateTime.now().toIso8601String()},
        filters: {'id': conversationId},
      );
    }

    final userMessage = MessageEntity(
      id: '',
      conversationId: convId,
      sender: 'user',
      content: content,
      createdAt: DateTime.now(),
    );

    await _client.insert(
      table: TablesDB.messages.name,
      data: MessageAdapter.toMap(userMessage)..remove('id'),
    );

    final language = AppLanguage.fromString(
      PlatformDispatcher.instance.locale.toString(),
    );

    final aiContent = await _ai.generateAnswer(
      content,
      summary: summary,
      language: language,
    );
    final aiMessage = MessageEntity(
      id: '',
      conversationId: convId,
      sender: 'ai',
      content: aiContent,
      createdAt: DateTime.now(),
    );

    await _client.insert(
      table: TablesDB.messages.name,
      data: MessageAdapter.toMap(aiMessage)..remove('id'),
    );

    final newSummary = await _ai.generateConversationSummary(
      '${summary.isNotEmpty ? '$summary\n' : ''}Usu\u00E1rio: $content\nIA: $aiContent',
    );

    await _client.update(
      table: TablesDB.conversations.name,
      data: {
        'summary': newSummary,
        'updated_at': DateTime.now().toIso8601String(),
      },
      filters: {'id': convId},
    );

    return [userMessage, aiMessage];
  }
}
